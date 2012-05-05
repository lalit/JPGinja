

#import <UIKit/UIKit.h>
//#define RADIUS 30.0
#import "PhysicalPlace.h"
@interface Radar : UIView {
    NSArray * _pois;
    float _range;
    float _radius;
    float _RADIUS;
}
@property (nonatomic,retain) NSArray * pois;
@property (nonatomic, readonly) float range;
@property (nonatomic) float radius;
@property(nonatomic)  float RADIUS;

@end
