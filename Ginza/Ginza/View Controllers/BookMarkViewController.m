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

    
}

-(void)viewDidDisappear:(BOOL)animated
{
    cbar.hidden=YES;
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
    }
    
     //[cell initlocation];
     return cell;

    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        OfferDetailsViewController *detail =[[OfferDetailsViewController alloc]init];
        Offer *offer =[dataArray objectAtIndex:indexPath.row];
        
        detail.offerId = offer.offer_id;
        [self presentModalViewController:detail animated:YES];
        

    
}



-(IBAction)GinzaswipeDown:(id)sender
{
    NSLog(@"testing ginza menu view");
    
    //GinzaSubViewController *infoViewController = [[GinzaSubViewController alloc]initWithNibName:@"GinzaSubViewController" bundle:nil];
    
    GinzaSubViewController *infoViewController = [[GinzaSubViewController alloc]init];
    
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
@end
