

#import <Foundation/Foundation.h>
#import "PoiItem.h"

#import <CoreLocation/CoreLocation.h>

//This class is used to represend a physically place in a virtual world. 
@interface PhysicalPlace : PoiItem {
	CLLocation *geoLocation;
}

@property (nonatomic, retain) CLLocation *geoLocation;

//clculates the anhgle between two coordinates
- (float)angleFromCoordinate:(CLLocationCoordinate2D)first toCoordinate:(CLLocationCoordinate2D)second;

//initlalizer returns a physicalplace with his location
+ (PhysicalPlace *)coordinateWithLocation:(CLLocation *)location;

- (void)calibrateUsingOrigin:(CLLocation *)origin;
+ (PhysicalPlace *)coordinateWithLocation:(CLLocation *)location fromOrigin:(CLLocation *)origin;

@end
