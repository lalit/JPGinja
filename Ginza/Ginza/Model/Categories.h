//
//  Categories.h
//  Ginza
//
//  Created by administrator on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * attribute;
@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * category_name;
@property (nonatomic, retain) NSString * image_name;
@property (nonatomic, retain) NSString * parent;
@property (nonatomic, retain) NSString * selected;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * active;

@end
