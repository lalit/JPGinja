//
//  OfferDetailsViewController.m
//  Ginza
//
//  Created by administrator on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OfferDetailsViewController.h"
#import "AppDelegate.h"
#import "ShopList.h"
#import "Offer.h"
#import "Categories.h"
#import "ShareViewController.h"
#import "DirectionViewController.h"
@implementation OfferDetailsViewController
@synthesize lblIsChild,lblIsLunch,lblIsPrivate,lblOfferTitle,lblCategoryName,lblDistanceLabel,imgIsChild,imgIsLunch,imgCategory,imgIsPrivate,imgOfferImage,offerId,scroll,webFreeText,storeLocation,offer;
@synthesize viewOfferDetails,tableView,locationManager,imgDirection,arrowImage,shareVC;

@synthesize btnSepecialOffers;
@synthesize imgOfferdetailsView,bottomView,currentLocation,btnBookMark;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    [locationManager startUpdatingHeading];
    
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.offer =  [appDeligate getOfferDataById:self.offerId];
    NSLog(@"DetailView Offer:%@",self.offerId);
    lblCategoryName.text = self.offer.category;
    lblOfferTitle.text=self.offer.offer_title;
    scroll.contentSize = CGSizeMake(320, 1000);
    self.webFreeText.backgroundColor =[UIColor clearColor];
    [self.webFreeText setOpaque:NO];
    NSString *weViewData =[NSString stringWithFormat:@"<HTML><body style=\"background-color:transparent\"><table><tr><td>%@<hr></td></tr><tr><td>%@</td></tr><tr><td>%@</td></tr></table></HTML>",offer.lead_text,offer.copy_text,offer.free_text];
    [self.webFreeText loadHTMLString:weViewData baseURL:nil];
    
    
    ShopList *merchant = [appDeligate getStoreDataById:offer.store_id];
    Categories *categoryData = (Categories *)[appDeligate getCategoryDataById:merchant.sub_category];
    
    //Get Shop Location
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"/"];
    path = [path stringByAppendingString:categoryData.image_name];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    
    float actualHeight = 154;//image.size.height;
    float actualWidth = 206;//image.size.width;
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
    
    
    [self.imgOfferImage setImage:img]; 

    if ([offer.isbookmark isEqualToString:@"1"]) {
        
        [btnBookMark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
    }
    else {
        [btnBookMark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
    }
    
    
    actualHeight = 38;//image.size.height;
    actualWidth = 47;//image.size.width;
    imgRatio = actualWidth/actualHeight;
    maxRatio = 320.0/480.0;
    
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
    rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    

    
    [self.imgCategory setImage:img];
    
    double Latitude = [merchant.latitude doubleValue];
    double Longitude = [merchant.longitude doubleValue];
    
    
    
    self.storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    
    
    CLLocationDistance meters = [self.currentLocation distanceFromLocation:self.storeLocation];
    //4000 mtr = 15 min
    //NSLog(@"meters %d",meters);
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    self.lblDistanceLabel.text =[NSString stringWithFormat:@" %.fm (徒歩%d分)",meters,time];

    
   
    if (merchant.is_child == 0) {
        lblIsChild.hidden = YES;
        imgIsChild.hidden =YES;
    }
    if (merchant.is_lunch == 0) {
        lblIsLunch.hidden = YES;
        imgIsLunch.hidden = YES;
    }
    if (merchant.is_private == 0) {
        lblIsPrivate.hidden = YES;
        imgIsPrivate.hidden = YES;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}
-(IBAction)btnOfferDetailsOpenClose:(id)sender
{
    UIButton *btn = sender;
    if(btn.tag ==0)
    {
        CGRect rec = self.viewOfferDetails.frame;
        rec.size.height = 500;
        self.viewOfferDetails.frame = rec;
        [self.scroll scrollRectToVisible:self.viewOfferDetails.frame animated:YES];
        CGRect rec1 =  self.bottomView.frame;
        rec1.origin.y = rec.origin.y + rec.size.height+20;
        self.bottomView.frame = rec1;
        btn.tag =1;
        [self.arrowImage setImage:[UIImage imageNamed:@"Arrowwhitedown.png"]];
    }else
    {
        CGRect rec = self.viewOfferDetails.frame;
        rec.size.height = 115;
        self.viewOfferDetails.frame = rec;
        [self.scroll scrollRectToVisible:self.viewOfferDetails.frame animated:YES];
        CGRect rec1 =  self.bottomView.frame;
        rec1.origin.y = rec.origin.y + rec.size.height+20;
        self.bottomView.frame = rec1;
       
        btn.tag=0;
        [self.arrowImage setImage:[UIImage imageNamed:@"Arrowwhite.png"]];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return  4;
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate  *appDeligate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
    Offer *offer =  [appDeligate getOfferDataById:self.offerId];
    
    ShopList *merchant = [appDeligate getStoreDataById:offer.store_id];
    NSLog(@"Offer id = %@,%@",self.offerId,offer.store_id);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row==0) {
        
        UILabel *lblAddress = [[UILabel alloc]init];
        lblAddress.frame = CGRectMake(0,0,150, 40);
        lblAddress.textAlignment = UITextAlignmentLeft;
        
       
        lblAddress.font = [UIFont systemFontOfSize:12];

        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = [UIColor blackColor];
        lblAddress.text = @"所在地";

        [cell addSubview:lblAddress];
        
        UILabel *lblAddressdetails = [[UILabel alloc]init];
        lblAddressdetails.frame = CGRectMake(150,0,150, 40);
        lblAddressdetails.textAlignment = UITextAlignmentCenter;
        lblAddressdetails.lineBreakMode = UILineBreakModeWordWrap;
        lblAddressdetails.numberOfLines = 3;
        
        lblAddressdetails.font = [UIFont systemFontOfSize:12];
        lblAddressdetails.backgroundColor = [UIColor clearColor];
        lblAddressdetails.textColor = [UIColor blackColor];
        lblAddressdetails.text = merchant.address;

        [cell addSubview:lblAddressdetails];
        
        
      //  NSLog(@"Shop Address = %@", merchant.address);
    }
    if (indexPath.row==1) {
        
        
        UILabel *lblphone = [[UILabel alloc]init];
        lblphone.frame = CGRectMake(0,0,150, 40);
        lblphone.textAlignment = UITextAlignmentLeft;
        
        
        lblphone.font = [UIFont systemFontOfSize:12];
        
        lblphone.backgroundColor = [UIColor clearColor];
        lblphone.textColor = [UIColor blackColor];
        lblphone.text = @"電話番号";
        
        [cell addSubview:lblphone];
        
        UILabel *lblphonedetails = [[UILabel alloc]init];
        lblphonedetails.frame = CGRectMake(150,0,150, 40);
        lblphonedetails.textAlignment = UITextAlignmentCenter;
        lblphonedetails.lineBreakMode = UILineBreakModeWordWrap;
        lblphonedetails.numberOfLines = 3;
        
        lblphonedetails.font = [UIFont systemFontOfSize:12];
        lblphonedetails.backgroundColor = [UIColor clearColor];
        lblphonedetails.textColor = [UIColor blackColor];
        lblphonedetails.text = merchant.phone;
        
        [cell addSubview:lblphonedetails];
        
        
        
        
        
    }
    if (indexPath.row==2) {
        
        
        UILabel *lbltime = [[UILabel alloc]init];
        lbltime.frame = CGRectMake(0,0,150, 40);
        lbltime.textAlignment = UITextAlignmentLeft;
        
        
        lbltime.font = [UIFont systemFontOfSize:12];
        
        lbltime.backgroundColor = [UIColor clearColor];
        lbltime.textColor = [UIColor blackColor];
        lbltime.text = @"営業時間";
        
        [cell addSubview:lbltime];
        
        UILabel *lbltimedetails = [[UILabel alloc]init];
        lbltimedetails.frame = CGRectMake(150,0,150, 40);
        lbltimedetails.textAlignment = UITextAlignmentCenter;
        lbltimedetails.lineBreakMode = UILineBreakModeWordWrap;
        lbltimedetails.numberOfLines = 3;
        
        lbltimedetails.font = [UIFont systemFontOfSize:12];
        lbltimedetails.backgroundColor = [UIColor clearColor];
        lbltimedetails.textColor = [UIColor blackColor];
        lbltimedetails.text = merchant.time;
        
        [cell addSubview:lbltimedetails];
        
        
                
        
    }
    if (indexPath.row==3) 
    {
        
        UILabel *lblholiday = [[UILabel alloc]init];
        lblholiday.frame = CGRectMake(0,0,150, 40);
        lblholiday.textAlignment = UITextAlignmentLeft;
        
        
        lblholiday.font = [UIFont systemFontOfSize:12];
        
        lblholiday.backgroundColor = [UIColor clearColor];
        lblholiday.textColor = [UIColor blackColor];
        lblholiday.text = @"定休日";
        
        [cell addSubview:lblholiday];
        
        UILabel *lblholidaydetails = [[UILabel alloc]init];
        lblholidaydetails.frame = CGRectMake(150,0,150, 40);
        lblholidaydetails.textAlignment = UITextAlignmentCenter;
        lblholidaydetails.lineBreakMode = UILineBreakModeWordWrap;
        lblholidaydetails.numberOfLines = 3;
        
        lblholidaydetails.font = [UIFont systemFontOfSize:12];
        lblholidaydetails.backgroundColor = [UIColor clearColor];
        lblholidaydetails.textColor = [UIColor blackColor];
        lblholidaydetails.text = merchant.holiday;
        
        [cell addSubview:lblholidaydetails];
        
        
        
    }
    // Configure the cell...
    
    return cell;
    
        
}

-(IBAction)btnClose:(id)sender
{
    [locationManager stopUpdatingHeading];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    self.currentLocation=newLocation;
    
    CLLocationDistance meters = [self.currentLocation distanceFromLocation:self.storeLocation];
    //4000 mtr = 15 min
    //NSLog(@"meters %d",meters);
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    self.lblDistanceLabel.text =[NSString stringWithFormat:@" %.fm (徒歩%d分)",meters,time];

}

-(IBAction)btnBookmark:(id)sender
{
    
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDeligate updateBookMarkCount:self.offer];
    
    
    if ([self.offer.isbookmark isEqualToString:@"0"]) {
        
        [btnBookMark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
    }
    else {
        [btnBookMark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];  
    }
    return;
}
//=======================================================================================================================
//Added by Mobiquest team

- (IBAction)getDirectionButtonPressed:(id)sender {
    DirectionViewController *directionVC=[[DirectionViewController alloc] initWithNibName:@"DirectionViewController" bundle:nil];
    NSString *lat=[NSString stringWithFormat:@"%lf",self.storeLocation.coordinate.latitude];
    NSString *lon=[NSString stringWithFormat:@"%lf",self.storeLocation.coordinate.longitude];
    [directionVC setLat:lat setLong:lon];
    [self presentModalViewController:directionVC animated:YES];
}

- (IBAction)sharedButtonPressed:(id)sender {
    UIActionSheet * selectionSheet = [[UIActionSheet alloc] initWithTitle: @"Share" delegate: self cancelButtonTitle: @"Cancel" destructiveButtonTitle: nil otherButtonTitles: @"Facebook", @"Twitter", @"Email",nil]; 
    [selectionSheet showInView:self.view]; 
}

- (void) actionSheet: (UIActionSheet *) actionSheet didDismissWithButtonIndex: (NSInteger) buttonIndex { 
    if (buttonIndex == 0) { 
        NSLog (@"buttonIndex:% i", buttonIndex); 
        [self postFacebook];
    } 
    else if (buttonIndex == 1) { 
        NSLog (@"buttonIndex:% i", buttonIndex);
        [self postTwitter];
    } 
    else if (buttonIndex == 2) { 
        [self sendEmail];
    }
    else 
        NSLog (@"buttonIndex:% i", buttonIndex); 
} 

- (void) postFacebook
{
	if (self.shareVC == nil) {
		
		self.shareVC = [[ShareViewController alloc] init];
	}
    NSLog(@"Message:%@",[self shareKitMessage]);
    [self.shareVC launchFacebookWithStr:[self shareKitMessage] WithImage:nil withParentVC:self withImagePath:nil];
}

- (void) postTwitter
{
	if (self.shareVC == nil) {
		self.shareVC = [[ShareViewController alloc] init];
	}

	[self.shareVC launchTwitter:self withString:[self shareKitMessage]];
}
- (void) sendEmail
{
	if (self.shareVC == nil) {
		self.shareVC = [[ShareViewController alloc] init];
	}
	[self.shareVC launchMail:self withString:[self shareKitMessage]];	
}

-(NSString *)shareKitMessage {
        NSString *strMessage=[NSString stringWithFormat:@"Offer Title: %@,Location:%lf,%lf",self.offer.offer_title, self.storeLocation.coordinate.latitude,self.storeLocation.coordinate.longitude];
    return strMessage;
}

@end
