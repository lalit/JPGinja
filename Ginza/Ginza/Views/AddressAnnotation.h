//
//  AddressAnnotation.h
//  Ginza
//
//  Created by administrator on 19/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>
@interface AddressAnnotation : NSObject<MKAnnotation> {


CLLocationCoordinate2D coordinate; 
NSString *title; 
NSString *subtitle;
}
@property (nonatomic, assign) CLLocationCoordinate2D coordinate; 
@property (nonatomic, copy) NSString *title; 
@property (nonatomic, copy) NSString *subtitle;
@end


