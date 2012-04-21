#import <Foundation/Foundation.h>
#import "CalloutMapAnnotationView.h"

@interface AccessorizedCalloutMapAnnotationView : CalloutMapAnnotationView {
	UIButton *_accessory;
    UIButton *_accessory1;
}
- (void) calloutAccessoryTapped1;
- (void) calloutAccessoryTapped;
- (void) preventParentSelectionChange;
- (void) allowParentSelectionChange;
- (void) enableSibling:(UIView *)sibling;
//- (void) hideAccessoryVIew;

@end
