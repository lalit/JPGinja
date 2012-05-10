

#import "Radar.h"
#import "AppDelegate.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation Radar
@synthesize pois = _pois, range= _range, radius= _radius,RADIUS =_RADIUS;
@synthesize currentDistance;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.RADIUS = 30;//frame.size.width/2-10;
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}






// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 0, 0.3);
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 0, 0.1);
    
    // Draw a radar and the view port 
    CGContextSetRGBStrokeColor(contextRef, 0, 0, 255, 0.5);
    
    CGContextFillEllipseInRect(contextRef, CGRectMake(0.5, 0.5, self.RADIUS*2, self.RADIUS*2)); 
    // Draw a circle (border only)
    CGContextSetLineWidth(contextRef, 2);
    CGContextSetRGBStrokeColor(contextRef, 255, 255, 255, 0.5);
    CGContextStrokeEllipseInRect(contextRef, CGRectMake(0.5, 0.5, (self.RADIUS*2), self.RADIUS*2));
    
    CGContextSetRGBStrokeColor(contextRef, 255, 255, 255, 0.5);
    CGContextSetRGBFillColor(contextRef, 255, 255, 255, 0.3);

    float referenceAngle = 247.5,newAngle = 45.0;;
    CGContextMoveToPoint(contextRef, self.RADIUS, self.RADIUS);
    CGContextAddArc(contextRef, self.RADIUS, self.RADIUS, self.RADIUS-10,  radians(referenceAngle), radians(referenceAngle+newAngle),0); 
    CGContextClosePath(contextRef); 
    CGContextFillPath(contextRef);
  

    
    //add a line from 0,0 to the point 100,100
    //CGContextAddLineToPoint( contextRef, 0.5,self.RADIUS);
    //"stroke" the path
    CGContextStrokePath(contextRef);
    
    CGContextSetRGBFillColor(contextRef, 0, 0, 255, 1);
    CGContextFillEllipseInRect(contextRef, CGRectMake(self.RADIUS-self.RADIUS/14, self.RADIUS-self.RADIUS/14,self.RADIUS/7,self.RADIUS/7));
    
    
    //draw horizandal line if the mode changed to virtual walk
    CGContextSetRGBStrokeColor(contextRef,  255, 255, 255, 1); //there are two relevant color 
    CGContextMoveToPoint(contextRef, self.RADIUS, self.RADIUS);
    //add a line from 0,0 to the point 100,100
    //CGContextAddLineToPoint( contextRef, -120,self.RADIUS-((self.RADIUS/1000)*currentDistance)+100);
    //"stroke" the path
    CGContextStrokePath(contextRef);
    
    
    
    
}


#define kFilteringFactor 0.05
UIAccelerationValue rollingX, rollingZ;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
}


@end
