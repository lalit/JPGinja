#import "AccessorizedCalloutMapAnnotationView.h"
#import "BasicMapAnnotationView.h"

@interface AccessorizedCalloutMapAnnotationView()

@property (nonatomic, retain) UIButton *accessory;
@property (nonatomic, retain) UIButton *accessory1;
@end


@implementation AccessorizedCalloutMapAnnotationView

@synthesize accessory = _accessory;
@synthesize accessory1 = _accessory1;
- (id) initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
        
    
	if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        if ([showAccessoryView isEqualToString:@"YES"]) {
		self.accessory = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		self.accessory.exclusiveTouch = YES;
		self.accessory.enabled = YES;
		[self.accessory addTarget: self 
						   action: @selector(calloutAccessoryTapped) 
				 forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel];
        CGRect rec = self.accessory.frame;
        rec.origin.x=100;
        self.accessory.frame=rec;
		[self addSubview:self.accessory];
        
        self.accessory1 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
		self.accessory1.exclusiveTouch = YES;
		self.accessory1.enabled = YES;
		[self.accessory1 addTarget: self 
                            action: @selector(calloutAccessoryTapped1) 
                  forControlEvents: UIControlEventTouchUpInside | UIControlEventTouchCancel];
		[self addSubview:self.accessory1];
	}
        }
	return self;
}
- (void) hideAccessoryVIew
{
    self.accessory.hidden =YES;
    self.accessory1.hidden=YES;
}
- (void)prepareContentFrame {
	CGRect contentFrame = CGRectMake(self.bounds.origin.x + 10, 
									 self.bounds.origin.y + 3, 
									 self.bounds.size.width - 20, 
									 self.contentHeight);
    
    
	
	self.contentView.frame = contentFrame;
}

- (void)prepareAccessoryFrame {
	self.accessory.frame = CGRectMake(self.bounds.size.width -20 , 
									  (self.contentHeight + 3 - self.accessory.frame.size.height) / 2, 
									  self.accessory.frame.size.width, 
									  self.accessory.frame.size.height);
    
    self.accessory1.frame = CGRectMake(0, 
                                       (self.contentHeight + 3 - self.accessory1.frame.size.height) / 2, 
                                       self.accessory1.frame.size.width, 
                                       self.accessory1.frame.size.height);
    
    
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];
	[self prepareAccessoryFrame];
}

- (void) calloutAccessoryTapped1 {
	
    NSLog(@"call1");
    /*if ([self.mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
     [self.mapView.delegate mapView:self.mapView 
     annotationView:self.parentAnnotationView 
     calloutAccessoryControlTapped:self.accessory];
     }*/
}
- (void) calloutAccessoryTapped {
	
    /*if ([self.mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]) {
     [self.mapView.delegate mapView:self.mapView 
     annotationView:self.parentAnnotationView 
     calloutAccessoryControlTapped:self.accessory];
     }*/
    NSLog(@"call1");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	
	UIView *hitView = [super hitTest:point withEvent:event];
	
	//If the accessory is hit, the map view may want to select an annotation sitting below it, so we must disable the other annotations
	//But not the parent because that will screw up the selection
	if (hitView == self.accessory) {
		[self preventParentSelectionChange];
		[self performSelector:@selector(allowParentSelectionChange) withObject:nil afterDelay:1.0];
		for (UIView *sibling in self.superview.subviews) {
			if ([sibling isKindOfClass:[MKAnnotationView class]] && sibling != self.parentAnnotationView) {
				((MKAnnotationView *)sibling).enabled = NO;
				//[self performSelector:@selector(enableSibling:) withObject:sibling afterDelay:1.0];
			}
		}
	}
	
	return hitView;
}

- (void) enableSibling:(UIView *)sibling {
	((MKAnnotationView *)sibling).enabled = YES;
}

- (void) preventParentSelectionChange {
	BasicMapAnnotationView *parentView = (BasicMapAnnotationView *)self.parentAnnotationView;
	parentView.preventSelectionChange = YES;
}

- (void) allowParentSelectionChange {
	//The MapView may think it has deselected the pin, so we should re-select it
	[self.mapView selectAnnotation:self.parentAnnotationView.annotation animated:NO];
	
	BasicMapAnnotationView *parentView = (BasicMapAnnotationView *)self.parentAnnotationView;
	parentView.preventSelectionChange = NO;
}

@end
