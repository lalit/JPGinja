//
//  Location.m
//  Ginza
//
//  Created by Ashok Agrawal on 4/21/12.
//  Copyright (c) 2012 Mobiquest Pte Ltd. All rights reserved.
//

#import "Location.h"

@implementation Location

@synthesize currentLocation;

static Location *gInstance = NULL;

+ (Location *) sharedInstance
{
    @synchronized(self)
    {
        if (gInstance == NULL)
            gInstance = [[self alloc] init];
    }
    
    return(gInstance);
}


@end
