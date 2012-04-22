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

#import "RadarViewPortView.h"
#import "AppDelegate.h"
#define radians(x) (M_PI * (x) / 180.0)

@implementation RadarViewPortView
@synthesize newAngle, referenceAngle,RADIUS = _RADIUS;

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
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(contextRef, 0, 255, 115, 0.3);
    
    // view port 
    //    if(isFirstAccess){
    CGContextMoveToPoint(contextRef, self.RADIUS, self.RADIUS);
    CGContextAddArc(contextRef, self.RADIUS, self.RADIUS, self.RADIUS,  radians(referenceAngle), radians(referenceAngle+newAngle),0); 
    CGContextClosePath(contextRef); 
    CGContextFillPath(contextRef);
    //    }
    isFirstAccess = NO;    
    
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableDictionary *mapDataDict = deligate.poiDataDictionary;
    for (id key in mapDataDict)
    {
        NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
        Offer *offer =[offerdataArray objectAtIndex:0];
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        double latitude =[merchant.latitude doubleValue];
        double longitude = [merchant.longitude doubleValue];
        
        CLLocation *currentLocation1 =[[CLLocation alloc] initWithLatitude:35.67163555  longitude:139.76395295];;
        CLLocation *storelocation =[[CLLocation alloc] initWithLatitude: latitude longitude:longitude];;
        float heading = [self getHeadingFromCoordinate:currentLocation1 toCoordinate:storelocation];
        NSLog(@"heading = %f",heading);
        
        float radius = 30;
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
    
    NSLog(@"distance = %f,%f",x1,y1);
    
    
}



@end
