//
//  BookMarkViewController.h
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class OffersDetailsViewController;
@class ListViewCell;


@interface BookMarkViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    
    
    OffersDetailsViewController *detailsViewController; 
    
    
    UITableView *tblListView;
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
    BOOL oneCheckboxSelected ; 
    
    UIImageView *imgcompass;
    UIImageView *imgViewditection;
    CLLocationManager *locationManager;
    CLLocation *currentLocation ;
    //ListViewCell *cell;
    
    
}
@property(nonatomic, retain)IBOutlet UILabel *lblEventCount;
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
@property(nonatomic,retain)UITableView *tableView;
@property (nonatomic, retain)IBOutlet UILabel *lblFilterText;


-(IBAction)filterAction:(id)sender;
-(IBAction)btnGinzaMenu:(id)sender;
-(IBAction)GinzafilterViewDown:(id)sender;
-(IBAction)GinzaSearchView:(id)sender;

@end
