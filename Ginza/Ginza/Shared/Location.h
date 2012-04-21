//
//  Location.h
//  Ginza
//
//  Created by Ashok Agrawal on 4/21/12.
//  Copyright (c) 2012 Mobiquest Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface Location : NSObject {
    
    CLLocation *currentLocation;
}

+ (Location *) sharedInstance;
@property(nonatomic,retain) CLLocation *currentLocation;

@end
