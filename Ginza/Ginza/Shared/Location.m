//
//  Location.m
//  Ginza
//
//  Created by Ashok Agrawal on 4/21/12.
//  Copyright (c) 2012 Mobiquest Pte Ltd. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize currentLocation;
@synthesize mLocationManager;
@synthesize mCurrentLocation;

static Location *gInstance = NULL;



#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
double DegreesToRadians(double degrees) {return degrees * M_PI / 180.0;};
double RadiansToDegrees(double radians) {return radians * 180.0/M_PI;};

- (double) bearingToLocation:(CLLocation *) destinationLocation {
    double lat1 = DegreesToRadians(currentLocation.coordinate.latitude);
    double lon1 = DegreesToRadians(currentLocation.coordinate.longitude);
    double lat2 = DegreesToRadians(destinationLocation.coordinate.latitude);
    double lon2 = DegreesToRadians(destinationLocation.coordinate.longitude);
    double dLon = lon2 - lon1;
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    if(radiansBearing < 0.0)
        radiansBearing += 2*M_PI;
    return DegreesToRadians(radiansBearing);
}

+ (Location *) sharedInstance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    return (gInstance);
}

- (void) updateCurrentLocation {
    if (mLocationManager==nil) {
        mLocationManager = [[CLLocationManager alloc] init];
        mLocationManager.delegate = self;
        mLocationManager.distanceFilter =1; // whenever we move
        mLocationManager.headingFilter = 5;
        mLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
        [mLocationManager startUpdatingLocation];
        [mLocationManager startUpdatingHeading];
    }
}
#pragma mark CLLocation Delegates methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.mCurrentLocation=newLocation;
 
}
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    mHeading = newHeading.magneticHeading;
    [[NSNotificationCenter defaultCenter] 
     postNotificationName:kLocationChangedNotification 
     object:self];
}
- (void) stopUpdateLocation {
    if (mLocationManager) {
       [mLocationManager stopUpdatingLocation];
       mLocationManager.delegate=nil;
       [mLocationManager release];
       mLocationManager=nil;
    }
}

//Get Distance
- (double) getDistanceFromLatitude:(double)aLatitude
                      andLongitude:(double)aLongitude {
    CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:aLatitude longitude:aLongitude];
    CLLocationDistance meters = [self.mCurrentLocation distanceFromLocation:storeLocation];
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    double dkm=me/1000;
    return dkm;
}

//getTime;
- (double) getTimeFromLatitude:(double)aLatitude 
                  andLongitude:(double)aLongitude {
    CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:aLatitude longitude:aLongitude];
    CLLocationDistance meters = [self.mCurrentLocation distanceFromLocation:storeLocation];
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    return time;
}
// Get Angle;
- (double) getAngleFromLatitude:(double)aLatitude 
                   andLongitude:(double)aLongitude {
    CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:aLatitude longitude:aLatitude];
    double angle=((([self bearingToLocation:storeLocation])- mHeading)*M_PI)/180;
    return angle;
}

//Format Distance; 
- (NSString *)formatDistance:(double)aDistance {
    NSString *strDistance=@"";
    if (aDistance>MIN_DISTANCE) strDistance=@"距離計測不能";
    else if (aDistance>1.0) strDistance=[NSString stringWithFormat:@"%.1fkm",aDistance];
    else strDistance=[NSString stringWithFormat:@"%.fm",aDistance];
    return strDistance;
}

//Format Time;
- (NSString *) formatTime:(int) aTime {
    NSString *strTime=@"";
    if (aTime>=60) {
        int hours=aTime/60;
        if (hours>1) strTime=@"(徒歩圏外)"; 
        else if (hours==1) strTime=@"(1時間)";
    }
    else {
        strTime=[NSString stringWithFormat:@"(%d分)",aTime];
    }
    return  strTime;
}

@end
