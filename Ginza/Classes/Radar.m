/*
 * Copyright (C) 2010- Peer internet solutions
 * 
 * This file is part of mixare.
 * 
 * This program is free software: you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by 
 * the Free Software Foundation, either version 3 of the License, or 
 * (at your option) any later version. 
 * 
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License 
 * for more details. 
 * 
 * You should have received a copy of the GNU General Public License along with 
 * this program. If not, see <http://www.gnu.org/licenses/>
 */

#import "Radar.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation Radar
@synthesize pois = _pois, range= _range, radius= _radius,RADIUS =_RADIUS;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
        self.RADIUS = frame.size.width/2-10;
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
   
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 0, 115, 0);
    //CGContextSetRGBStrokeColor(contextRef, 0, 0, 125, 0.1);
    CGContextSetLineWidth(contextRef, 3.0);
    CGContextSetRGBStrokeColor(contextRef,  0, 0, 115, 1);
    
    // Draw a radar and the view port 
    CGContextFillEllipseInRect(contextRef, CGRectMake(0.5, 0.5, self.RADIUS*2, self.RADIUS*2)); 
    CGContextSetRGBStrokeColor(contextRef, 0, 255, 255, 0.1);
    CGContextSetRGBStrokeColor(contextRef, 1.0, 1.0, 1.0, 0.5);
    CGContextSetRGBFillColor(contextRef, 1.0, 1.0, 1.0, 0.5);
    CGContextStrokeEllipseInRect(contextRef, CGRectMake(1.5, 1.5, self.RADIUS*2, self.RADIUS*2));
    

    
    CGContextMoveToPoint(contextRef, self.RADIUS, self.RADIUS);
    //add a line from 0,0 to the point 100,100
    CGContextAddLineToPoint( contextRef, 0.5,self.RADIUS);
    //"stroke" the path
    CGContextStrokePath(contextRef);
    //_radius =5;
    _range = _radius *1000;
    float scale = _range / self.RADIUS;
    if(_pois != nil){
        for(PhysicalPlace * poi in _pois){
            float x,y;
            //case1: azimiut is in the 1 quadrant of the radar
            NSLog(@"f=%f",poi.radialDistance);
            if(poi.azimuth >=0 && poi.azimuth< M_PI/2){
                
                x = self.RADIUS + cosf((M_PI/2)-poi.azimuth)*(poi.radialDistance/scale);
                y = self.RADIUS - sinf((M_PI/2)-poi.azimuth)*(poi.radialDistance/scale); 
                
            }else if(poi.azimuth >M_PI/2 && poi.azimuth<M_PI){
                //case2: azimiut is in the 2 quadrant of the radar
                
                x = self.RADIUS + cosf(poi.azimuth- (M_PI/2))*(poi.radialDistance/scale);
                y = self.RADIUS + sinf(poi.azimuth- (M_PI/2))*(poi.radialDistance/scale); 
                
            }else if(poi.azimuth >M_PI && poi.azimuth<(3*M_PI/2)){
                //case3: azimiut is in the 3 quadrant of the radar
                
                x = self.RADIUS - cosf((3*M_PI/2)-poi.azimuth)*(poi.radialDistance/scale);
                y = self.RADIUS + sinf((3*M_PI/2)-poi.azimuth)*(poi.radialDistance/scale); 
                
            }else if(poi.azimuth >(3*M_PI/2) && poi.azimuth<(2*M_PI)){
                //case4: azimiut is in the 4 quadrant of the radar
                
                x = self.RADIUS - cosf(poi.azimuth - (3*M_PI/2))*(poi.radialDistance/scale);
                y = self.RADIUS - sinf(poi.azimuth - (3*M_PI/2))*(poi.radialDistance/scale);
                
            }else if(poi.azimuth ==0){
                x = self.RADIUS;
                y =self. RADIUS - poi.radialDistance/scale;
            }else if(poi.azimuth == M_PI/2){
                x = self.RADIUS + poi.radialDistance/scale;
                y = self.RADIUS;
            }else if(poi.azimuth == (3*M_PI/2)){
                x = self.RADIUS;
                y = self.RADIUS+ poi.radialDistance/scale;
            }else if(poi.azimuth == (3*M_PI/2)){
                x = self.RADIUS -poi.radialDistance/scale;
                y = self.RADIUS;
            }
            //drawing the radar point
            NSLog(@"poi = %@",poi);
           
                CGContextSetRGBFillColor(contextRef, 255, 0, 0, 1);
            NSLog(@"x = %f",x);
            if(x <= self.RADIUS*2 && x>=0 && y>=0 && y <= self.RADIUS*2){
                CGContextFillEllipseInRect(contextRef, CGRectMake(x,y, 2, 2)); 
            }
        }
    }
	
}


#define kFilteringFactor 0.05
UIAccelerationValue rollingX, rollingZ;

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	
}


@end
