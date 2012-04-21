//
//  ListViewCell.h
//  CityJapan
//
//  Created by Arul Karthik on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Offer.h"



@interface ListViewCell : UITableViewCell<CLLocationManagerDelegate>
{
    
    IBOutlet UILabel *lblTitle;
    IBOutlet UILabel *lblDescription;
    IBOutlet UIImageView *imgGinzaBackground;
    IBOutlet UIImageView *imgDeatils;
    IBOutlet UIImageView *imgDirection;
    IBOutlet UIImageView *imgBookmark;
    
    IBOutlet UILabel *lblDistance;
    
    
    IBOutlet NSString *strDistance;
    
    float degrees;
    
    CLLocationManager *locationManager;
    
    UIButton *btnBookMark;

    
    
    NSNumber *latitude;
    NSNumber *longitude;
    NSMutableArray *arrayLatitude;
    
    NSString *strLatitude;
    NSString *strLongitude;
    NSString *offerType;
    
    
    
}
@property(nonatomic,retain)NSString *offerType;
@property(nonatomic,retain) IBOutlet UILabel *lblFreeText;
@property(nonatomic,retain)    UIImageView *imgBookmark;
@property(nonatomic,retain)    UILabel *lblTitle;
@property(nonatomic,retain)    UILabel *lblDescription;
@property(nonatomic,retain)     UIImageView *imgGinzaBackground;

@property(nonatomic,retain)    UIImageView *imgDeatils;
@property(nonatomic,retain)    UIImageView *imgDirection;

@property(nonatomic,retain)    UILabel *lblDistance;
@property(nonatomic,retain)    CLLocationManager *locationManager;

@property(nonatomic,retain)    IBOutlet UIButton *btnBookMark;


@property(nonatomic,retain)     NSNumber *latitude;
@property(nonatomic,retain)     NSNumber *longitude;
@property(nonatomic,retain)     NSMutableArray *arrayLatitude;

@property(nonatomic,retain)     NSString *strLatitude;
@property(nonatomic,retain)     NSString *strLongitude;
@property(nonatomic,retain) Offer *offer;
-(void)setValue;
-(void)Animation;
-(void) calculateUserAngle:(CLLocationCoordinate2D)user;
-(void)initlocation;
-(void)stopLocationManager;
-(IBAction)btnBookmark:(id)sender;
@end