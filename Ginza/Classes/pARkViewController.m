/*
 File: pARkViewController.m
 Abstract: Simple view controller for the pARk example. Provides a hard-coded list of places-of-interest to its associated ARView when loaded, starts the ARView when it appears, and stops it when it disappears.
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

#import "pARkViewController.h"
#import "PlaceOfInterest.h"
#import "ARView.h"
#import "RadarViewPortView.h"
#import "Offer.h"
#import "GinzaSubViewController.h"
#import "GinzaFilterViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "Categories.h"
#import "CustomCallOutView.h"

@implementation pARkViewController
@synthesize rotateImg,compassImg,trueNorth;
@synthesize compassDif,compassFault,calibrateBtn,lblFilterText,currentLocation,locationManager,slider,settingView,btnClose,lblDistance,btnSettings,orientation,lblEventCount,placesOfInterest,btnVMMode,btnBack,btnHelp,helpView,btnForward,btnReverse;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AR", @"AR");
        self.tabBarItem.image = [UIImage imageNamed:@"CameraIcon.png"];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"AR update location");
    currentLocation = newLocation;
    //if (radiusChanged == 1) {
    //[self updateView];
    radiusChanged=0;
    //}
    
    //
    
    
}


- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
    float x = acceleration.x;
    float y = acceleration.y;
    float z = acceleration.z;
    //NSLog(@"%f,%f,%f",x,y,z);
    if (z>-.7 && z<.7) {
        //NSLog(@"normal");
    }else
    {
        //self.tabBarController.selectedIndex =1;
    }
}
-(void)updateView
{
    ARView *arView = (ARView *)self.view;
    arView.currentDistance =5393913;
    arView.maxtDistance=5393913+50;
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *mapDataDict = deligate.poiDataDictionary;
    if (placesOfInterest==nil) {
        placesOfInterest = [NSMutableArray arrayWithCapacity:[mapDataDict count]];
        int i=0;
        for (id key in mapDataDict)
        {
            NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
            Offer *offer =[offerdataArray objectAtIndex:0];
            ShopList *merchant = [deligate getStoreDataById:offer.store_id];
            double latitude =[merchant.latitude doubleValue];
            double longitude = [merchant.longitude doubleValue];
            
            CustomCallOutView *popup =[[CustomCallOutView alloc]init];
            [popup prepareCallOutView:offer offerArray:offerdataArray];
            
            PlaceOfInterest *poi1 =[PlaceOfInterest placeOfInterestWithView:popup at:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] offerdata:offer];
            
            
            
            CLLocation *pointALocation = currentLocation;  
            NSLog(@"%f",currentLocation.coordinate.latitude);
            
            CLLocation *pointBLocation = [[CLLocation alloc] initWithLatitude:[merchant.latitude doubleValue] longitude:[merchant.longitude doubleValue]];  
            
            float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
            //float distanceMiles = (distanceMeters / 1609.344); 
            NSLog(@"No of poi's1 %f",distanceMeters);
            // if (distanceMeters<radius) {
            [placesOfInterest insertObject:poi1 atIndex:i++];
            //} 
        }
        
    }
   	[arView setPlacesOfInterest:placesOfInterest];	
}

-(IBAction)sliderChanged:(id)sender
{
    NSLog(@"slider changed");
    radius = self.slider.value;
    self.lblDistance.text =[NSString stringWithFormat:@"%d",radius];
    //[self updateView];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    //locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;
    //locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    //locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    //[locationManager startUpdatingLocation];
    [[UIAccelerometer sharedAccelerometer] setDelegate: self ];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:2.0f];
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[deligate.ginzaEvents count]];
    if ([deligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }
    
    
    NSString *filterCatString =@"";
    deligate.arraySelectedCategories =[[NSMutableArray alloc]init ];
    [deligate getCategories];
    [deligate getSubCategories];
    NSMutableArray *dataArray = [deligate getOfferData];
    for (int index=0; index<[deligate.arraySelectedCategories count]; index++) {
        
        Categories *c =(Categories *)[deligate getCategoryDataById:[deligate.arraySelectedCategories objectAtIndex:index]];
        filterCatString =[filterCatString stringByAppendingFormat:@"%@,",c.category_name];
    }
    self.lblFilterText.text = filterCatString;
    
    self.navigationController.navigationBarHidden = YES;
    
    
    
	ARView *arView = (ARView *)self.view;
	
    //RadarViewPortView *radar = [[RadarViewPortView alloc]init];
    radarView = [[Radar alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];	
    radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];
    
    
    NSMutableArray * radarPointValues= [[NSMutableArray alloc]initWithCapacity:[dataArray count]];
    for (int index=0; index<[dataArray count]; index++) {
        Offer *offer =[dataArray objectAtIndex:index];
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        
        PoiItem *item =[[PoiItem alloc]init];
        CGFloat alt = 0.0;
        float lat = [merchant.latitude floatValue];
        float lon = [merchant.longitude floatValue];
        
        CLLocation *tempLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(lat, lon) altitude:alt horizontalAccuracy:1.0 verticalAccuracy:1.0 timestamp:nil];
        PhysicalPlace *tempCoordinate = [PhysicalPlace coordinateWithLocation:tempLocation];
        
        
        [radarPointValues addObject:tempCoordinate];
        
    }
    radarView.pois = radarPointValues;
    radarView.radius = 5.0;
    [arView addSubview:radar];
    [arView addSubview:radarView];
    [arView bringSubviewToFront:btnSettings];
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 200, 120, 25)];
	[self.slider addTarget:self action:@selector(sliderChanged:)     forControlEvents:UIControlEventValueChanged];
    self.slider.transform = CGAffineTransformRotate(self.slider.transform, 90 * M_PI /180);
	self.slider.backgroundColor = [UIColor clearColor];
	self.slider.value = 0;
    
	[self.slider setMaximumValue:1000];
    self.settingView = [[UIView alloc]initWithFrame:self.view.frame];
    self.settingView.backgroundColor =[UIColor blackColor];
    // self.settingView.alpha = 0.8;
    btnClose = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 37)];
    [btnClose setTitle:@"閉じる" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:btnClose];
    
    [self.settingView addSubview:self.slider];
    [arView addSubview:self.settingView];
    self.settingView.hidden=YES;
    
    
    [self updateView];
    
    
    [self radarSpecificSettings];
    self.slider.value = 30;
    radius=30;
    self.lblDistance.text = [NSString stringWithFormat:@"%d m",30];
    self.orientation = UIInterfaceOrientationPortrait;
    
}
-(IBAction)btnMoveForward:(id)sender
{
    
    ARView *arView = (ARView *)self.view;
    arView.currentDistance =arView.currentDistance+1;
    //NSLog(@"Move forward = %f",arView.currentDistance);
    [arView setPlacesOfInterest:placesOfInterest];
}

-(IBAction)btnMoveReverse:(id)sender
{
    ARView *arView = (ARView *)self.view;
    arView.currentDistance =arView.currentDistance-1;
    //NSLog(@"Move reverse = %f",arView.currentDistance);
    [self updateView];
}
-(IBAction)btnClose:(id)sender
{
    [self.settingView setHidden:YES];
    ARView *arView = (ARView *)self.view;
    [radar removeFromSuperview];
    [radarView removeFromSuperview];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        radarView = [[Radar alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];	
        radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];
    }else
    {
        radarView = [[Radar alloc]initWithFrame:CGRectMake(402, 52, 65, 65)];	
        radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(402, 52, 65, 65)];
    }
    
    
    [arView addSubview:radarView];
    [arView addSubview:radar];
    [arView bringSubviewToFront:btnSettings];
    btnSettings.enabled = YES;
    [self updateView];
    //[btnSettings sendActionsForControlEvents:<#(UIControlEvents)#>];
}

-(IBAction)btnARViewClicked:(id)sender
{
    NSLog(@"AR Clicked");
    btnSettings.enabled = NO;
    [self.settingView setHidden:NO];
    ARView *arView = (ARView *)self.view;
    if (orientation == UIInterfaceOrientationPortrait) {
        
        CGRect rect = btnClose.frame;
        rect.origin = CGPointMake(self.view.frame.size.width-100, 10);
        btnClose.frame = rect;
        if (self.settingView.hidden == NO) {
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            radarView = [[Radar alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2-80, 170, 170)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2-80, 170, 170)];
            [arView addSubview:radarView];
            [arView addSubview:radar];
            [arView bringSubviewToFront:btnSettings];
        }else
        {
            
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            [arView.captureLayer setOrientation:AVCaptureVideoOrientationPortrait];
            [arView oriendationChangePortirt:self.view.frame];
            
            radarView = [[Radar alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];
            [arView addSubview:radarView];
            [arView addSubview:radar];
            [arView bringSubviewToFront:btnSettings];
        }
        self.settingView.frame = self.view.frame;
        self.slider.frame = CGRectMake(self.view.frame.size.width-100, 200, 120, 125);
        
        
        
        
    }else
    {
        
        if (self.settingView.hidden == NO) {
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            radarView = [[Radar alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
            [arView addSubview:radarView];
            [arView addSubview:radar];
            [arView bringSubviewToFront:btnSettings];
        }else
        {
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            
            [arView.captureLayer setOrientation:AVCaptureVideoOrientationLandscapeLeft];
            [arView oriendationChangeLandscape:self.view.frame];
            
            radarView = [[Radar alloc]initWithFrame:CGRectMake(402, 52, 65, 65)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(402, 52, 65, 65)];
            [arView addSubview:radarView];
            [arView addSubview:radar];  
            [arView bringSubviewToFront:btnSettings];
        }
        
        
        
        self.settingView.frame = self.view.frame;
        self.slider.frame =CGRectMake(self.view.frame.size.width-100, 100, 120, 125);
        
    }
	
    
    
}

-(void)radarSpecificSettings
{
    oldHeading          = 0;
    offsetG             = 0;
    newCompassTarget    = 0;
    
    // Set up location manager
    //locationManager=[[CLLocationManager alloc] init];
	//locationManager.desiredAccuracy = kCLLocationAccuracyBest;
	
    // We listen to events from the locationManager 
    //locationManager.delegate=self;
	
	if([CLLocationManager headingAvailable] == YES){
		NSLog(@"Heading is available");
	} else {
		NSLog(@"Heading isn't available");
	}
    
    // Start listening to events from locationManager
    //[locationManager startUpdatingHeading];
    //[locationManager stopUpdatingLocation];
    
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

- (IBAction)calibrate:(id)sender
{   
    // Set offset so the compassImg will be calibrated to northOffset
    northOffest = updatedHeading - 0;
    compassFault.text = [NSString stringWithFormat:@"Northoffset: %f",northOffest]; // Debug
}

- (void)updater:(NSTimer *)timer 
{
    // If the compass hasn't moved in a while we can calibrate the gyro 
    if(updatedHeading == oldHeading) {
        // NSLog(@"Update gyro");
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


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	ARView *arView = (ARView *)self.view;
	[arView start];
    [locationManager startUpdatingHeading];
    [locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    
	[super viewDidAppear:animated];
    [locationManager startUpdatingHeading];
    [locationManager startUpdatingLocation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
    
	ARView *arView = (ARView *)self.view;
	[arView stop];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    ARView *arView = (ARView *)self.view;
    
    CGRect rect = btnClose.frame;
    rect.origin = CGPointMake(self.view.frame.size.width-100, 50);
    btnClose.frame = rect;
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.orientation = UIInterfaceOrientationPortrait;
        if (self.settingView.hidden == NO) {
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            radarView = [[Radar alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2-80, 170, 170)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2-80, 170, 170)];
            [arView addSubview:radarView];
            [arView addSubview:radar];
            [arView bringSubviewToFront:btnSettings];
        }else
        {
            self.orientation = UIInterfaceOrientationLandscapeLeft;
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            [arView.captureLayer setOrientation:AVCaptureVideoOrientationPortrait];
            [arView oriendationChangePortirt:self.view.frame];
            
            radarView = [[Radar alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(252, 52, 65, 65)];
            [arView addSubview:radarView];
            [arView addSubview:radar];
            [arView bringSubviewToFront:btnSettings];
        }
        self.settingView.frame = self.view.frame;
        self.slider.frame = CGRectMake(self.view.frame.size.width-100, 170, 120, 125);
        
        
        
        
    }else
    {
        
        if (self.settingView.hidden == NO) {
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            radarView = [[Radar alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(50, 50, 200, 200)];
            [arView addSubview:radarView];
            [arView addSubview:radar];
            [arView bringSubviewToFront:btnSettings];
        }else
        {
            [radar removeFromSuperview];
            [radarView removeFromSuperview];
            
            [arView.captureLayer setOrientation:AVCaptureVideoOrientationLandscapeLeft];
            [arView oriendationChangeLandscape:self.view.frame];
            
            radarView = [[Radar alloc]initWithFrame:CGRectMake(402, 52, 65, 65)];	
            radar = [[RadarViewPortView alloc]initWithFrame:CGRectMake(402, 52, 65, 65)];
            UIButton *rButton = [[UIButton alloc]initWithFrame:CGRectMake(402, 52, 65, 65)];
            
            
            [arView addSubview:radarView];
            [arView addSubview:radar];  
            [arView bringSubviewToFront:btnSettings];
        }
        
        
        
        self.settingView.frame = self.view.frame;
        self.slider.frame =CGRectMake(self.view.frame.size.width-100, 84, 170, 125);
        
    }
	
	
	return YES;//interfaceOrientation == UIInterfaceOrientationPortrait;
}

-(IBAction)settingOpen:(id)sender
{
    NSLog(@"setting");
    self.settingView.hidden= NO;
}
-(IBAction)btnGinzaMenu:(id)sender
{
    GinzaSubViewController  *infoViewController = [[GinzaSubViewController alloc]init];
    infoViewController.currtentViewController = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoViewController animated:NO];
    
    CGRect rect = infoViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    infoViewController.view.frame =rect;
    
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = infoViewController.view.frame;
    rect1.origin.y = 0;
    infoViewController.view.frame =rect1;
    self.hidesBottomBarWhenPushed=YES;
    [UIView commitAnimations];
}


-(IBAction)GinzafilterViewDown:(id)sender
{
    GinzaFilterViewController  *filterViewController = [[GinzaFilterViewController alloc]init];
    CGRect rect = filterViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    filterViewController.view.frame =rect;
    
    filterViewController.currtentViewController = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:filterViewController animated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = filterViewController.view.frame;
    rect1.origin.y = 0;
    filterViewController.view.frame =rect1;
    self.hidesBottomBarWhenPushed=YES;
    [UIView commitAnimations];
    
}
#import "SubMenuSearchViewController.h"
-(IBAction)GinzaSearchView:(id)sender
{
    NSLog(@"testing ginza menu view");
    
    SubMenuSearchViewController  *searchViewController = [[SubMenuSearchViewController alloc]init];
    
    [self presentModalViewController:searchViewController animated:YES];
    
    
}
-(IBAction)btnVMModeOn:(id)sender
{
    self.btnVMMode.hidden=YES;
    self.btnBack.hidden =NO;
    self.btnForward.hidden =NO;
    self.btnReverse.hidden=NO;
    
}
-(IBAction)btnVMModeOff:(id)sender
{
    self.btnVMMode.hidden=NO;
    self.btnBack.hidden =YES;
    self.btnForward.hidden =YES;
    self.btnReverse.hidden=YES;
    
}


-(IBAction)btnHelp:(id)sender
{
    [self.view addSubview:self.helpView];
    
}
-(IBAction)btnHelpClose:(id)sender
{
    [self.helpView removeFromSuperview];
}

-(IBAction)btnPrevious:(id)sender
{
    
}
-(IBAction)btnNext:(id)sender
{
    NSLog(@"next");
}
@end
