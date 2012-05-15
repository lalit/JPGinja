//
//  BookMarkViewController.m
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookMarkViewController.h"
#import "GinzaConstants.h"
#import "GinaViewController.h"
#import "GinzaFilterViewController.h"
#import "ListViewCell.h"


#import "AppDelegate.h"
#import "OfferDetailsViewController.h"
#import "SubMenuSearchViewController.h"
#import "GinzaFilterViewController.h"
#import "SearchViewController.h"
#import "GinzaSubViewController.h"
#import"Categories.h"
#import "Offer.h"
#import "GinzaDetailsViewController.h"
#import "CustomTopNavigationBar.h"


#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
//double DegreesToRadians(double degrees) {return degrees * M_PI / 180.0;};
//double RadiansToDegrees(double radians) {return radians * 180.0/M_PI;};
@interface BookMarkViewController ()

@end

@implementation BookMarkViewController


@synthesize tblListView;
@synthesize detailsViewController;
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
@synthesize imgViewditection,dataArray,currentLocation;
@synthesize swipeGestureDown;
@synthesize panGestureforFiter;
@synthesize panGestureforSearch;
@synthesize arrayOfImages,lblFilterText,lblEventCount,cbar;


double DegreesToRadians2(double degrees) {return degrees * M_PI / 180.0;};
double RadiansToDegrees2(double radians) {return radians * 180.0/M_PI;};
-(double) bearingToLocation:(CLLocation *) destinationLocation {
    
    double lat1 = DegreesToRadians2(currentLocation.coordinate.latitude);
    double lon1 = DegreesToRadians2(currentLocation.coordinate.longitude);
    
    double lat2 = DegreesToRadians2(destinationLocation.coordinate.latitude);
    double lon2 = DegreesToRadians2(destinationLocation.coordinate.longitude);
    
    double dLon = lon2 - lon1;
    
    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);
    double radiansBearing = atan2(y, x);
    if(radiansBearing < 0.0)
        radiansBearing += 2*M_PI;
    
    
    return DegreesToRadians2(radiansBearing);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"お気に入り", @"お気に入り");
        self.tabBarItem.image = [UIImage imageNamed:@"Bookmarkicon"];
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    [self updateTopNavigation];
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.dataArray = [appDeligate getBookmarkOfferData];

    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[appDeligate.ginzaEvents count]];
    if ([appDeligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }

    self.tblListView.delegate = self;

    self.tblListView.sectionIndexMinimumDisplayRowCount = 5;
    
    
    NSString *filterCatString =@"";
    appDeligate.arraySelectedCategories =[[NSMutableArray alloc]init ];
    [appDeligate getCategories];
    [appDeligate getSubCategories];
    for (int index=0; index<[appDeligate.arraySelectedCategories count]; index++) {
        
        Categories *c =(Categories *)[appDeligate getCategoryDataById:[appDeligate.arraySelectedCategories objectAtIndex:index]];
        filterCatString =[filterCatString stringByAppendingFormat:@"%@,",c.category_name];
    }
    self.lblFilterText.text = filterCatString;    
    
    
    tblListView.dataSource = self;
    tblListView.delegate   = self;
    
    int i = [appDeligate.getBookmarkOfferData count];
    if (i>0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", i];
    }
     
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.dataArray = [appDeligate getBookmarkOfferData];
    [self.tblListView reloadData];
    self.navigationController.navigationBarHidden = YES;
    
    
    cbar.hidden=NO;

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter =1; // whenever we move
    locationManager.headingFilter = 5;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters; // 100 m
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];

    
}

-(void)viewDidDisappear:(BOOL)animated
{
    cbar.hidden=YES;
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [self.tblListView reloadData];
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
    
    
    return  [dataArray count];
    
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
                break;
            }
        }
    }
    cell.btnBookMark.tag =indexPath.row;

    if (indexPath.row>=0) {
        Offer *offer =[dataArray objectAtIndex:indexPath.row];
        
        
        AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        ShopList *shopData = [appDeligate getStoreDataById:offer.store_id];
        Categories *categoryData = (Categories *)[appDeligate getCategoryDataById:shopData.sub_category];
        
        
        
        
        
        if([offer.isbookmark isEqualToString:@"1"])
        {
         [cell.btnBookMark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
            cell.offer = offer;
        cell.lblTitle.text = categoryData.category_name;

            if (categoryData.image_name != nil) {
                
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                path = [path stringByAppendingString:@"/"];
                path = [path stringByAppendingString:categoryData.image_name];
                
                NSLog(@"Image name = %@",categoryData.image_name);
                UIImage *image = [UIImage imageWithContentsOfFile:path];
                
                
                float actualHeight = 60;//image.size.height;
                float actualWidth = 80;//image.size.width;
                float imgRatio = actualWidth/actualHeight;
                float maxRatio = 320.0/480.0;
                
                if(imgRatio!=maxRatio){
                    if(imgRatio < maxRatio){
                        imgRatio = 480.0 / actualHeight;
                        actualWidth = imgRatio * actualWidth;
                        actualHeight = 480.0;
                    }
                    else{
                        imgRatio = 320.0 / actualWidth;
                        actualHeight = imgRatio * actualHeight;
                        actualWidth = 320.0;
                    }
                }
                CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
                UIGraphicsBeginImageContext(rect.size);
                [image drawInRect:rect];
                UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                
                [cell.imgDeatils setImage:img];
            }
            
        cell.largeGIconImageView.hidden=YES;
        cell.lblDescription.text = shopData.store_name;
        cell.lblDescription.font = [UIFont systemFontOfSize:12];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;  

        if([offer.offer_type isEqualToString:@"special"])
        {
            cell.imgGinzaBackground.image = [UIImage imageNamed:@"Specialoffercellbg.png"];
        }
        else
        {
            cell.imgGinzaBackground.image = [UIImage imageNamed:@"Normaloffercell.png"];
        }
            cell.imgDirection.image= [UIImage imageNamed:@"Arrow.png"];
        }
        cell.strLatitude = shopData.latitude;
        cell.strLongitude = shopData.longitude;
        
        double Latitude = [shopData.latitude doubleValue];
        double Longitude = [shopData.longitude doubleValue];
        Latitude = 35.665756;
        Longitude = 139.7117;
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
        CABasicAnimation *theAnimation;
        theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        theAnimation.duration = 0.5f;    
        [cell.imgDirection.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
        cell.imgDirection.transform = CGAffineTransformMakeRotation(radians);
    }
    
     //[cell initlocation];
     return cell;

    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [locationManager stopUpdatingLocation];
    [locationManager stopUpdatingHeading];
        
        OfferDetailsViewController *detail =[[OfferDetailsViewController alloc]init];
        Offer *offer =[dataArray objectAtIndex:indexPath.row];
        
        detail.offerId = offer.id;
        [self presentModalViewController:detail animated:YES];
        

    
}



-(IBAction)GinzaswipeDown:(id)sender
{
    NSLog(@"testing ginza menu view");
    
    //GinzaSubViewController *infoViewController = [[GinzaSubViewController alloc]initWithNibName:@"GinzaSubViewController" bundle:nil];
    
    GinzaSubViewController *infoViewController = [[[GinzaSubViewController alloc]init]autorelease];
    
    infoViewController.view.frame = CGRectMake(0,-320,320,480);
    
    [UIView beginAnimations:@"" context:nil];
    
    [self.navigationController pushViewController:infoViewController animated:NO];
    // [self presentModalViewController:infoViewController animated:YES];
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    
    [UIView setAnimationDuration:0.4]; 
    infoViewController.view.frame = CGRectMake(0,0,320,480);
    [UIView commitAnimations];
 
}

-(IBAction)filterAction:(id)sender
{
    
    
    NSLog(@"testing filter");
    
    
    GinzaFilterViewController  *filterViewController = [[GinzaFilterViewController alloc]initWithNibName:@"GinzaFilterViewController" bundle:nil];
    
    
    
    // filterViewController.view.frame = CGRectMake(0,-320,320,480);
    
    //    [UIView beginAnimations:@"" context:nil];
    //    
    //  //  [self.navigationController pushViewController:searchViewController animated:NO];
    //    [self presentModalViewController:filterViewController animated:NO];
    //
    //    self.tabBarController.hidesBottomBarWhenPushed = YES;
    //    
    //    
    //    [UIView setAnimationDuration:0.4];
    //    filterViewController.view.frame = CGRectMake(0,0,320,480);
    //    [UIView commitAnimations];
    
    [self.navigationController popToRootViewControllerAnimated:NO];

    
  // [self parentViewController:filterViewController animated:NO];
    [self.parentViewController addChildViewController:filterViewController];

    filterViewController.view.frame = CGRectMake(0,-320,320,480);
    
    [UIView beginAnimations:@"" context:nil];
    
    
    
    [UIView setAnimationDuration:0.4]; 
    filterViewController.view.frame = CGRectMake(0,0,320,480);
    [UIView commitAnimations];
    
    
    
    

}




-(void)viewDidAppear:(BOOL)animated
{
    
    
    self.navigationController.navigationBarHidden = YES;

}


-(IBAction)btnGinzaMenu:(id)sender
{
    GinzaSubViewController  *infoViewController = [[GinzaSubViewController alloc]init];
    infoViewController.currtentViewController = self;
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
    self.hidesBottomBarWhenPushed=YES;
    [UIView commitAnimations];
}

#import "GinzaFilterViewController.h"

-(IBAction)GinzafilterViewDown:(id)sender
{
    GinzaFilterViewController  *filterViewController = [[GinzaFilterViewController alloc]init];
    CGRect rect = filterViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    filterViewController.view.frame =rect;
    
    //filterViewController.currtentViewController = self;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:filterViewController animated:NO];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = filterViewController.view.frame;
    rect1.origin.y = 0;
    filterViewController.view.frame =rect1;
    self.hidesBottomBarWhenPushed=YES;
    [UIView commitAnimations];
    
}
#import "SubMenuSearchViewController.h"
-(IBAction)GinzaSearchView:(id)sender
{
    NSLog(@"testing ginza menu view");
    
    SubMenuSearchViewController  *searchViewController = [[SubMenuSearchViewController alloc]init];
    
    [self presentModalViewController:searchViewController animated:YES];
    
    
}

- (void)updateTopNavigation {
    UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
    cbar = [[CustomTopNavigationBar alloc]initWithFrame:CGRectMake(0, 0,transView.frame.size.width, 40)];
    cbar.viewController = self;
    cbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:cbar];
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
    
    //NSLog(@"RADIANS_TO_DEGREES:%f",RADIANS_TO_DEGREES(acosf(aDotB/(magA*magB))));
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


@end
