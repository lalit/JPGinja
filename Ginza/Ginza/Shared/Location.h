//
//  Location.h
//  Ginza
//
//  Created by Ashok Agrawal on 4/21/12.
//  Copyright (c) 2012 Mobiquest Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define MIN_DISTANCE 7.0
#define kLocationChangedNotification @"LocationChangedNotification"

@interface Location : NSObject<CLLocationManagerDelegate> {
    CLLocation *currentLocation;
    CLLocation *mCurrentLocation;
     float mHeading;
}

@property(nonatomic, retain) CLLocationManager *mLocationManager;
@property(nonatomic,retain)  CLLocation *currentLocation;
@property(nonatomic,retain)   CLLocation *mCurrentLocation;

+ (Location *) sharedInstance;

- (void) updateCurrentLocation ;
- (double) getDistanceFromLatitude:(double)aLatitude
                      andLongitude:(double)aLongitude;
- (double) getTimeFromLatitude:(double)aLatitude 
                  andLongitude:(double)aLongitude;
- (NSString *)formatDistance:(double)aDistance;
- (NSString *) formatTime:(int) aTime;
- (double) getAngleFromLatitude:(double)aLatitude 
                   andLongitude:(double)aLongitude;
@end
