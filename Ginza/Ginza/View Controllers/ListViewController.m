//
//  ListViewController.m
//  CityJapan
//
//  Created by Arul Karthik on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import "ListViewController.h"
#import "MapViewController.h"
#import "ListViewCell.h"
//#import "BookMarkImageView.h"
#import "GinaViewController.h"
//#import "AppDelegate.h"
#import "OfferDetailsViewController.h"
#import "SubMenuSearchViewController.h"
#import "GinzaFilterViewController.h"
#import "SearchViewController.h"
#import "GinzaSubViewController.h"
#import"Categories.h"
#import "Offer.h"

#import "AppDelegate.h"



#import "GinzaDetailsViewController.h"


@implementation ListViewController
@synthesize tblListView;

@synthesize arryListDetails;
@synthesize arrayOfDistance;
@synthesize arrayOfLatitude;
@synthesize arrayOfLongitude;

@synthesize arrayOflocation2Latitude;
@synthesize arrayOflocation2Longitude;
@synthesize arrayOfTitles;
@synthesize locationManager;
@synthesize lblnewDistance;
@synthesize strDistance;
@synthesize imgViewditection,dataArray;
@synthesize swipeGestureDown;
@synthesize panGestureforFiter;
@synthesize panGestureforSearch;
@synthesize arrayOfImages,listDataArray,dataDict,lblFilterText,lblEventCount,currentPage;
@synthesize ginzaDetailsView;
@synthesize detailsView;

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//        NSLog(@"initWithStyle");
//    }
//    return self;
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title = NSLocalizedString(@"一覧", @"一覧");
        self.tabBarItem.image = [UIImage imageNamed:@"Listicon"];
    }
    return self;
}

- (void)viewDidLoad
{
    //[super viewDidLoad];
    currentPage=1;
    self.navigationController.navigationBar.hidden = YES;
    
     AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.dataArray = appDeligate.offerDataArray ;
    self.lblEventCount.hidden =NO;
    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[appDeligate.ginzaEvents count]];
    if ([appDeligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }
         dataDict =appDeligate.listViewDataArray;
         tblListView.delegate = self;
         tblListView.dataSource = self;
         tblListView.sectionIndexMinimumDisplayRowCount = 5;
    
    
   // tblListView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,55, 320, 480)];
    
    
   
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  
    [super viewDidLoad];

    
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter =3; // whenever we move
    locationManager.headingFilter = 5;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;; // 100 m
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
//    
//    locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
//    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;; // 100 m
//    [locationManager startUpdatingLocation];
//    [locationManager startUpdatingHeading];
    self.navigationController.navigationBarHidden = YES;
    
    
    
    
   }
-(void)viewDidDisappear:(BOOL)animated
{
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [tblListView reloadData];
    return YES;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    //NSLog(@"count %d",[self.dataDict count]);
    return  [self.dataDict count];//currentPage+10+2;//[self.dataDict count]+1;
    
}

+ (UIImage*)imageWithImage:(UIImage*)image 
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        

        static NSString *CellIdentifier = @"Cell";
        
        ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:nil options:nil];
            
            for (UIView *view in views) {
                if([view isKindOfClass:[UITableViewCell class]])
                {
                    cell = (ListViewCell*)view;
                }
            }
        }
        
//        return cell;


    cell.btnBookMark.tag =indexPath.row-1;
    if (indexPath.row>=1) {
       
        NSDictionary *tmpDict = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row-1]];
        Offer *offer = [tmpDict objectForKey:@"offer"];    
        Categories *categoryData = [tmpDict objectForKey:@"cat"];
        ShopList *shopData = [tmpDict objectForKey:@"shop"];
      
    
       NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:@"/"];
        path = [path stringByAppendingString:[NSString stringWithFormat:@"80x60_%@",categoryData.image_name]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        

        [cell.imgDeatils setImage:image];
        cell.lblTitle.text = categoryData.category_name;
        cell.lblTitle.textColor =[UIColor grayColor];
        

        cell.lblDescription.text = shopData.store_name;
        cell.lblDescription.font = [UIFont systemFontOfSize:12];
        cell.offer = offer;
              
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;   
        if ([offer.isbookmark isEqualToString:@"1"]) 
        
        {
            [cell.btnBookMark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
        }else
        {
            [cell.btnBookMark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];

        }
        
        if([offer.offer_type isEqualToString:@"special"])
        {
            cell.imgGinzaBackground.image = [UIImage imageNamed:@"Specialoffercellbg.png"];
            cell.lblFreeText.text = offer.lead_text;
            UIColor *mycolor= [UIColor colorWithRed:192/255.0 green:150.0/255.0 blue:49.0/255.0 alpha:5.0];
            cell.lblFreeText.textColor = mycolor;
        }
        else
        {
            cell.imgGinzaBackground.image = [UIImage imageNamed:@"Normaloffercell.png"];
        }
 
        cell.strLatitude = shopData.latitude;
        cell.strLongitude = shopData.longitude;
        cell.imgDirection.image= [UIImage imageNamed:@"Arrow.png"];
        
        double Latitude = [shopData.latitude doubleValue];
        
        
        double Longitude = [shopData.longitude doubleValue];
        // Latitude= 13.060422;
        // Longitude=80.249583;
        CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
        
        //NSLog(@"locaion update %f",newLocation.coordinate.latitude);
        
        CLLocationDistance meters = [currentLocation distanceFromLocation:storeLocation];
        //4000 mtr = 15 min
        //NSLog(@"meters %d",meters);
        double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
        int time = (me/4000)*15;
         cell.lblDistance.text =[NSString stringWithFormat:@" %.fm (徒歩%d分)",meters,time];
        
       //  cell.imgDirection.image= [UIImage imageNamed:@"Arrow.png"]; 
        [cell.imgDirection setImage:[UIImage imageNamed:@"Arrow.png"]];
      //  cell.imgDirection.transform = CGAffineTransformMakeRotation((degrees - newHeadingObject.magneticHeading) * M_PI / 180);
//         cell.imgDirection.transform = CGAffineTransformMakeRotation(( [self calculateUserAngle:currentLocation.coordinate lat:Latitude lon:Longitude]-newHeadingObject.magneticHeading)*M_PI / 180);
       // cell.lblDistance.text = @"dddddd";
        cell.imgDirection.transform = CGAffineTransformMakeRotation(( [self calculateUserAngle:currentLocation.coordinate lat:Latitude lon:Longitude]-newHeadingObject.magneticHeading)*M_PI / 180);
        
    }
        
    if (indexPath.row==0) {
        cell.imgGinzaBackground.image = [UIImage imageNamed:@"Ginzacelllist.png"];
        //cell.btnBookMark.imageView.image = [UIImage imageNamed:@"Bookmarkplus.png"];
        
        cell.lblTitle.text = @"ダイナースクラフ";
        cell.lblTitle.textColor =[UIColor whiteColor];
        cell.imgDeatils.image = [UIImage imageNamed:@"thumb.png"];
        cell.lblDescription.text = @"銀座ラウンシ";
        cell.lblDescription.textColor =[UIColor whiteColor];
        cell.lblDescription.font = [UIFont systemFontOfSize:12];
        
        cell.strLatitude = @"35.665756";
        cell.strLongitude = @"139.71179";

  }
    
    cell.offerType = @"list";
        return cell;
    
     
  

}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [locationManager stopUpdatingLocation];
     [locationManager stopUpdatingHeading];
       
    
    if(indexPath.row == 0)
    {
          [locationManager stopUpdatingLocation];
        [locationManager stopUpdatingHeading];
       self.ginzaDetailsView =[[GinzaDetailsViewController alloc]init];
        
      [self presentModalViewController:ginzaDetailsView animated:YES];
        
        
        
    }
    
    else
    {
      [locationManager stopUpdatingLocation];
         [locationManager stopUpdatingHeading];
        self.detailsView =[[OfferDetailsViewController alloc]init];
        Offer *offer =[dataArray objectAtIndex:indexPath.row-1];
        
        detailsView.offerId = offer.offer_id;
        
        
        [self presentModalViewController:detailsView animated:YES];
        
    
        }

}

//Please delete this function after our conversation stops this to show just show you 

-(IBAction)getUserDetails:(id)sender
{

    NSLog(@"helllow ");

}

-(IBAction)GinzaswipeDown:(id)sender
{
  
    
    GinzaSubViewController  *infoViewController = [[GinzaSubViewController alloc]init];
    

    
    [self.navigationController pushViewController:infoViewController animated:NO];
    
}







-(IBAction)GinzafilterViewDown:(id)sender
{
    GinzaFilterViewController  *filterViewController = [[GinzaFilterViewController alloc]init];
    filterViewController.view.alpha = 0.0;
    [self.view.window.rootViewController presentModalViewController:filterViewController animated:NO];
    [UIView animateWithDuration:0.0
                     animations:^{filterViewController.view.alpha = 1.0;}];

}

-(IBAction)GinzaSearchView:(id)sender
{
    NSLog(@"testing ginza menu view");
    
    SubMenuSearchViewController  *searchViewController = [[SubMenuSearchViewController alloc]init];

    [self presentModalViewController:searchViewController animated:YES];

    
}

-(IBAction)btnGinzaMenu:(id)sender
{
    GinzaSubViewController  *infoViewController = [[GinzaSubViewController alloc]init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:infoViewController animated:NO];
    CGRect rect = infoViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    infoViewController.view.frame =rect;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = infoViewController.view.frame;
    rect1.origin.y = 0;
    infoViewController.view.frame =rect1;

    [UIView commitAnimations];
}

#pragma mark CLLocation Delegates methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   

    currentLocation =  newLocation;   

    
    
   currentLocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
    
    NSLog(@"didUpdateToLocation");
    

   
     
      [tblListView reloadData];

}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading 
{
    // UITableViewCell *cell =  (UITableViewCell *)[tblListView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:2]];
    
  
    NSLog(@"update heading....");
    
  //  newHeadingObject = [[CLHeading alloc]init];
    newHeadingObject = newHeading;

    
    //imgDirection.image= [UIImage imageNamed:@"Arrow.png"];
  

    // [tblListView reloadData];
    
}



-(float) calculateUserAngle:(CLLocationCoordinate2D)user lat:(float)lat lon:(float)lang {
  float   locLat = lat;
   float  locLon = lang;
    
    NSLog(@"%f ; %f", locLat, locLon);
    
    float pLat;
    float pLon;
    
    if(locLat > user.latitude && locLon > user.longitude) {
        // north east
        
        pLat = user.latitude;
        pLon = locLon;
        
        degrees = 0;
    }
    else if(locLat > user.latitude && locLon < user.longitude) {
        // south east
        
        pLat = locLat;
        pLon = user.longitude;
        
        degrees = 45;
    }
    else if(locLat < user.latitude && locLon < user.longitude) {
        // south west
        
        pLat = locLat;
        pLon = user.latitude;
        
        degrees = 180;
    }
    else if(locLat < user.latitude && locLon > user.longitude) {
        // north west
        
        pLat = locLat;
        pLon = user.longitude;
        
        degrees = 225;
    }
    
    // Vector QP (from user to point)
    float vQPlat = pLat - user.latitude;
    float vQPlon = pLon - user.longitude;
    
    // Vector QL (from user to location)
    float vQLlat = locLat - user.latitude;
    float vQLlon = locLon - user.longitude;
    
    // degrees between QP and QL
    float cosDegrees = (vQPlat * vQLlat + vQPlon * vQLlon) / sqrt((vQPlat*vQPlat + vQPlon*vQPlon) * (vQLlat*vQLlat + vQLlon*vQLlon));
   return degrees = degrees + acos(cosDegrees);
    
    NSLog(@"Rotate:%f",degrees);
}







@end
