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
@synthesize largeGIconImageView;

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


-(void)setValue
{
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
