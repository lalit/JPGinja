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
#import "GinaViewController.h"
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
#import "ListViewCell.h"
#import "CustomTopNavigationBar.h"
#import "Location.h"

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
@synthesize mStrImageDirectoryPath;

static NSString *CellClassName = @"ListViewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"一覧", @"一覧");
        self.tabBarItem.image = [UIImage imageNamed:@"Listicon"];
        cellLoader = [[UINib nibWithNibName:CellClassName bundle:[NSBundle mainBundle]] retain];
    }
    return self;
}
- (void)viewDidLoad {
    self.mStrImageDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    self.mStrImageDirectoryPath  = [mStrImageDirectoryPath stringByAppendingString:@"/"];
    [self createConstantImages];
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
    [self updateTopNavigation];
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(locationChanged:) 
                                                 name:kLocationChangedNotification
                                               object:nil];
    
}

- (void)locationChanged: (NSNotification*)aNotification {
    [listViewTable reloadData];
}

- (void)updateTopNavigation {
    UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
    cbar = [[CustomTopNavigationBar alloc]initWithFrame:CGRectMake(0, 0,transView.frame.size.width, 40)];
    cbar.viewController = self;
    cbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:cbar];
}

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate *appDeligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    dataDict =appDeligate.listViewDataArray;
    self.navigationController.navigationBarHidden = YES;
    self.cbar.hidden=NO;
}

- (void)viewDidappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataDict count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ListViewCell *cell = (ListViewCell *)[tableView dequeueReusableCellWithIdentifier:CellClassName];

    if (!cell) {
        NSArray *topLevelItems = [cellLoader instantiateWithOwner:self options:nil];
        cell = [topLevelItems objectAtIndex:0];
        arrowX=cell.arrowImageView.frame.origin.x;
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
    if (indexPath.row==0) {
        cell.contentView.backgroundColor=[UIColor colorWithRed:179.0/255.0 
                                                         green:179.0/255.0 
                                                          blue:179.0/255.0 
                                                         alpha:1.0];
        categoryName=@"ダイナ;ースクラフ";
        storeName=@"銀座ラウンシ";
        storeLatitude=35.665756;
        storeLongitude=139.7117;
        [cell.GIconImageView setHidden:NO];
        cell.GIconImageView.image=ginzaGIcon;
     
        thumbnailPath=[[NSBundle mainBundle] pathForResource:@"thumb" ofType:@"png"];
        cell.arrowImageView.image=arrowImageGray;
        cell.lblCategoryName.textColor=[UIColor whiteColor];
        cell.lblStoreName.textColor=[UIColor whiteColor];
    }
    else {
        cell.lblCategoryName.textColor=[UIColor colorWithRed:102.0/255.0 
                                                       green:102.0/255.0 
                                                        blue:102.0/255.0
                                                       alpha:1.0];
        
        cell.lblStoreName.textColor=[UIColor blackColor];
        [cell.GIconImageView setHidden:YES];
        NSDictionary *tmpDict = [self.dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row-1]];
        Offer *offer = [tmpDict objectForKey:@"offer"];    
        Categories *categoryData = [tmpDict objectForKey:@"cat"];
        ShopList *shopData = [tmpDict objectForKey:@"shop"];
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
    }
  
   //Distance Calculation
    double distance=[[Location sharedInstance] getDistanceFromLatitude:storeLatitude
                                                          andLongitude:storeLongitude];
    cell.lblDirection.text=[[Location sharedInstance] formatDistance:distance];
   // distance=0.0;
    //cell.lblDirection.text=@"7m";
    //cell.lblTime.text=@"(1)";
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        self.ginzaDetailsView =[[GinzaDetailsViewController alloc]init];
        [self presentModalViewController:ginzaDetailsView animated:YES];
    }
    else {
        self.detailsView =[[OfferDetailsViewController alloc]initWithNibName:@"OfferDetailsViewController" bundle:nil];
         Offer *offer =[dataArray objectAtIndex:indexPath.row-1];
         detailsView.offerId = offer.id;
        [self presentModalViewController:detailsView animated:YES];
    }
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


-(IBAction)GinzaswipeDown:(id)sender {
    GinzaSubViewController  *infoViewController = [[GinzaSubViewController alloc]init];
    [self.navigationController pushViewController:infoViewController animated:NO];
}

-(IBAction)GinzaSearchView:(id)sender {
    SubMenuSearchViewController  *searchViewController = [[SubMenuSearchViewController alloc]init];
    [self presentModalViewController:searchViewController animated:YES];
}

-(IBAction)getUserDetails:(id)sender {}
-(IBAction)btnGinzaMenu:(id)sender { }
-(IBAction)GinzafilterViewDown:(id)sender {}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    self.cbar.hidden=YES;    
}

@end
