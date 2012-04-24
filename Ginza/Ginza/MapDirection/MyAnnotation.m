//
//  MyAnnotation.m
//  Mapper
//
//  Created by Geppy on 22/07/2009.
//  Copyright 2009 iNVASIVE CODE. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize coordinate, title, subtitle;

-(void)dealloc 
{
	[title release];
	[subtitle release];
	[super dealloc];
}

@end
