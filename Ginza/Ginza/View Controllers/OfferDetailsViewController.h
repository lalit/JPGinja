//
//  OfferDetailsViewController.h
//  Ginza
//
//  Created by administrator on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Offer.h"
@class ShareViewController;
@interface OfferDetailsViewController : UIViewController<UITableViewDelegate,CLLocationManagerDelegate>
{
    
    float degrees;

    //Added by MobiQuest team

    float mHeading;
    float mWebViewFlexibleHeight;
    CLHeading  *newHeadingObject;
    NSString *currenDirection;
    NSString *previousDirection;
}
@property (nonatomic, retain) ShareViewController *shareVC;

@property(nonatomic, retain)Offer *offer;
@property(nonatomic, retain)IBOutlet UIButton *btnBookMark;
@property(nonatomic, retain)IBOutlet UIImageView *arrowImage;
@property(nonatomic, retain)CLLocation *storeLocation;
@property(nonatomic, retain)CLLocationManager * locationManager ;
@property(nonatomic,retain)CLLocation *currentLocation ;
@property(nonatomic,retain)IBOutlet UIView *bottomView;
@property(nonatomic,retain)IBOutlet UIImageView *imgCategory;
@property(nonatomic,retain)IBOutlet UIImageView *compassImageView;
@property(nonatomic,retain)IBOutlet UILabel *lblCategoryName;
@property(nonatomic,retain)IBOutlet UILabel *lblOfferTitle;
@property(nonatomic,retain)IBOutlet UIImageView *imgOfferImage;
@property(nonatomic,retain)IBOutlet UILabel *lblDistanceLabel;
@property(nonatomic,retain)IBOutlet UIWebView *webFreeText;
@property(nonatomic,retain)IBOutlet UIImageView *imgIsChild;
@property(nonatomic,retain)IBOutlet UILabel *lblIsChild;
@property(nonatomic,retain)IBOutlet UIImageView *imgIsLunch;
@property(nonatomic,retain)IBOutlet UILabel *lblIsLunch;

@property(nonatomic,retain)IBOutlet UIImageView *imgIsPrivate;

@property(nonatomic,retain)IBOutlet UILabel *lblIsPrivate;


@property(nonatomic,retain)NSString *offerId;

@property(nonatomic,retain)IBOutlet UIScrollView *scroll;
@property(nonatomic,retain)IBOutlet UIView *viewOfferDetails;
@property(nonatomic,retain)IBOutlet UITableView *tableView;

@property(nonatomic,retain)IBOutlet UIButton *btnSepecialOffers;
@property(nonatomic,retain)IBOutlet UIImageView *imgOfferdetailsView;



@property(nonatomic,retain)IBOutlet UIImageView *imgDirection;

-(IBAction)btnOfferDetailsOpenClose:(id)sender;
-(IBAction)btnClose:(id)sender;

- (IBAction)getDirectionButtonPressed:(id)sender;
- (IBAction)sharedButtonPressed:(id)sender;
- (void) postFacebook;
- (void) postTwitter;
- (void) sendEmail;
-(NSString *) shareKitMessage;
-(void) animateArrowImage;
- (void)setUILabel:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame withText:(NSString *)theText usingVerticalAlign:(int)vertAlign;
- (void) loadWebView;
@end
