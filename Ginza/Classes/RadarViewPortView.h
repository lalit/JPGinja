
#import <UIKit/UIKit.h>
#import "Radar.h"


@interface RadarViewPortView : UIView {
    @private
    BOOL isFirstAccess;
    float newAngle;
    float referenceAngle;
    float _RADIUS;
}
@property (nonatomic) float newAngle;
@property (nonatomic) float referenceAngle;
@property (nonatomic) float RADIUS;
@property (nonatomic, retain) UIViewController  *superViewController;
@property (nonatomic, retain)NSMutableArray *placesOfInterest;
-(void) addTargetIndicatorWithHeading:(float)heading andDistance:(float)distance;
-(float) getHeadingFromCoordinate:(CLLocation*)fromLocation toCoordinate:(CLLocation*)toLocation;
@end
