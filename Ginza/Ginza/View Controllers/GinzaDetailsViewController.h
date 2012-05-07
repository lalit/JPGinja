//
//  GinzaDetailsViewController.h
//  Ginza
//
//  Created by Arul Karthik on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class ShareViewController;
@interface GinzaDetailsViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *tblView;
    CLLocation *currentLocation;
}
@property (nonatomic, retain)    CLLocation *currentLocation;
@property (nonatomic, retain) CLLocation *storeLocation; 
@property (nonatomic, retain) ShareViewController *shareVC;
@property(nonatomic, retain)CLLocationManager * locationManager ;
@property(nonatomic,retain)UILabel *lblTitle;
@property(nonatomic,retain)UILabel *lblsubTitle;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UITableView *tblView;
@property(nonatomic, retain)IBOutlet UIButton *btnShare;
@property(nonatomic, retain)IBOutlet UIButton *btnGetDirection;


@property(nonatomic,retain)IBOutlet UILabel *lblOfferTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblOfferSubTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblDistance;

@property(nonatomic,retain)IBOutlet UIWebView *webView;

@property(nonatomic,retain)NSString *offerId;
- (IBAction)getDirectionButtonPressed:(id)sender;
- (IBAction)sharedButtonPressed:(id)sender;
- (void) postFacebook;
- (void) postTwitter;
- (void) sendEmail;
-(NSString *)shareKitMessage;
- (void) calculateDistanceAndTime;
- (void)clickPhoneNumber:(id) sender;
@end
