//
//  DetailViewController.h
//  DetailsTableView
//
//  Created by Arul Karthik on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController<UIScrollViewDelegate,UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,UIGestureRecognizerDelegate>
{
    
    
    UIView *viewDetails;
    
    UIView *viewOfferDetails;
    UIView *viewstoresDetails;
    
    
    UIScrollView *scrollView;
    
    
    UIWebView *webView;
    
    
    CGFloat y_position;
    CGFloat y_offerposition;
    CGFloat y_storeposition;
    
    
    
    UIButton *btnOpenOffer;
    UIButton *btnCloseOffer;
    UIButton *btnClose;
    
    
    
    UITableView *tblView;
    UITableViewCell *cellloaction;
    UITableViewCell *celltelephoneno;
    UITableViewCell *cellbusinesshrs;
    UITableViewCell *cellhollydays;

    
    
    
    NSMutableArray *arrayOfContacts;
    
    
    
    
    UIImageView *imgBookmark;
    
    /*  view details  */
    
    UILabel *lblTitle;
    UILabel *lblshopingSpecialityTitle;
    UIImageView *imgShopingImage;
    UILabel *lblDistance;
    
    
    

    /*    view  viewOfferDetails  */
    
    
    
    
    
    /*    view  viewOfferDetails  */

    
    
    /*   view tableView  */
    
    
    UITextView *txtViewdetails;
    
    
    /*bookmark */
    
    UISwipeGestureRecognizer *swipeGesture;
    

    
    UIImageView *imgTopBar;
    
    

}
@property(nonatomic,retain)NSString *offerId;
@property(nonatomic,retain)IBOutlet  UIView *viewDetails;
@property(nonatomic,retain)IBOutlet  UIView *viewOfferDetails;
@property(nonatomic,retain)IBOutlet  UIView *viewstoresDetails;

@property(nonatomic,retain)IBOutlet  UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet  UIWebView *webView;
@property(nonatomic,retain)IBOutlet  UIButton *btnOpenOffer;
@property(nonatomic,retain)IBOutlet  UIButton *btnCloseOffer;
@property(nonatomic,retain)IBOutlet  UIButton *btnClose;



@property(nonatomic,retain)IBOutlet  UITableView *tblView;


@property(nonatomic,retain)IBOutlet UITableViewCell *cellloaction;
@property(nonatomic,retain)IBOutlet UITableViewCell *celltelephoneno;
@property(nonatomic,retain)IBOutlet UITableViewCell *cellbusinesshrs;
@property(nonatomic,retain)IBOutlet UITableViewCell *cellhollydays;
@property(nonatomic,retain)    NSMutableArray *arrayOfContacts;


@property(nonatomic,retain)IBOutlet     UIImageView *imgBookmark;



@property(nonatomic,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic,retain)IBOutlet UILabel *lblshopingSpecialityTitle;
@property(nonatomic,retain)IBOutlet UIImageView *imgShopingImage;
@property(nonatomic,retain)IBOutlet UILabel *lblDistance;


@property(nonatomic,retain)IBOutlet UITextView *txtViewdetails;

@property(nonatomic,retain)IBOutlet UISwipeGestureRecognizer *swipeGesture;
@property(nonatomic,retain)IBOutlet     UIImageView *imgTopBar;


-(IBAction)btnOfferOpenAction:(id)sender;

-(IBAction)btnCloseAction:(id)sender;


@end
