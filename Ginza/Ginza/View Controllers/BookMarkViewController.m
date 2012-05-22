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
@synthesize mStrImageDirectoryPath;
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

static NSString *CellClassName = @"ListViewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"お気に入り", @"お気に入り");
        self.tabBarItem.image = [UIImage imageNamed:@"Bookmarkicon"];
        cellLoader = [[UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]] retain];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateTopNavigation];
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.dataArray = [appDeligate getBookmarkOfferData];
    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[appDeligate.ginzaEvents count]];
    if ([appDeligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }

    self.tblListView.sectionIndexMinimumDisplayRowCount = 5;
    self.mStrImageDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.mStrImageDirectoryPath  = [mStrImageDirectoryPath stringByAppendingString:@"/"];
    
    NSString *filterCatString =@"";
    appDeligate.arraySelectedCategories =[[NSMutableArray alloc]init ];
    [appDeligate getCategories];
    [appDeligate getSubCategories];
    for (int index=0; index<[appDeligate.arraySelectedCategories count]; index++) {
        
        Categories *c =(Categories *)[appDeligate getCategoryDataById:[appDeligate.arraySelectedCategories objectAtIndex:index]];
        filterCatString =[filterCatString stringByAppendingFormat:@"%@,",c.category_name];
    }
    self.lblFilterText.text = filterCatString;    
    
    
    int i = [appDeligate.getBookmarkOfferData count];
    if (i>0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", i];
    }
     
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.dataArray = [appDeligate getBookmarkOfferData];
    [self.tblListView reloadData];
    self.navigationController.navigationBarHidden = YES;
    cbar.hidden=NO;
    [self createConstantImages];
}

-(void)viewDidDisappear:(BOOL)animated
{
    cbar.hidden=YES;
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [self.tblListView reloadData];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListViewCell *cell = (ListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];
    
    if (!cell) {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];

    }
    cell.lblCategoryName.text=@"";
    cell.lblStoreName.text=@"";
    cell.thumbnailImageView.image=nil;
    cell.lblDirection.text=@"";
    cell.lblTime.text=@"";
    cell.arrowImageView.image=nil;
    [cell.GIconImageView setHidden:YES];
    cell.lblSpecialOffer.text =@"";
    cell.contentView.backgroundColor=[UIColor clearColor];
    storeLatitude=0.0;
    storeLongitude=0.0;
    cell.lblCategoryName.textColor=[UIColor colorWithRed:102.0/255.0 
                                                       green:102.0/255.0 
                                                        blue:102.0/255.0
                                                       alpha:1.0];
        
    cell.lblStoreName.textColor=[UIColor blackColor];
    [cell.GIconImageView setHidden:YES];
    Offer *offer =[dataArray objectAtIndex:indexPath.row];
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    ShopList *shopData = [appDeligate getStoreDataById:offer.store_id];
    Categories *categoryData = (Categories *)[appDeligate getCategoryDataById:shopData.sub_category];
    categoryName=categoryData.category_name;
    storeName=shopData.store_name;
    cell.offer = offer;
    thumbnailPath = [self.mStrImageDirectoryPath  stringByAppendingString:[NSString stringWithFormat:@"80x60_%@",categoryData.image_name]];
        
    if ([offer.isbookmark isEqualToString:@"1"]) {
            [cell.bookMarkImageView setImage:bookMarkMinusImage forState:UIControlStateNormal];
    }
    else {
            [cell.bookMarkImageView setImage:bookMarkPlusImage forState:UIControlStateNormal];
    }
        
    if([offer.offer_type isEqualToString:@"special"]) {
        cell.contentView.backgroundColor=[UIColor colorWithRed:242.0/255.0 
                                                             green:234.0/255.0 
                                                              blue:203.0/255.0 
                                                             alpha:1.0];
            
        NSString *sOff=[NSString stringWithFormat:@"★ %@",offer.lead_text];
        cell.lblSpecialOffer.text = sOff;
        cell.lblSpecialOffer.textColor = [UIColor colorWithRed:192/255.0 
                                                             green:150.0/255.0 
                                                              blue:49.0/255.0 
                                                             alpha:5.0];
    }
        storeLatitude=[shopData.latitude doubleValue];
        storeLongitude=[shopData.longitude doubleValue];
        cell.arrowImageView.image=arrowImageBlue;
    
    //Distance Calculation
    double distance=[[Location sharedInstance] getDistanceFromLatitude:storeLatitude
                                                          andLongitude:storeLongitude];
    cell.lblDirection.text=[[Location sharedInstance] formatDistance:distance];
    //cell.lblDirection.text=@"7km";
    //cell.lblTime.text=@"(1)";
    if (distance<MIN_DISTANCE) {
        if ([cell.lblDirection.text length]<=3) {
            cell.arrowImageView.frame=CGRectMake(cell.arrowImageView.frame.origin.x, cell.arrowImageView.frame.origin.y,cell.arrowImageView.frame.size.width, cell.arrowImageView.frame.size.height);
        }
        else {
            cell.arrowImageView.frame=CGRectMake(cell.arrowImageView.frame.origin.x, cell.arrowImageView.frame.origin.y,cell.arrowImageView.frame.size.width, cell.arrowImageView.frame.size.height);
        }
        
        cell.lblDirection.frame=CGRectMake(cell.lblDirection.frame.origin.x, cell.lblDirection.frame.origin.y,48, cell.lblDirection.frame.size.height);
        int time=[[Location sharedInstance] getTimeFromLatitude:storeLongitude  
                                                   andLongitude:storeLongitude];
        
        cell.lblTime.text=[[Location sharedInstance] formatTime:time];
        
    }
    else {
        cell.lblDirection.frame=CGRectMake(cell.lblDirection.frame.origin.x, cell.lblDirection.frame.origin.y,90, cell.lblDirection.frame.size.height);
    }
    cell.lblCategoryName.text=categoryName;
    cell.lblStoreName.text=storeName;
    double angle=[[Location sharedInstance] getAngleFromLatitude:storeLongitude 
                                                    andLongitude:storeLongitude];
    cell.thumbnailImageView.image=[UIImage imageWithContentsOfFile:thumbnailPath];
    cell.arrowImageView.transform = CGAffineTransformMakeRotation(angle);
    return cell;
}




/*
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

*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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


- (void) createConstantImages {
    bookMarkMinusImage=[UIImage imageNamed:@"Bookmarkminus.png"];
    bookMarkPlusImage=[UIImage imageNamed:@"Bookmarkplus.png"];
    ginzaGIcon= [UIImage imageNamed:@"Giconlarge.png"];;
    ginzaBackgroundImageSpecial=[UIImage imageNamed:@"Specialoffercellbg.png"];
    arrowImageBlue=[UIImage imageNamed:@"Arrow.png"];
    arrowImageGray= [UIImage imageNamed:@"Arrowgray.png"];
    ginzaBackgroundImageFirstRow=[UIImage imageNamed:@"Ginzacelllist.png"];
    thumbImage=[UIImage imageNamed:@"thumb.png"];
}





@end
