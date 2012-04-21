//
//  ListViewCell.m
//  CityJapan
//
//  Created by Arul Karthik on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListViewCell.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import "Offer.h"

@implementation ListViewCell
@synthesize imgDeatils;
@synthesize lblTitle;
@synthesize lblDescription;
@synthesize imgGinzaBackground;
@synthesize imgDirection;
@synthesize locationManager;
@synthesize lblDistance;
@synthesize btnBookMark;


@synthesize strLatitude;
@synthesize strLongitude;
@synthesize arrayLatitude;

@synthesize latitude;
@synthesize longitude,imgBookmark,lblFreeText,offerType,offer;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userInteractionEnabled = YES;
        reuseIdentifier = @"Cell";
        NSLog(@"MY NAME IS REUSE");

    }
    return self;
}

-(void)initlocation
{
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;; // 100 m
//    [locationManager startUpdatingLocation];
//    [locationManager startUpdatingHeading];
}


-(void)stopLocationManager
{
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
}
-(void)setValue
{
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocationCoordinate2D here =  newLocation.coordinate;
    double Latitude = [strLatitude doubleValue];
    
   
    double Longitude = [strLongitude doubleValue];
   // Latitude= 13.060422;
   // Longitude=80.249583;
    CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    
    //NSLog(@"locaion update %f",newLocation.coordinate.latitude);
    
    CLLocationDistance meters = [newLocation distanceFromLocation:storeLocation];
    //4000 mtr = 15 min
    //NSLog(@"meters %d",meters);
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    lblDistance.text =[NSString stringWithFormat:@" %.fm (徒歩%d分)",meters,time];
    //NSLog(@"%@",[NSString stringWithFormat:@" %.fm (徒歩%d分)",meters,time]);
    
    [self calculateUserAngle:here];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading 
{

    //NSLog(@"update heading");
    imgDirection.image= [UIImage imageNamed:@"Arrow.png"];
       imgDirection.transform = CGAffineTransformMakeRotation((degrees - newHeading.magneticHeading) * M_PI / 180);
    
    
    
}










-(IBAction)btnBookmark:(id)sender
{
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDeligate updateBookMarkCount:offer];
    
    
    if ([offer.isbookmark isEqualToString:@"0"]) {
        
        [btnBookMark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
    }
    else {
        [btnBookMark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];

    }


   }

@end
