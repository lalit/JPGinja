//
//  ListViewController.h
//  CityJapan
//
//  Created by Arul Karthik on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
//#import "GinzaDetailsViewController.m"

#import "OfferDetailsViewController.h"
@class ListViewCell;
@class GinzaDetailsViewController;
@class CustomTopNavigationBar;
@interface ListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    UITableView *tblListView;
    BOOL validLocation;
    OfferDetailsViewController *detailsView; 
    
    GinzaDetailsViewController *ginzaDetailsView;
    NSMutableArray *dataArray;
    
    
    NSMutableArray *arryListDetails;
    
    
    NSMutableArray *arrayListDetails;
    NSMutableArray *arrayOfTitles;
    NSMutableArray *arrayOfImages;
    NSMutableArray *arrayOfDistance;
    
    NSMutableArray *arrayOfLatitude;
    NSMutableArray *arrayOfLongitude;
    
    NSMutableArray *arrayOflocation2Latitude;
    NSMutableArray *arrayOflocation2Longitude;

    
    CLLocationDistance kilometers;
    
    UILabel *lblnewDistance;
    
    NSString *strDistance;

    float degrees;
    
    UIImageView *imgcompass;
    BOOL oneCheckboxSelected ; 
    NSString *currenDirection;
    NSString *previousDirection;
    CLLocation *currentLocation ;
    CLHeading  *newHeadingObject;
    //ListViewCell *cell;
    CLLocationManager *locationManager;
    float mHeading;
    CustomTopNavigationBar *cbar;
    UIImage *bookMarkMinusImage;
    UIImage *bookMarkPlusImage;
    UIImage *ginzaGIcon;
    UIImage *ginzaBackgroundImageSpecial;
    UIImage *ginzaBackgroundImageFirstRow;
    UIImage *thumbImage;
    UIImage *arrowImageBlue;
    UIImage *arrowImageGray;
    IBOutlet UITableView *listViewTable;
    UINib *cellLoader;
    NSString *mStrImageDirectoryPath;
    NSString *categoryName;
    NSString *storeName;
    NSString *specialOffer;
    NSString *direction;
    NSString *thumbnailPath;
    double storeLatitude;
    double storeLongitude;
       int arrowX;
}

@property(nonatomic) int currentPage;
@property(nonatomic,retain) NSString *mStrImageDirectoryPath;
@property(nonatomic,retain)   OfferDetailsViewController *detailsView; 
@property(nonatomic,retain) GinzaDetailsViewController *ginzaDetailsView;
@property(nonatomic,retain)  CustomTopNavigationBar *cbar;
@property(nonatomic,retain)IBOutlet UILabel *lblEventCount;
@property(nonatomic,retain)IBOutlet UILabel *lblFilterText;
@property(nonatomic,retain) NSMutableDictionary *dataDict;
@property(nonatomic,retain) NSMutableArray *listDataArray;
//@property(nonatomic,retain)CLLocation *currentLocation ;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)IBOutlet   UITableView *tblListView;
//@property(nonatomic,retain) OffersDetailsViewController *detailsViewController; 
@property(nonatomic,retain) NSMutableArray *arryListDetails;
@property(nonatomic,retain) NSMutableArray *arrayOfTitles;
//@property(nonatomic,retain) CLHeading  *newHeadingObject;
@property(nonatomic,retain) NSMutableArray *arrayOfImages;


@property(nonatomic,retain) NSMutableArray *arrayOfDistance;

@property(nonatomic,retain) NSMutableArray *arrayOfLatitude;
@property(nonatomic,retain) NSMutableArray *arrayOfLongitude;


@property(nonatomic,retain)NSMutableArray *arrayOflocation2Latitude;
@property(nonatomic,retain)NSMutableArray *arrayOflocation2Longitude;

@property(strong,nonatomic)CLLocationManager *locationManager;
@property(nonatomic,retain)IBOutlet     UILabel *lblnewDistance;
@property(nonatomic,retain)    NSString *strDistance;
@property(nonatomic,retain)    UIImageView *imgViewditection;
-(float) calculateUserAngle:(CLLocationCoordinate2D)user lat:(float)lat lon:(float)lang;
-(void)NextViewAction:(id)sender;
-(void)btnbookmarkAction :(id)sender :(NSIndexPath *)path;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *swipeGestureDown;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGestureforFiter;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGestureforSearch;
-(double) bearingToLocation:(CLLocation *) destinationLocation;
-(NSString *) compassOrdinalToLocation:(CLLocation *) nwEndPoint;
-(IBAction)btnGinzaMenu:(id)sender;
- (NSString *)calculateDistance : (double) aDistance;
- (NSString *)calculateTime : (int) aTime;
- (void) updateTopNavigation;
-(void) createConstantImages ;
@end
