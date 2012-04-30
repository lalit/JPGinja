
#import "RadarViewPortView.h"
#import "AppDelegate.h"
#import "Location.h"
#import "PlaceOfInterest.h"
#import "pARkViewController.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation RadarViewPortView
@synthesize newAngle, referenceAngle,RADIUS = _RADIUS,superViewController,placesOfInterest;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    self.RADIUS = 30;//frame.size.width/2;
    self.backgroundColor = [UIColor clearColor];
    isFirstAccess = YES;
    newAngle = 45.0;
    referenceAngle = 247.5;
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    //NSMutableArray *poiArray = ((pARkViewController *)superViewController).placesOfInterest;

    for (PlaceOfInterest *poi in self.placesOfInterest) {
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CLLocation *currentLocation=[[Location sharedInstance] currentLocation];
        currentLocation =[[CLLocation alloc] initWithLatitude:35.67163555  longitude:139.76395295];;        
        float heading = [self getHeadingFromCoordinate:currentLocation toCoordinate:poi.location];
        //NSLog(@"heading = %f",heading);
        
        float radius = self.RADIUS-10;
        float x0 = 0.0; 
        float y0 = 0.0;
        
        //leave in radians and subtract from PI to rotate 180
        float angle = M_PI - heading; 
        //angle = angle*(180 / M_PI);
        //NSLog(@"angle = %f,%f",angle,M_PI);
        
        float x1 = (x0 + radius * sin(angle));   
        float y1 = (y0 + radius * cos(angle)); 
        
        NSLog(@"distance = %f,%f,%f",x1,y1,self.RADIUS);
        
        CGContextMoveToPoint(contextRef, self.RADIUS, self.RADIUS);
        CGContextFillEllipseInRect(contextRef, CGRectMake(x1+30,y1+30, 2, 2));
        //CGContextFillRect(contextRef, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        CGContextFillEllipseInRect(contextRef, CGRectMake(29, 29,5,5));
        AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
        deligate.arviewController.lblMessage.hidden=YES;

    }

    return;
       CGContextRef contextRef = UIGraphicsGetCurrentContext();
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *mapDataDict = deligate.poiDataDictionary;
    for (id key in mapDataDict)
    {
        NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
        Offer *offer =[offerdataArray objectAtIndex:0];
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        double latitude =[merchant.latitude doubleValue];
        double longitude = [merchant.longitude doubleValue];
        CLLocation *currentLocation=[[Location sharedInstance] currentLocation];
        currentLocation =[[CLLocation alloc] initWithLatitude:35.67163555  longitude:139.76395295];;
        CLLocation *storelocation =[[CLLocation alloc] initWithLatitude: latitude longitude:longitude];;
        
        float heading = [self getHeadingFromCoordinate:currentLocation toCoordinate:storelocation];
        //NSLog(@"heading = %f",heading);
        
        float radius = self.RADIUS;
        float x0 = 0.0; 
        float y0 = 0.0;
        
        //leave in radians and subtract from PI to rotate 180
        float angle = M_PI - heading; 
        
        float x1 = (x0 + radius * sin(angle));   
        float y1 = (y0 + radius * cos(angle)); 
        
        NSLog(@"distance = %f,%f",x1,y1);
        
        
        CGContextFillEllipseInRect(contextRef, CGRectMake(x1,y1, 2, 2));
    }

   
}


-(float) getHeadingFromCoordinate:(CLLocation*)fromLocation toCoordinate:(CLLocation*)toLocation
{
    float flat = fromLocation.coordinate.latitude;
    float flon = fromLocation.coordinate.longitude;
    float tlat = toLocation.coordinate.latitude;
    float tlon = toLocation.coordinate.longitude;
    
    //convert to radians
    flat = (M_PI * flat)/180;
    flon = (M_PI * flon)/180;
    tlat = (M_PI * tlat)/180;
    tlon = (M_PI * tlon)/180;
    
    float heading = atan2(sin(tlon-flon)* cos(tlat), cos(flat)*sin(tlat)-sin(flat)*cos(tlat)*cos(tlon-flon));
    [self addTargetIndicatorWithHeading:heading andDistance:100.0];
    return heading;
}

-(void) addTargetIndicatorWithHeading:(float)heading andDistance:(float)distance{
    //draw target indicators
    //need to convert radians and distance to cartesian coordinates
    float radius = 50;
    float x0 = 50.0; 
    float y0 = 50.0;
    
    //leave in radians and subtract from PI to rotate 180
    float angle = M_PI - heading; 
    
    float x1 = (x0 + radius * sin(angle));   
    float y1 = (y0 + radius * cos(angle)); 
    
    //NSLog(@"distance = %f,%f",x1,y1);
    
    
}



@end
