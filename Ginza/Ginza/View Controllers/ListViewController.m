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
@synthesize arrayOfImages,listDataArray,dataDict,lblFilterText,lblEventCount,currentPage;



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
    [super viewDidLoad];
    currentPage=1;
    self.navigationController.navigationBar.hidden = YES;
    
     AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.dataArray = appDeligate.offerDataArray ;
    self.lblEventCount.hidden =NO;
    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[appDeligate.ginzaEvents count]];
    if ([appDeligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }
    self.dataDict =appDeligate.listViewDataArray;
    self.tblListView.delegate = self;

    self.tblListView.sectionIndexMinimumDisplayRowCount = 5;
    
    
   // tblListView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,55, 320, 480)];
    
    tblListView.dataSource = self;
    tblListView.delegate   = self;
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    return;
    self.navigationController.navigationBarHidden = YES;
   }
-(void)viewDidDisappear:(BOOL)animated
{
    
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
    
    
    return  currentPage+10+2;//[self.dataDict count]+1;
    
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
    @try {
        
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell ;
    
    if (indexPath.row ==  currentPage+10+1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.text = @"次の10件を表示する";
        return cell;
    }else
    {
    static NSString *CellIdentifier = @"Cell1";
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ListViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (ListViewCell*)view;
                
                NSLog(@"cells");
                break;
            }
        }
        
    }
    cell.btnBookMark.tag =indexPath.row-1;
    if (indexPath.row>=1) {
       
        NSDictionary *tmpDict = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row-1]];
        Offer *offer = [tmpDict objectForKey:@"offer"];    
        Categories *categoryData = [tmpDict objectForKey:@"cat"];
        ShopList *shopData = [tmpDict objectForKey:@"shop"];
      
    
       NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:@"/"];
        path = [path stringByAppendingString:categoryData.image_name];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        
        /*float actualHeight = 60;//image.size.height;
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
        
        
        [cell.imgDeatils setImage:img];*/
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
    [cell initlocation];
    cell.offerType = @"list";
        return cell;
    }
     
    }
    @catch (NSException *exception) {
        NSLog(@"Table error");
    }
    @finally {
         
    }

}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [locationManager stopUpdatingLocation];
    if (indexPath.row ==  currentPage+10+1) {
        currentPage =currentPage+10;
        [self.tblListView reloadData];
    }else
    {
    
    
    if(indexPath.row == 0)
    {
        
        GinzaDetailsViewController *ginzadetail =[[GinzaDetailsViewController alloc]init];
        
        [self presentModalViewController:ginzadetail animated:YES];
        
    }
    
    else
    {
    
        OfferDetailsViewController *detail =[[OfferDetailsViewController alloc]init];
        Offer *offer =[dataArray objectAtIndex:indexPath.row-1];
        
        detail.offerId = offer.offer_id;
        
        
        [self presentModalViewController:detail animated:YES];
        
    
        }

    }
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


@end
