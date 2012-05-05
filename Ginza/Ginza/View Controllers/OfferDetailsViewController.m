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
#import "MapWithRoutesViewController.h"
#import "Location.h"
#import "ListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CustomTopNavigationBar.h"
@implementation OfferDetailsViewController
@synthesize lblIsChild,lblIsLunch,lblIsPrivate,lblOfferTitle,lblCategoryName,lblDistanceLabel,imgIsChild,imgIsLunch,imgCategory,imgIsPrivate,imgOfferImage,offerId,scroll,webFreeText,storeLocation,offer;
@synthesize viewOfferDetails,tableView,locationManager,imgDirection,arrowImage,shareVC,lblTime;

@synthesize btnSepecialOffers;
@synthesize imgOfferdetailsView,bottomView,currentLocation,btnBookMark,compassImageView;

double DegreesToRadians1(double degrees) {return degrees * M_PI / 180.0;};
double RadiansToDegrees1(double radians) {return radians * 180.0/M_PI;};

-(double) bearingToLocation:(CLLocation *) destinationLocation {
    double lat1 = DegreesToRadians1(self.currentLocation.coordinate.latitude);
    double lon1 = DegreesToRadians1(self.currentLocation.coordinate.longitude);
    
    double lat2 = DegreesToRadians1(destinationLocation.coordinate.latitude);
    double lon2 = DegreesToRadians1(destinationLocation.coordinate.longitude);
    
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
    //[self updateTopNavigation];
   // [self.view.window setBackgroundColor:[UIColor clearColor]];
    // Do any additional setup after loading the view from its nib.
   // [self.view setAlpha:0.0];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    [locationManager startUpdatingHeading];
    
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.offer =  [appDeligate getOfferDataById:self.offerId];
    NSLog(@"Title:%@",self.offer.offer_title);
    NSLog(@"Category:%@",self.offer.category);
    NSLog(@"Lead Text:%@",offer.lead_text);
    NSLog(@"Copy Text:%@",offer.copy_text);
    NSLog(@"DetailView Offer:%@",self.offerId);
    lblCategoryName.text = self.offer.category;
    lblOfferTitle.text=self.offer.offer_title;
    scroll.contentSize = CGSizeMake(320, 680);
    [[self.webFreeText.subviews objectAtIndex:0] setScrollEnabled:NO];
    self.webFreeText.backgroundColor =[UIColor clearColor];
    [self.webFreeText setOpaque:NO];
    [self loadWebView];
    [self.webFreeText setDelegate:self];
    [self calculateDistanceAndTime];
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
    
    [self.imgCategory setImage:[self resizeImage:[UIImage imageWithContentsOfFile:path] toSize:CGSizeMake(39,36)]];
    
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



- (void) calculateDistanceAndTime {
    
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    ShopList *merchant = [appDeligate getStoreDataById:offer.store_id];
    double Latitude = [merchant.latitude doubleValue];
    double Longitude = [merchant.longitude doubleValue];
    self.storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    CLLocationDistance meters = [self.currentLocation distanceFromLocation:self.storeLocation];
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    double distanceInKm=meters/1000;
    lblDistanceLabel.text=@"";
    lblTime.text=@"";
    if (distanceInKm>5.0) {
        lblDistanceLabel.text=@"この場所までの距離が分かりま せんでした";
        lblDistanceLabel.frame=CGRectMake(lblDistanceLabel.frame.origin.x, lblDistanceLabel.frame.origin.y, lblDistanceLabel.frame.size.width+200, lblDistanceLabel.frame.size.height);

    }
    else {
        if (time>60) {
            int hours=time/60;
            int minutes=time%60;
            self.lblTime.text=[NSString stringWithFormat:@"(徒歩%d時間%d分)",hours,minutes];
        }
        else {
            self.lblTime.text=[NSString stringWithFormat:@"(徒歩%d分)",time];
        }
        
           
        if (distanceInKm>1.0) {
            lblDistanceLabel.text=[NSString stringWithFormat:@"%.fkm",distanceInKm];
        }
        else {
            lblDistanceLabel.text=[NSString stringWithFormat:@"%.fm",meters];
        }
         lblTime.frame=CGRectMake(lblDistanceLabel.frame.origin.x+36, lblTime.frame.origin.y, lblTime.frame.size.width, lblTime.frame.size.height);
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{

   
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    mWebViewFlexibleHeight=[[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    
}
- (void) loadWebView {
    NSString *offerString=offer.lead_text;
    if([self.offer.offer_type isEqualToString:@"special"]) {
        offerString=[NSString stringWithFormat:@"★ %@",offer.lead_text];
    }
    NSString *weViewData =[NSString stringWithFormat:@"<HTML><body style=\"background-color:transparent\"><table><tr><td><font color=#8B5A00><b>%@</b><hr size=0.5 noshade color=#996633></font></td></tr><tr><td>%@</td></tr><tr><td>%@</td></tr></table></HTML>",offerString,offer.copy_text,offer.free_text];
    
    [self.webFreeText loadHTMLString:weViewData baseURL:nil];
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
    [self loadWebView];
    return YES;
}
-(IBAction)btnOfferDetailsOpenClose:(id)sender
{
    UIButton *btn = sender;
    if(btn.tag ==0)
    {
        NSLog(@"WebviewHeifgt%lf",self.webFreeText.frame.size.height);
        CGRect rec = self.viewOfferDetails.frame;
        rec.size.height = mWebViewFlexibleHeight+45;
        scroll.contentSize = CGSizeMake(320, scroll.contentSize.height+mWebViewFlexibleHeight-45);
        self.viewOfferDetails.frame = rec;
        [self.scroll scrollRectToVisible:self.viewOfferDetails.frame animated:YES];
        CGRect rec1 =  self.bottomView.frame;
        rec1.origin.y = rec.origin.y + rec.size.height;
        self.bottomView.frame = rec1;
        btn.tag =1;
        [self.arrowImage setImage:[UIImage imageNamed:@"Arrowwhitedown.png"]];
    }else
    {
        CGRect rec = self.viewOfferDetails.frame;
        rec.size.height = 115;
        scroll.contentSize = CGSizeMake(320, 680);
        self.viewOfferDetails.frame = rec;
        [self.scroll scrollRectToVisible:self.viewOfferDetails.frame animated:YES];
        CGRect rec1 =  self.bottomView.frame;
        rec1.origin.y = rec.origin.y + rec.size.height;
        self.bottomView.frame = rec1;
        btn.tag=0;
        [self.arrowImage setImage:[UIImage imageNamed:@"Arrowwhite.png"]];
    }
}

-(UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size
{
    float width = size.width;
    float height = size.height;
    
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    float widthRatio = image.size.width / width;
    float heightRatio = image.size.height / height; 
    float divisor = widthRatio > heightRatio ? widthRatio : heightRatio;
    
    width = image.size.width / divisor; 
    height = image.size.height / divisor;
    
    rect.size.width  = width;
    rect.size.height = height;
    
    if(height < width)
        rect.origin.y = height / 3;
    
    [image drawInRect: rect];
    
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();   
    
    return smallImage;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return  4;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==2) 
        return 60.0;
    else if (indexPath.row==1)
       return 36.0;
    else
        return 45.0;
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
        lblAddress.frame = CGRectMake(0,0,150, 50);
        lblAddress.textAlignment = UITextAlignmentLeft;
        lblAddress.font = [UIFont boldSystemFontOfSize:13.0];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = [UIColor blackColor];
        lblAddress.text = @"所在地";
        [cell addSubview:lblAddress];
        UILabel *lblAddressdetails = [[UILabel alloc]init];
        lblAddressdetails.frame = CGRectMake(80,0,250, 50);
        lblAddressdetails.textAlignment = UITextAlignmentLeft;
        lblAddressdetails.lineBreakMode = UILineBreakModeWordWrap;
        lblAddressdetails.numberOfLines = 3;
        
        lblAddressdetails.font = [UIFont systemFontOfSize:14];
        lblAddressdetails.backgroundColor = [UIColor clearColor];
        lblAddressdetails.textColor = [UIColor blackColor];
        lblAddressdetails.text = merchant.address;
        [cell addSubview:lblAddressdetails];
        
        
      //  NSLog(@"Shop Address = %@", merchant.address);
    }
    if (indexPath.row==1) {
        UILabel *lblphone = [[UILabel alloc]init];
        lblphone.frame = CGRectMake(0,-6,150, 50);
        lblphone.textAlignment = UITextAlignmentLeft;
        lblphone.font = [UIFont boldSystemFontOfSize:13.0];
        lblphone.backgroundColor = [UIColor clearColor];
        lblphone.textColor = [UIColor blackColor];
        lblphone.text = @"電話番号";
        
        [cell addSubview:lblphone];
        
        UILabel *lblphonedetails = [[UILabel alloc]init];
        lblphonedetails.frame = CGRectMake(80,-6,250, 50);
        lblphonedetails.textAlignment = UITextAlignmentLeft;
        lblphonedetails.lineBreakMode = UILineBreakModeWordWrap;
        lblphonedetails.numberOfLines = 3;
        
        lblphonedetails.font = [UIFont systemFontOfSize:14];
        lblphonedetails.backgroundColor = [UIColor clearColor];
        lblphonedetails.textColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
        lblphonedetails.text = merchant.phone;
        [cell addSubview:lblphonedetails];
        UIButton * btnPhoneNumber= [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPhoneNumber addTarget:self action:@selector(clickPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
        btnPhoneNumber.frame=CGRectMake(80,-6,250, 50);
        [cell addSubview:btnPhoneNumber];
        
        
    }
    if (indexPath.row==2) {

        UILabel *lbltime = [[UILabel alloc]init];
        lbltime.frame = CGRectMake(0,-8,150, 50);
        lbltime.textAlignment = UITextAlignmentLeft;
        lbltime.font = [UIFont boldSystemFontOfSize:13.0];
        lbltime.backgroundColor = [UIColor clearColor];
        lbltime.textColor = [UIColor blackColor];
        lbltime.text = @"営業時間";
        [cell addSubview:lbltime];
        
        UILabel *lbltimedetails = [[UILabel alloc]init];
        lbltimedetails.frame = CGRectMake(80,-8,250, 50);
        lbltimedetails.textAlignment = UITextAlignmentLeft;
        lbltimedetails.lineBreakMode = UILineBreakModeWordWrap;
        lbltimedetails.numberOfLines = 3;
        
        lbltimedetails.font = [UIFont systemFontOfSize:14];
        lbltimedetails.backgroundColor = [UIColor clearColor];
        lbltimedetails.textColor = [UIColor blackColor];
        lbltimedetails.text = merchant.time;
         lbltimedetails.text = @"No information available"; 
        [cell addSubview:lbltimedetails];
        
        
                
        
    }
    if (indexPath.row==3) 
    {
        
        UILabel *lblholiday = [[UILabel alloc]init];
        lblholiday.frame = CGRectMake(0,0,150, 50);
        lblholiday.textAlignment = UITextAlignmentLeft;
        
        
        lblholiday.font = [UIFont boldSystemFontOfSize:13.0];
        
        lblholiday.backgroundColor = [UIColor clearColor];
        lblholiday.textColor = [UIColor blackColor];
        lblholiday.text = @"定休日";
        
        [cell addSubview:lblholiday];
        
        UILabel *lblholidaydetails = [[UILabel alloc]init];
        lblholidaydetails.frame = CGRectMake(80,0,250, 50);
        lblholidaydetails.textAlignment = UITextAlignmentLeft;
        lblholidaydetails.lineBreakMode = UILineBreakModeWordWrap;
        lblholidaydetails.numberOfLines = 3;
        
        lblholidaydetails.font = [UIFont systemFontOfSize:14];
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
    /*CLLocationDistance meters = [self.currentLocation distanceFromLocation:self.storeLocation];
    //4000 mtr = 15 min
    //NSLog(@"meters %d",meters);
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    self.lblDistanceLabel.text =[NSString stringWithFormat:@" %.fm (徒歩%d分)",meters,time];*/
    [self calculateDistanceAndTime];
    [self animateArrowImage];
}

-(void) animateArrowImage {
    
    double radians=((([self bearingToLocation:storeLocation])- mHeading)*M_PI)/360;
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation.duration = 0.5f;    
    [self.compassImageView.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    self.compassImageView.transform = CGAffineTransformMakeRotation(radians);
    [self.view setNeedsDisplay];
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
        previousDirection = currenDirection;
        [self animateArrowImage];
    }
    
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
    MapWithRoutesViewController *directionVC=[[MapWithRoutesViewController alloc] initWithNibName:@"MapWithRoutesViewController" bundle:nil];
    AppDelegate  *appDeligate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    ShopList *merchant = [appDeligate getStoreDataById:self.offer.store_id];
    directionVC.destination=self.storeLocation;
    directionVC.destinationAddress=merchant.address;
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
    [self.shareVC  launchFacebookWithStr:[self shareKitMessage] WithImage:nil withParentVC:self
     ];
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
        NSString *strMessage=[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%lf,%lf&zoom=12&size=400x400&maptype=roadmap&sensor=true", self.storeLocation.coordinate.latitude,self.storeLocation.coordinate.longitude];
    return strMessage;
}

- (void)clickPhoneNumber:(id) sender {
    AppDelegate  *appDeligate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    ShopList *merchant = [appDeligate getStoreDataById:offer.store_id];
    NSString *phoneNumber = [@"tel://" stringByAppendingString:merchant.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
-(void)willRotateToInterfaceOrientation: (UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
    
        // Change the mapview frmae
    if (orientation==UIInterfaceOrientationLandscapeLeft||orientation==UIInterfaceOrientationLandscapeRight) {
        lblIsChild.frame=CGRectMake(imgIsChild.frame.origin.x+28, lblIsChild.frame.origin.y  , lblIsChild.frame.size.width,  lblIsChild.frame.size.height);
        
        lblIsLunch.frame=CGRectMake(imgIsLunch.frame.origin.x+27, lblIsLunch.frame.origin.y  , lblIsLunch.frame.size.width,  lblIsLunch.frame.size.height);
        lblIsPrivate.frame=CGRectMake(imgIsPrivate.frame.origin.x+42, lblIsPrivate.frame.origin.y  , lblIsPrivate.frame.size.width,  lblIsPrivate.frame.size.height);
    
    }
    else {
        
        lblIsChild.frame=CGRectMake(imgIsChild.frame.origin.x+53, lblIsChild.frame.origin.y  , lblIsChild.frame.size.width,  lblIsChild.frame.size.height);
        
        lblIsLunch.frame=CGRectMake(imgIsLunch.frame.origin.x+45, lblIsLunch.frame.origin.y  , lblIsLunch.frame.size.width,  lblIsLunch.frame.size.height);
        lblIsPrivate.frame=CGRectMake(imgIsPrivate.frame.origin.x+71, lblIsPrivate.frame.origin.y  , lblIsPrivate.frame.size.width,  lblIsPrivate.frame.size.height);
        
        }
        
    }

       
    
@end
