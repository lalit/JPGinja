//
//  CustomCallOutView.h
//  Ginza
//
//  Created by administrator on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Offer.h"

@interface CustomCallOutView : UIView<CLLocationManagerDelegate>
{
    int currentPos;
}



@property(nonatomic,retain)UILabel *distanceLabel1;
@property(nonatomic,retain)UILabel *distanceLabel2;
@property(nonatomic,retain)UILabel *distanceLabel3;
@property(nonatomic,retain)UILabel *distanceLabel4;

@property(nonatomic,retain)UIViewController *parentViewController;
@property(nonatomic,retain)NSMutableArray *offerDataArray;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,retain)CLLocation *currentLocation;
@property(nonatomic,retain) UILabel *offerTitleLabel;
@property(nonatomic,retain)UIImageView *popupThumb;
@property(nonatomic,retain)UILabel *desLabel;
@property(nonatomic,retain)UILabel *distanceLabel;
@property(nonatomic,retain)UILabel *timeLabel;
@property(nonatomic,retain)UIButton *btnBookmark;
@property(nonatomic,retain)UIButton *popupButton;
@property(nonatomic,retain)UIImageView *popupbg ;
@property(nonatomic,retain)Offer *currentOffer;
@property(nonatomic,retain)UIButton *btnNext;
@property(nonatomic,retain)UIButton *btnPrevious;
-(UIView *)prepareCallOutView:(Offer *)offer offerArray:(NSMutableArray *)offerdataArray;
-(IBAction)btnNext:(id)sender;
-(IBAction)btnPrevious:(id)sender;
-(IBAction)btnBookMark:(id)sender;
-(IBAction)btnShowDetails:(id)sender;
@end
