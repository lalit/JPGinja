//
//  ListViewController.h
//  CityJapan
//
//  Created by Arul Karthik on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class OffersDetailsViewController;
@class ListViewCell;

@interface ListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    UITableView *tblListView;
    BOOL validLocation;
    OffersDetailsViewController *detailsViewController; 
    
    
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
    
    CLLocation *currentLocation ;
    //ListViewCell *cell;

    
}
@property(nonatomic) int currentPage;
@property(nonatomic,retain)IBOutlet UILabel *lblEventCount;
@property(nonatomic,retain)IBOutlet UILabel *lblFilterText;
@property(nonatomic,retain) NSMutableDictionary *dataDict;
@property(nonatomic,retain) NSMutableArray *listDataArray;
@property(nonatomic,retain)CLLocation *currentLocation ;
@property(nonatomic,retain)NSMutableArray *dataArray;
@property(nonatomic,retain)IBOutlet   UITableView *tblListView;
@property(nonatomic,retain) OffersDetailsViewController *detailsViewController; 
@property(nonatomic,retain) NSMutableArray *arryListDetails;
@property(nonatomic,retain) NSMutableArray *arrayOfTitles;

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

-(void)NextViewAction:(id)sender;
-(void)btnbookmarkAction :(id)sender :(NSIndexPath *)path;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *swipeGestureDown;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGestureforFiter;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGestureforSearch;

-(IBAction)btnGinzaMenu:(id)sender;
@end
