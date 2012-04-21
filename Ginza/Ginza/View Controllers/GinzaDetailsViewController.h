//
//  GinzaDetailsViewController.h
//  Ginza
//
//  Created by Arul Karthik on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface GinzaDetailsViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UITableView *tblView;
}
@property(nonatomic, retain)CLLocationManager * locationManager ;
@property(nonatomic,retain)UILabel *lblTitle;
@property(nonatomic,retain)UILabel *lblsubTitle;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UITableView *tblView;


@property(nonatomic,retain)IBOutlet UILabel *lblOfferTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblOfferSubTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblDistance;

@property(nonatomic,retain)IBOutlet UIWebView *webView;

@property(nonatomic,retain)NSString *offerId;





@end
