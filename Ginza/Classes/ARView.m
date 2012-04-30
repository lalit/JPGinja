/*
 File: ARView.m
 Abstract: Augmented reality view. Displays a live camera feed with specified places-of-interest overlayed in the correct position based on the direction the user is looking. Uses Core Location to determine the user's location relative the places-of-interest and Core Motion to determine the direction the user is looking.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "ARView.h"
#import "PlaceOfInterest.h"
#import <AVFoundation/AVFoundation.h>
#import "Location.h"
#import "Radar.h"
#import "AppDelegate.h"
#import "RadarViewPortView.h"
#pragma mark -
#pragma mark Math utilities declaration

#define DEGREES_TO_RADIANS (M_PI/180.0)
#define degreesToRadianX(x) (M_PI * (x) / 180.0)

typedef float mat4f_t[16];	// 4x4 matrix in column major order
typedef float vec4f_t[4];	// 4D vector

// Creates a projection matrix using the given y-axis field-of-view, aspect ratio, and near and far clipping planes
void createProjectionMatrix(mat4f_t mout, float fovy, float aspect, float zNear, float zFar);

// Matrix-vector and matrix-matricx multiplication routines
void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v);
void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b);

// Initialize mout to be an affine transform corresponding to the same rotation specified by m
void transformFromCMRotationMatrix(vec4f_t mout, const CMRotationMatrix *m);

#pragma mark -
#pragma mark Geodetic utilities declaration

#define WGS84_A	(6378137.0)				// WGS 84 semi-major axis constant in meters
#define WGS84_E (8.1819190842622e-2)	// WGS 84 eccentricity

// Converts latitude, longitude to ECEF coordinate system
void latLonToEcef(double lat, double lon, double alt, double *x, double *y, double *z);

// Coverts ECEF to ENU coordinates centered at given lat, lon
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr, double yr, double zr, double *e, double *n, double *u);

#pragma mark -
#pragma mark ARView extension

@interface ARView () {
	UIView *captureView;
	AVCaptureSession *captureSession;
	
	
	CADisplayLink *displayLink;
	CMMotionManager *motionManager;
	CLLocationManager *locationManager;
	CLLocation *location;
	//NSArray *placesOfInterest;
	mat4f_t projectionTransform;
	mat4f_t cameraTransform;	
	vec4f_t *placesOfInterestCoordinates;
    
    int zoomLevel;
    BOOL iszButtonPressed;
    int lastvalue;
    
    RadarViewPortView *radar;
    Radar *radarView;
    
    CMDeviceMotionHandler motionHandler;
    NSOperationQueue    *opQ;
    
    // Graphics
    UIImageView         *rotateImg;
    UIImageView         *compassImg;
    UIImageView         *trueNorth;
    UILabel             *compassDif;
    UILabel             *compassFault;
    UIButton            *calibrateBtn;
    
    NSTimer             *updateTimer;
    

    
    float               oldHeading;
    float               updatedHeading;
    float               newYaw;
    float               oldYaw;
    float               offsetG;
    float               updateCompass;
    float               newCompassTarget;
    float               currentYaw;
    float               currentHeading;
    float               compassDiff;
    float               northOffest;
    
    int                 radiusChanged;
    float               currentDistance;
    int                 zoomlevel;

    BOOL                isFirstTime;
    
}

- (void)initialize;

- (void)startCameraPreview;
- (void)stopCameraPreview;
- (void)startCameraPreview:(NSString *)oriendation;

- (void)startLocation;
- (void)stopLocation;

- (void)startDeviceMotion;
- (void)stopDeviceMotion;

- (void)startDisplayLink;
- (void)stopDisplayLink;

- (void)updatePlacesOfInterestCoordinates;

- (void)onDisplayLink:(id)sender;
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

@end


#pragma mark -
#pragma mark ARView implementation

@implementation ARView
@synthesize captureLayer;
@synthesize placesOfInterest;
@synthesize  currentDistance,maxtDistance,interfaceOrientation,parentActionView,radius,poiData;

- (void)dealloc
{
	[self stop];
    [captureView removeFromSuperview];
	
	if (placesOfInterestCoordinates != NULL) {
		free(placesOfInterestCoordinates);
	}
	
}

- (void)start
{
	[self startCameraPreview];
	[self startLocation];
	[self startDeviceMotion];
	[self startDisplayLink];
}

- (void)stop
{
	[self stopCameraPreview];
	[self stopLocation];
	[self stopDeviceMotion];
	[self stopDisplayLink];
}

- (void)setPlacesOfInterest:(NSArray *)pois
{
	for (PlaceOfInterest *poi in [placesOfInterest objectEnumerator]) {
		[poi.view removeFromSuperview];
	}	
	
	placesOfInterest = [[NSArray alloc]initWithArray:pois];
	//placesOfInterest = pois;	
	if (location != nil) {
		[self updatePlacesOfInterestCoordinates];
	}
}

- (NSArray *)placesOfInterest
{
	return placesOfInterest;
}

-(void)oriendationChangeLandscape:(CGRect )viewSize
{
    //self.frame= viewSize;
    CGRect r = captureView.frame;
    r.origin.x= 0;r.origin.y=0;
    //NSLog(@"s =%f",viewSize.size.width);
    r.size =viewSize.size;
    captureLayer.frame=r;
    captureView.frame=r;
    captureLayer.bounds =r;
    captureView.bounds = r;
    
    // captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
	//captureLayer.frame = captureView.bounds =r;
	//[captureLayer setOrientation:AVCaptureVideoOrientationLandscapeLeft];
	//[captureLayer setVideoGravity:AVLayerVideoGravityResize];
    // [self stopCameraPreview];
    // [self startCameraPreview:@"landscapeLeft"];
    
    
    
    
}

-(void)oriendationChangePortirt:(CGRect )viewSize
{
    CGRect r = captureView.frame;
    r.origin.x= 0;r.origin.y=0;
    //NSLog(@"s =%f",viewSize.size.width);
    r.size =viewSize.size;
    captureLayer.frame=r;
    captureView.frame=r;
    captureLayer.bounds =r;
    captureView.bounds = r;
    
}
-(NSArray *)interfaceOrientationAtIndexes:(NSIndexSet *)indexes
{
    NSLog(@"index = %@",indexes);
}
-(void)oriendationChange
{
    // captureView.bounds = self.bounds;
}
- (void)initialize
{
    
    NSLog(@"ARView");
    isFirstTime =YES;
    self.currentDistance =150;
    self.maxtDistance=300;
	captureView = [[UIView alloc] initWithFrame:self.bounds];
	captureView.bounds = self.bounds;
	[self addSubview:captureView];
	[self sendSubviewToBack:captureView];
	
    //[self constructCalloutPOI];
    //[self createRadar];
    //[self radarSpecificSettings];
	// Initialize projection matrix	
	createProjectionMatrix(projectionTransform, 60.0f*DEGREES_TO_RADIANS, self.bounds.size.width*1.0f / self.bounds.size.height, 0.25f, 1000.0f);
}


-(void)createRadar
{
    //RadarViewPortView *radar = [[RadarViewPortView alloc]init];
    radarView = [[Radar alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];	
    radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];
    AppDelegate *deligate= (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *dataArray = [deligate getOfferData];
    //radar.superViewController = self;
    NSMutableArray * radarPointValues= [[NSMutableArray alloc]initWithCapacity:[dataArray count]];
    for (int index=0; index<[dataArray count]; index++) {
        Offer *offer =[dataArray objectAtIndex:index];
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        
        //PoiItem *item =[[PoiItem alloc]init];
        CGFloat alt = 0.0;
        float lat = [merchant.latitude floatValue];
        float lon = [merchant.longitude floatValue];
        
        CLLocation *tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:alt horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
        PhysicalPlace *tempCoordinate = [PhysicalPlace coordinateWithLocation:tempLocation];
        
        
        [radarPointValues addObject:tempCoordinate];
        
    }
    radarView.pois = radarPointValues;
    radarView.radius = 30.0;
    [radar.layer setZPosition:104.0f];
    [self addSubview:radar];
    [self addSubview:radarView];
    NSLog(@"%@",self.parentActionView);
    //[self.parentActionView addSubview:radar];
    //[self.parentActionView addSubview:radarView];

}
#import "CustomCallOutView.h"

-(void)constructCalloutPOI
{
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *mapDataDict = deligate.poiDataDictionary;
    placesOfInterest = [[[NSMutableArray alloc]init]retain];
    self.poiData =[[[NSMutableArray alloc]init]retain];
    NSLog(@"UPdate view loop start1 %@",[NSDate date]);
    int i=0;
    for (id key in mapDataDict)
    {
        NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
        Offer *offer =[offerdataArray objectAtIndex:0];
        NSLog(@"Callout construction ARView %@",offer.offer_id);
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        double latitude =[merchant.latitude doubleValue];
        double longitude = [merchant.longitude doubleValue];
        
        //For testing
        //CLLocation *pointALocation = currentLocation;
        //CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        //CLLocation *pointBLocation = [[CLLocation alloc] initWithLatitude:[merchant.latitude doubleValue] longitude:[merchant.longitude doubleValue]];  
        
        // float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        //radius=250;
        //if (distanceMeters >= currentDistance /*&& distanceAndIndex->distance<=self.maxtDistance*/) {
        
        //if (distanceMeters<radius) {
        
        CustomCallOutView *popup =[[CustomCallOutView alloc]init];
        popup.currentLocation = [[Location sharedInstance]currentLocation];
        
        popup.parentViewController = deligate.arviewController;
        [popup prepareCallOutView:offer offerArray:offerdataArray];
        
        PlaceOfInterest *poi1 =[PlaceOfInterest placeOfInterestWithView:popup at:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] offerdata:offer];
        //[self.placesOfInterest insertObject:poi1 atIndex:i++];
        [self.poiData addObject:poi1];
        
        //}
        
        //}
    }
    self.placesOfInterest = [[self.poiData copy]retain];
    NSLog(@"UPdate view loop end %@",[NSDate date]);   
   
}


-(void)updateView
{
    NSLog(@"Update view");
    int i =0;
    //int radius=0;
    if ([self.poiData count]==0) {
        [self constructCalloutPOI];
    }
    self.placesOfInterest = [self.poiData copy];
    NSMutableArray *placesOfInterestTemp = [[NSMutableArray alloc]init ];
    for (PlaceOfInterest *poi in self.placesOfInterest) {
        //NSLog(@"UPdate view POI %@",[NSDate date]);
        CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        CLLocation *pointBLocation = poi.location;  
        
        float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        distanceMeters = distanceMeters -currentDistance;
        //NSLog(@"distanceMeters = %f,%f,%f",distanceMeters,currentDistance,radius);
        //radius=250;
        if (distanceMeters >= currentDistance /*&& distanceAndIndex->distance<=self.maxtDistance*/) {
            NSLog(@"radius = %f",radius);
            if (distanceMeters<radius) {
                [placesOfInterestTemp insertObject:poi atIndex:i++];
            }
            
        }
        
    }
    radar.placesOfInterest = placesOfInterestTemp;
    [radar setNeedsDisplay];
    
    
   	[self setPlacesOfInterest:placesOfInterestTemp];	
}

-(void)radarSpecificSettings
{
    oldHeading          = 0;
    offsetG             = 0;
    newCompassTarget    = 0;
    
    // Set up motionManager
    motionManager = [[CMMotionManager alloc]  init];
    motionManager.deviceMotionUpdateInterval = 1.0/60.0;
    opQ = [NSOperationQueue currentQueue] ;
    
    if(motionManager.isDeviceMotionAvailable) {
        
        // Listen to events from the motionManager
        motionHandler = ^ (CMDeviceMotion *motion, NSError *error) {
            CMAttitude *currentAttitude = motion.attitude;
            float yawValue = currentAttitude.yaw; // Use the yaw value
            
            // Yaw values are in radians (-180 - 180), here we convert to degrees
            float yawDegrees = CC_RADIANS_TO_DEGREES(yawValue);
            currentYaw = yawDegrees;
            
            // We add new compass value together with new yaw value
            yawDegrees = newCompassTarget + (yawDegrees - offsetG);
            
            // Degrees should always be positive
            if(yawDegrees < 0) {
                yawDegrees = yawDegrees + 360;
            }
            
            compassDif.text = [NSString stringWithFormat:@"Gyro: %f",yawDegrees]; // Debug
            
            float gyroDegrees = (yawDegrees*radianConst);
            
            // If there is a new compass value the gyro graphic animates to this position
            if(updateCompass) {
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.25];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                [rotateImg setTransform:CGAffineTransformMakeRotation(gyroDegrees)];
                [UIView commitAnimations];
                updateCompass = 0;
                
            } else {
                rotateImg.transform = CGAffineTransformMakeRotation(gyroDegrees);
            }
        };
        
        
    } else {
        NSLog(@"No Device Motion on device.");
        
    }
    
    // Start listening to motionManager events
    [motionManager startDeviceMotionUpdatesToQueue:opQ withHandler:motionHandler];
    
    // Start interval to run every other second
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updater:) userInfo:nil repeats:YES];
}


- (void)updater:(NSTimer *)timer 
{
    // If the compass hasn't moved in a while we can calibrate the gyro 
    if(updatedHeading == oldHeading) {
        NSLog(@"Update gyro");
        // Populate newCompassTarget with new compass value and the offset we set in calibrate
        newCompassTarget = (0 - updatedHeading) + northOffest;
        compassFault.text = [NSString stringWithFormat:@"newCompassTarget: %f",newCompassTarget]; // Debug
        offsetG = currentYaw;
        updateCompass = 1;
    } else {
        updateCompass = 0;
    }
    
    oldHeading = updatedHeading;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // Update variable updateHeading to be used in updater method
    updatedHeading = newHeading.magneticHeading;
    float headingFloat = 0 - newHeading.magneticHeading;
    
    // Update rotation of graphic compassImg
    compassImg.transform = CGAffineTransformMakeRotation((headingFloat + northOffest)*radianConst); 
    
    // Update rotation of graphic trueNorth
    radar.transform = CGAffineTransformMakeRotation(headingFloat*radianConst);    
}


- (void)startCameraPreview:(NSString *)oriendation
{	
	AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (camera == nil) {
		return;
	}
	
	captureSession = [[AVCaptureSession alloc] init];
	AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:nil] ;
    
    
	[captureSession addInput:newVideoInput];
	
	captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
	captureLayer.frame = captureView.bounds;
    if ([oriendation isEqualToString:@"landscapeLeft"]) {
        [captureLayer setOrientation:AVCaptureVideoOrientationLandscapeLeft];
    }else if ([oriendation isEqualToString:@"landscapeRight"]) {
        [captureLayer setOrientation:AVCaptureVideoOrientationLandscapeRight];
    }else
    {
        [captureLayer setOrientation:AVCaptureVideoOrientationPortrait];
    }
	//[captureLayer setOrientation:AVCaptureVideoOrientationPortrait];
	[captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	[captureView.layer addSublayer:captureLayer];
	
	// Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[captureSession startRunning];
	});
}


- (void)startCameraPreview
{	
	AVCaptureDevice* camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if (camera == nil) {
		return;
	}
	
	captureSession = [[AVCaptureSession alloc] init];
    
	AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:nil] ;
	[captureSession addInput:newVideoInput];
	
	captureLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:captureSession];
	captureLayer.frame = captureView.bounds;
	//[captureLayer setOrientation:AVCaptureVideoOrientationPortrait];
	[captureLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
	[captureView.layer addSublayer:captureLayer];
	
	// Start the session. This is done asychronously since -startRunning doesn't return until the session is running.
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		[captureSession startRunning];
	});
}

- (void)stopCameraPreview
{	
	[captureSession stopRunning];
	[captureLayer removeFromSuperlayer];
	
	captureSession = nil;
	captureLayer = nil;
}

- (void)startLocation
{
	
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = 100.0;
	[locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
}

- (void)stopLocation
{
	[locationManager stopUpdatingLocation];
	
	locationManager = nil;
}

- (void)startDeviceMotion
{	
	motionManager = [[CMMotionManager alloc] init];
	
	// Tell CoreMotion to show the compass calibration HUD when required to provide true north-referenced attitude
	motionManager.showsDeviceMovementDisplay = YES;
    
	
	motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
	
	// New in iOS 5.0: Attitude that is referenced to true north
	[motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
}

- (void)stopDeviceMotion
{
	[motionManager stopDeviceMotionUpdates];
	
	motionManager = nil;
}

- (void)startDisplayLink
{
	displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink:)];
	[displayLink setFrameInterval:1];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopDisplayLink
{
	[displayLink invalidate];
	
	displayLink = nil;		
}

- (void)updatePlacesOfInterestCoordinates
{
	NSLog(@"updatePlacesOfInterestCoordinates start ");
	if (placesOfInterestCoordinates != NULL) {
		free(placesOfInterestCoordinates);
	}
   // NSLog(@"placesOfInterest = %d",[placesOfInterest count]);
    
   	placesOfInterestCoordinates = (vec4f_t *)malloc(sizeof(vec4f_t)*placesOfInterest.count);
    
	int i = 0;
	
	double myX, myY, myZ;
	latLonToEcef(location.coordinate.latitude, location.coordinate.longitude, 0.0, &myX, &myY, &myZ);
    
	// Array of NSData instances, each of which contains a struct with the distance to a POI and the
	// POI's index into placesOfInterest
	// Will be used to ensure proper Z-ordering of UIViews
	typedef struct {
		float distance;
		int index;
	} DistanceAndIndex;
	NSMutableArray *orderedDistances = [NSMutableArray arrayWithCapacity:placesOfInterest.count];
    
	// Compute the world coordinates of each place-of-interest
	for (PlaceOfInterest *poi in [[self placesOfInterest] objectEnumerator]) {
		double poiX, poiY, poiZ, e, n, u;
		
		latLonToEcef(poi.location.coordinate.latitude, poi.location.coordinate.longitude, 0.0, &poiX, &poiY, &poiZ);
		ecefToEnu(location.coordinate.latitude, location.coordinate.longitude, myX, myY, myZ, poiX, poiY, poiZ, &e, &n, &u);
		
		placesOfInterestCoordinates[i][0] = (float)n;
		placesOfInterestCoordinates[i][1]= -(float)e;
		placesOfInterestCoordinates[i][2] = 0.0f;
		placesOfInterestCoordinates[i][3] = 1.0f;
		
		// Add struct containing distance and index to orderedDistances
		DistanceAndIndex distanceAndIndex;
		distanceAndIndex.distance = sqrtf(n*n + e*e);
        
       // NSLog(@"distance index = %f",distanceAndIndex.distance);
		distanceAndIndex.index = i;
		[orderedDistances insertObject:[NSData dataWithBytes:&distanceAndIndex length:sizeof(distanceAndIndex)] atIndex:i++];
	}
	
	// Sort orderedDistances in ascending order based on distance from the user
	[orderedDistances sortUsingComparator:(NSComparator)^(NSData *a, NSData *b) {
		const DistanceAndIndex *aData = (const DistanceAndIndex *)a.bytes;
		const DistanceAndIndex *bData = (const DistanceAndIndex *)b.bytes;
		if (aData->distance < bData->distance) {
			return NSOrderedAscending;
		} else if (aData->distance > bData->distance) {
			return NSOrderedDescending;
		} else {
			return NSOrderedSame;
		}
	}];
	
	// Add subviews in descending Z-order so they overlap properly
    int zPos = 250;
	for (NSData *d in [orderedDistances reverseObjectEnumerator]) {
		const DistanceAndIndex *distanceAndIndex = (const DistanceAndIndex *)d.bytes;
		PlaceOfInterest *poi = (PlaceOfInterest *)[placesOfInterest objectAtIndex:distanceAndIndex->index];	
        //poi.view.hidden = YES;
       [poi.view.layer setZPosition:zPos--];
       [self addSubview:poi.view];
      
		
	}	
    
    NSLog(@"updatePlacesOfInterestCoordinates end ");
}

- (void)onDisplayLink:(id)sender
{
	CMDeviceMotion *d = motionManager.deviceMotion;
	if (d != nil) {
		CMRotationMatrix r = d.attitude.rotationMatrix;
		transformFromCMRotationMatrix(cameraTransform, &r);
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect
{
	if (placesOfInterestCoordinates == nil) {
		return;
	}
	
	mat4f_t projectionCameraTransform;
	multiplyMatrixAndMatrix(projectionCameraTransform, projectionTransform, cameraTransform);
	
	int i = 0;
    int zPos = 250;
	for (PlaceOfInterest *poi in [placesOfInterest objectEnumerator]) {
		vec4f_t v;
		multiplyMatrixAndVector(v, projectionCameraTransform, placesOfInterestCoordinates[i]);
		createProjectionMatrix(projectionTransform, 60.0f*DEGREES_TO_RADIANS, self.bounds.size.width*1.0f / self.bounds.size.height, 0.25f, 1000.0f);
        
        CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        //NSLog(@"%f",currentLocation.coordinate.latitude);
        
        CLLocation *pointBLocation = poi.location;  
        
        float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        distanceMeters = distanceMeters -currentDistance;
		float x = (v[0] / v[3] + 1.0f) * 0.5f;
		float y = (v[1] / v[3] + 1.0f) * 0.5f;
		if (v[2] < 0.0f) {
			poi.view.center = CGPointMake(x*self.bounds.size.width, self.bounds.size.height-y*self.bounds.size.height);
            float scaleFactor = 1.0 - 1.0 * (distanceMeters / 250);
           
            CGRect rec = poi.view.frame;
            rec.size.width = (172*scaleFactor)+172;
            rec.size.height = (163*scaleFactor)+163;
            poi.view.frame =rec;
            //[poi.view setNeedsLayout];
            //NSLog(@"%d",[UIDevice currentDevice].orientation);
            if ([UIDevice currentDevice].orientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                
                radar.center = CGPointMake(252+32.5, 52+32.5);
                radarView.center = CGPointMake(252+32.5, 52+32.5); 
            }
            if([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeRight)
            {
                
                poi.view.transform = CGAffineTransformIdentity;
                poi.view.transform = CGAffineTransformMakeRotation(degreesToRadianX(90));
                [poi.view.layer setZPosition:100.0f];
                
                radar.center = CGPointMake(172, self.frame.size.width - 35);
                [radar.layer setZPosition:101.0f];
                radarView.center = CGPointMake(172, self.frame.size.width - 35); 
            }else if([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft)
            {
                poi.view.transform = CGAffineTransformIdentity;
                poi.view.transform = CGAffineTransformMakeRotation(degreesToRadianX(-90));
                [poi.view.layer setZPosition:100.0f];
                
                radar.center = CGPointMake(35+50, 35);
                [radar.layer setZPosition:101.0f];
                radarView.center = CGPointMake(35+50, 35); 

                
            }
            else
            {
                CATransform3D transform = CATransform3DIdentity;
                if (poi.view.frame.origin.x<20) {
                    transform.m34 = 1.0 / -500.0;
                    transform = CATransform3DRotate(transform,  (M_PI / 6.0) , 0, .1, 0);
                    [poi.view.layer setZPosition:100.0f];
                }
                if (poi.view.frame.origin.x + (poi.view.frame.size.width/2)>(self.frame.size.width - 20.0f)) {
                    transform.m34 = 1.0 / 500.0;
                    transform = CATransform3DRotate(transform,  (M_PI / 6.0) , 0, .1, 0);
                    [poi.view.layer setZPosition:100.0f];
                }
                poi.view.layer.transform = transform;
            }

            
            
			poi.view.hidden = NO;
            
                       
		} else {
			poi.view.hidden = YES;
		}
		i++;
	}
    
}


- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second {
	
	float longitudinalDifference	= second.longitude - first.longitude;
	float latitudinalDifference		= second.latitude  - first.latitude;
	float possibleAzimuth			= (M_PI * .5f) - atan(latitudinalDifference / longitudinalDifference);
	
	if (longitudinalDifference > 0) 
		return possibleAzimuth;
	else if (longitudinalDifference < 0) 
		return possibleAzimuth + M_PI;
	else if (latitudinalDifference < 0) 
		return M_PI;
	
	return 0.0f;
}


- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"location started");
    // for shairing current location added by mobiquest
	[Location sharedInstance].currentLocation=newLocation;
	location = newLocation;
    
    //for testing
    location = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
    if (isFirstTime) {
        
        [self constructCalloutPOI];
        [self createRadar];
        isFirstTime = NO;
    }
	if (placesOfInterest != nil) {
        
        [self updateView];
		[self updatePlacesOfInterestCoordinates];
	}	
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}
/*
-(void)ZoomINOUT
{
    zoomLevel =angle*10;
    
    
    if (lastvalue != zoomLevel && iszButtonPressed) {
        if (lastvalue>0) {
            CGFloat cameraTransformX = zoom;
            CGFloat cameraTransformY = zoom;
            self.camera.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, cameraTransformX, cameraTransformY);
        }
        if (lastvalue<0) {
            CGFloat cameraTransformX = 1/zoom;
            CGFloat cameraTransformY = 1/zoom;
            picker.cameraViewTransform = CGAffineTransformScale(picker.cameraViewTransform, cameraTransformX, cameraTransformY);
        }
        
    }
    lastvalue = zoomLevel;
}*/

@end

#pragma mark -
#pragma mark Math utilities definition

// Creates a projection matrix using the given y-axis field-of-view, aspect ratio, and near and far clipping planes
void createProjectionMatrix(mat4f_t mout, float fovy, float aspect, float zNear, float zFar)
{
	float f = 1.0f / tanf(fovy/2.0f);
	
	mout[0] = f / aspect;
	mout[1] = 0.0f;
	mout[2] = 0.0f;
	mout[3] = 0.0f;
	
	mout[4] = 0.0f;
	mout[5] = f;
	mout[6] = 0.0f;
	mout[7] = 0.0f;
	
	mout[8] = 0.0f;
	mout[9] = 0.0f;
	mout[10] = (zFar+zNear) / (zNear-zFar);
	mout[11] = -1.0f;
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 2 * zFar * zNear /  (zNear-zFar);
	mout[15] = 0.0f;
}

// Matrix-vector and matrix-matricx multiplication routines
void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v)
{
	vout[0] = m[0]*v[0] + m[4]*v[1] + m[8]*v[2] + m[12]*v[3];
	vout[1] = m[1]*v[0] + m[5]*v[1] + m[9]*v[2] + m[13]*v[3];
	vout[2] = m[2]*v[0] + m[6]*v[1] + m[10]*v[2] + m[14]*v[3];
	vout[3] = m[3]*v[0] + m[7]*v[1] + m[11]*v[2] + m[15]*v[3];
}

void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b)
{
	uint8_t col, row, i;
	memset(c, 0, 16*sizeof(float));
	
	for (col = 0; col < 4; col++) {
		for (row = 0; row < 4; row++) {
			for (i = 0; i < 4; i++) {
				c[col*4+row] += a[i*4+row]*b[col*4+i];
			}
		}
	}
}

// Initialize mout to be an affine transform corresponding to the same rotation specified by m
void transformFromCMRotationMatrix(vec4f_t mout, const CMRotationMatrix *m)
{
	mout[0] = (float)m->m11;
	mout[1] = (float)m->m21;
	mout[2] = (float)m->m31;
	mout[3] = 0.0f;
	
	mout[4] = (float)m->m12;
	mout[5] = (float)m->m22;
	mout[6] = (float)m->m32;
	mout[7] = 0.0f;
	
	mout[8] = (float)m->m13;
	mout[9] = (float)m->m23;
	mout[10] = (float)m->m33;
	mout[11] = 0.0f;
	
	mout[12] = 0.0f;
	mout[13] = 0.0f;
	mout[14] = 0.0f;
	mout[15] = 1.0f;
}

#pragma mark -
#pragma mark Geodetic utilities definition

// References to ECEF and ECEF to ENU conversion may be found on the web.

// Converts latitude, longitude to ECEF coordinate system
void latLonToEcef(double lat, double lon, double alt, double *x, double *y, double *z)
{   
	double clat = cos(lat * DEGREES_TO_RADIANS);
	double slat = sin(lat * DEGREES_TO_RADIANS);
	double clon = cos(lon * DEGREES_TO_RADIANS);
	double slon = sin(lon * DEGREES_TO_RADIANS);
	
	double N = WGS84_A / sqrt(1.0 - WGS84_E * WGS84_E * slat * slat);
	
	*x = (N + alt) * clat * clon;
	*y = (N + alt) * clat * slon;
	*z = (N * (1.0 - WGS84_E * WGS84_E) + alt) * slat;
}

// Coverts ECEF to ENU coordinates centered at given lat, lon
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr, double yr, double zr, double *e, double *n, double *u)
{
	double clat = cos(lat * DEGREES_TO_RADIANS);
	double slat = sin(lat * DEGREES_TO_RADIANS);
	double clon = cos(lon * DEGREES_TO_RADIANS);
	double slon = sin(lon * DEGREES_TO_RADIANS);
	double dx = x - xr;
	double dy = y - yr;
	double dz = z - zr;
	
	*e = -slon*dx  + clon*dy;
	*n = -slat*clon*dx - slat*slon*dy + clat*dz;
	*u = clat*clon*dx + clat*slon*dy + slat*dz;
}
