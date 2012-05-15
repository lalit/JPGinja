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
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"



#import "GinzaDetailsViewController.h"
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
double DegreesToRadians(double degrees) {return degrees * M_PI / 180.0;};
double RadiansToDegrees(double radians) {return radians * 180.0/M_PI;};
@implementation ListViewController
@synthesize tblListView;
@synthesize cbar;
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
-(double) bearingToLocation:(CLLocation *) destinationLocation {
    
    double lat1 = DegreesToRadians(currentLocation.coordinate.latitude);
    double lon1 = DegreesToRadians(currentLocation.coordinate.longitude);
    
    double lat2 = DegreesToRadians(destinationLocation.coordinate.latitude);
    double lon2 = DegreesToRadians(destinationLocation.coordinate.longitude);
    
    double dLon = lon2 - lon1;
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    if(radiansBearing < 0.0)
        radiansBearing += 2*M_PI;
    
    
    return DegreesToRadians(radiansBearing);
}
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

#import "CustomTopNavigationBar.h"
- (void)viewDidLoad
{
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
    
    /*UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Total No of offer record in list view" message:[NSString stringWithFormat:@"%d",[self.dataArray count]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
     [alert1 show];*/
    // tblListView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,55, 320, 480)];
    
    
    
    
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self updateTopNavigation];
    [super viewDidLoad];
   
    
    
}
- (void)updateTopNavigation {
    UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
    cbar = [[CustomTopNavigationBar alloc]initWithFrame:CGRectMake(0, 0,transView.frame.size.width, 40)];
    cbar.viewController = self;
    cbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:cbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{

    AppDelegate *appDeligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
     dataDict =appDeligate.listViewDataArray;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter =1; // whenever we move
    locationManager.headingFilter = 5;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    self.navigationController.navigationBarHidden = YES;
    self.cbar.hidden=NO;
    [tblListView reloadData]; 
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [tblListView reloadData];
    return YES;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 95;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"count %d",[self.dataDict count]);
    return  [self.dataDict count]+1;//currentPage+10+2;//[self.dataDict count]+1;
    
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
    
    cell.largeGIconImageView.hidden=YES;
    cell.btnBookMark.tag =indexPath.row-1;
    cell.imgDirection.hidden=NO;
    cell.lblDistance.hidden=NO;
     UIColor *greenCo=[UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
    cell.lblDistance.textColor=greenCo;
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
           
            
            NSString *sOff=[NSString stringWithFormat:@"★ %@",offer.lead_text];
             cell.lblFreeText.text = sOff;
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
        CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
        CLLocationDistance meters = [currentLocation distanceFromLocation:storeLocation];
        double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
        int time = (me/4000)*15;
        double dkm=me/1000;
        if (dkm>MIN_DISTANCE) {
            cell.lblDistance.text=@"この場所までの距離が分かりま せんでした";
        }
        else {
            NSString *formattedTime=[self calculateTime:time];
            NSString *distance=[self calculateDistance:me];
            cell.lblDistance.text =[NSString stringWithFormat:@"%@ %@",distance,formattedTime];
        }
// Animate Arrow
        double radians=((([self bearingToLocation:storeLocation])- mHeading)*M_PI)/180;
        self.detailsView.radians=radians;
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        theAnimation.duration = 0.5f;    
        [cell.imgDirection.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
        cell.imgDirection.transform = CGAffineTransformMakeRotation(radians);
    }
    
    if (indexPath.row==0) {
        cell.imgGinzaBackground.image = [UIImage imageNamed:@"Ginzacelllist.png"];
        cell.largeGIconImageView.hidden=NO;
        cell.imgDirection.image= [UIImage imageNamed:@"Arrowgray.png"];
        cell.lblTitle.text = @"ダイナースクラフ";
        cell.lblTitle.textColor =[UIColor whiteColor];
        cell.imgDeatils.image = [UIImage imageNamed:@"thumb.png"];
        cell.lblDescription.text = @"銀座ラウンシ";
        cell.lblDescription.textColor =[UIColor whiteColor];
        cell.lblDistance.textColor=[UIColor darkGrayColor];
        cell.strLatitude = @"35.665756";
        cell.strLongitude = @"139.71179";
        cell.btnBookMark.hidden=YES;//as per bala request
        double Latitude = 35.665756;
        double Longitude = 139.7117;
        CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
        CLLocationDistance meters =[currentLocation distanceFromLocation:storeLocation];
        double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
        int time = (me/4000)*15;
        double dkm=me/1000;
        if (dkm>MIN_DISTANCE) {
             cell.lblDistance.text=@"この場所までの距離が分かりま せんでした";
        }
        else {
            NSString *formattedTime=[self calculateTime:time];
            NSString *distance=[self calculateDistance:me];
            cell.lblDistance.text =[NSString stringWithFormat:@"%@ %@",distance,formattedTime];
        }
        
        // Animate Arrow
        double radians=((([self bearingToLocation:storeLocation])- mHeading)*M_PI)/180;
        self.detailsView.radians=radians;
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        theAnimation.duration = 0.5f;    
        [cell.imgDirection.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
        cell.imgDirection.transform = CGAffineTransformMakeRotation(radians);
        
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
        detailsView.offerId = offer.id;
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
    
    
}

-(IBAction)GinzaSearchView:(id)sender
{
    NSLog(@"testing ginza menu view");
    
    SubMenuSearchViewController  *searchViewController = [[SubMenuSearchViewController alloc]init];
    
    [self presentModalViewController:searchViewController animated:YES];
    
    
}

-(IBAction)btnGinzaMenu:(id)sender
{
    }

#pragma mark CLLocation Delegates methods
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    currentLocation =  [newLocation retain];   
    //currentLocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
    
    
    //NSLog(@"didUpdateToLocation");
     [tblListView reloadData];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading 
{
    // UITableViewCell *cell =  (UITableViewCell *)[tblListView cellForRowAtIndexPath:[NSIndexPath indexPathWithIndex:2]];
    
    
    //  NSLog(@"update heading....");
    
    //  newHeadingObject = [[CLHeading alloc]init];
    newHeadingObject = newHeading;
    mHeading = newHeadingObject.magneticHeading;
    
    //imgDirection.image= [UIImage imageNamed:@"Arrow.png"];
    
   
    
    if ((mHeading >= 339) || (mHeading <= 22)) {
      //  NSLog(@"User Headingaa ......->N");
        currenDirection = @"N";
       
    }else if ((mHeading > 23) && (mHeading <= 68)) {
        currenDirection = @"NE";
        // NSLog(@"User Heading ......->NE");
    }else if ((mHeading > 69) && (mHeading <= 113)) {
         currenDirection = @"E";
        // NSLog(@"User Heading ......->E");
    }else if ((mHeading > 114) && (mHeading <= 158)) {
          currenDirection = @"SE";
        // NSLog(@"User Heading ......->SE");
    }else if ((mHeading > 159) && (mHeading <= 203)) {
          currenDirection = @"S";
       //  NSLog(@"User Heading ......->S");
    }else if ((mHeading > 204) && (mHeading <= 248)) {
       currenDirection = @"SW";
       //  NSLog(@"User Heading ......->SW");
    }else if ((mHeading > 249) && (mHeading <= 293)) {
        currenDirection = @"W";
       ///  NSLog(@"User Heading ......->W");
    }else if ((mHeading > 294) && (mHeading <= 338)) {
       
         //NSLog(@"User Heading ......->NW");
     currenDirection = @"NW";
    }
    
    
    if ([currenDirection isEqualToString:previousDirection ]){
        
    }
    else {
        NSLog(@"Table Reload Called");
       [tblListView reloadData];
        previousDirection = currenDirection;
    }
    
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
    // NSLog(@"Rotate:%f",degrees);
    
    
    return degrees = degrees + acos(cosDegrees);
    
}


-(float) bearingBetweenStartLocation:(CLLocation *)startLocation andEndLocation:(CLLocation *)endLocation{
    
    CLLocation *northPoint = [[CLLocation alloc] initWithLatitude:(startLocation.coordinate.latitude)+.01 longitude:endLocation.coordinate.longitude] ;
    float magA = [northPoint distanceFromLocation:startLocation];
    float magB = [endLocation distanceFromLocation:startLocation];
    CLLocation *startLat = [[CLLocation alloc] initWithLatitude:startLocation.coordinate.latitude longitude:0] ;
    CLLocation *endLat = [[CLLocation alloc] initWithLatitude:endLocation.coordinate.latitude longitude:0] ;
    float aDotB = magA*[endLat distanceFromLocation:startLat];
    return RADIANS_TO_DEGREES(acosf(aDotB/(magA*magB)));
}

//Calculate Distance and Time
- (NSString *)calculateDistance : (double) aDistance {
    NSString *strDist;
    double d=aDistance/1000;
    if (d>1.0) {
            strDist=[NSString stringWithFormat:@"%.1fkm",d];
    }
    else {
            strDist=[NSString stringWithFormat:@"%.fm",aDistance];
        }
    return strDist;
}

- (NSString *) calculateTime: (int) aTime {
    NSString *strTime;
    if (aTime>60) {
        int hours=aTime/60;
        int minutes=aTime%60;
        strTime=[NSString stringWithFormat:@"(徒歩%d時間%d分)",hours,minutes];
    }
    else {
        strTime=[NSString stringWithFormat:@"(徒歩%d分)",aTime];
    }
    return  strTime;
}

- (void)viewDidappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
   
}
- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
     self.cbar.hidden=YES;    
}


@end
