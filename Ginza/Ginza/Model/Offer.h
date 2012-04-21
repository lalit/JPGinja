//
//  Offer.h
//  Ginza
//
//  Created by administrator on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Offer : NSManagedObject

@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * copy_text;
@property (nonatomic, retain) NSString * created_by;
@property (nonatomic, retain) NSString * created_on;
@property (nonatomic, retain) NSString * end_date;
@property (nonatomic, retain) NSString * free_text;
@property (nonatomic, retain) NSString * image_name;
@property (nonatomic, retain) NSString * image_position;
@property (nonatomic, retain) NSString * isbookmark;
@property (nonatomic, retain) NSString * lead_text;
@property (nonatomic, retain) NSString * modified_by;
@property (nonatomic, retain) NSString * modified_on;
@property (nonatomic, retain) NSString * modified_ts;
@property (nonatomic, retain) NSString * offer_id;
@property (nonatomic, retain) NSString * offer_title;
@property (nonatomic, retain) NSString * offer_type;
@property (nonatomic, retain) NSString * sinage;
@property (nonatomic, retain) NSString * start_date;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * store_id;
@property (nonatomic, retain) NSString * id;

@end
