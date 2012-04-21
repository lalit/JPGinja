//
//  ShopList.h
//  Ginza
//
//  Created by administrator on 07/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ShopList : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * area;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * created_on;
@property (nonatomic, retain) NSString * holiday;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * is_child;
@property (nonatomic, retain) NSString * is_lunch;
@property (nonatomic, retain) NSString * is_private;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * store_name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * store_id;
@property (nonatomic, retain) NSString * sub_category;
@property(nonatomic,retain)NSString *time;

@end
