//
//  GinzaDetailsViewController.m
//  Ginza
//
//  Created by Arul Karthik on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GinzaDetailsViewController.h"
#import "AppDelegate.h"
#import "MapWithRoutesViewController.h"
#import "ShareViewController.h"
#import "Location.h"
@interface GinzaDetailsViewController ()

@end

@implementation GinzaDetailsViewController
@synthesize scrollView;
@synthesize  currentLocation;
@synthesize storeLocation;
@synthesize tblView;
@synthesize lblOfferTitle;
@synthesize lblOfferSubTitle;
@synthesize lblDistance;
@synthesize shareVC;
@synthesize offerId;

@synthesize webView;
@synthesize lblTitle;
@synthesize lblsubTitle,locationManager;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{

    self.currentLocation=newLocation;
    [self calculateDistanceAndTime];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    double Latitude = 35.67163555;
    double Longitude =139.763953;
    self.storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    // Do any additional setup after loading the view from its nib.
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(299, 1000);
    lblTitle = [[UILabel alloc]init];
    UIColor *lblColor= [UIColor colorWithRed:119/255.0 green:78/255.0 blue:0/255.0 alpha:5.0];
    lblOfferTitle.textColor = lblColor;
    lblTitle.text = @"買い物やお食事の合い間に、";
    lblTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblTitle];
}

- (void) calculateDistanceAndTime {
     UIColor *mycolor= [UIColor colorWithRed:119/255.0 green:78/255.0 blue:0/255.0 alpha:5.0];
    self.lblDistance.textColor = mycolor;
    double Latitude = self.storeLocation.coordinate.latitude;
    double Longitude = self.storeLocation.coordinate.longitude;
    self.storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    CLLocationDistance meters = [self.currentLocation distanceFromLocation:self.storeLocation];
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    double distanceInKm=meters/1000;
    lblDistance.text=@"";
    NSString *result=@"";
    if (distanceInKm>MIN_DISTANCE) {
        lblDistance.text=@"この場所までの距離が分かりま せんでした";
    }
    else {
        
        NSString *strTime=@"";
        
        if (distanceInKm>1.0) {
            result=[NSString stringWithFormat:@"%.fkm",distanceInKm];
        }
        else {
            result=[NSString stringWithFormat:@"%.fm",meters];
        }
        
        if (time>60) {
            int hours=time/60;
            int minutes=time%60;
            strTime=[NSString stringWithFormat:@"(徒歩%d時間%d分)",hours,minutes];
            result=[result stringByAppendingString:strTime];
        }
        else {
            strTime=[NSString stringWithFormat:@"(徒歩%d分)",time];
            result=[result stringByAppendingString:strTime];
        }
        lblDistance.text=result;
        
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    UIColor *lblColor= [UIColor colorWithRed:119/255.0 green:78/255.0 blue:0/255.0 alpha:5.0];
    lblTitle.textColor = lblColor;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma _
#pragma _tableVie




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{


return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{


return  4;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) 
        return 55.0;
    else
        return 35.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

  //  AppDelegate  *appDeligate =(AppDelegate *) [[UIApplication sharedApplication]delegate];

  //  Offer *offer =  [appDeligate getOfferDataById:self.offerId];

  //  ShopList *merchant = [appDeligate getStoreDataById:offer.store_id];
   // NSLog(@"Offer id = %@,%@",self.offerId,offer.store_id);
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        if (indexPath.row==0) 
        {
        //    cell.textLabel.text = merchant.address;
         //   NSLog(@"Shop Address = %@", merchant.address);
            
            
            UILabel *cellTitle = [[UILabel alloc]init ];
            cellTitle.frame = CGRectMake(5,-5, 60, 50);
            cellTitle.text = @"所在地";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];
            [cell addSubview:cellTitle];
            
            UILabel *cellTitle1 = [[UILabel alloc]init ];
            cellTitle1.frame = CGRectMake(100,0, 200,50);
            cellTitle1.lineBreakMode=UILineBreakModeWordWrap;
            cellTitle1.numberOfLines=2;
            cellTitle1.text = @"東京都中央区銀座5-5-4 アルマーニ/銀座タワー 5階";
            cellTitle1.font = [UIFont systemFontOfSize:12];

            cellTitle1.textColor = [UIColor blackColor];
            cellTitle1.backgroundColor = [UIColor clearColor];
            [cell addSubview:cellTitle1];
            }
        if (indexPath.row==1) {
      //  cell.textLabel.text = merchant.phone;
            
            
            UILabel *cellTitle = [[UILabel alloc]init ];
            cellTitle.frame = CGRectMake(5,0, 100, 25);
            cellTitle.text = @"電話番号";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];

            [cell addSubview:cellTitle];
            
            UILabel *cellValue = [[UILabel alloc]init ];
            UIColor *lblColor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
            cellValue.textColor = lblColor;
            cellValue.text = @"0120-953-816";
            cellValue.frame = CGRectMake(100, 0, 200, 25);
            cellValue.backgroundColor = [UIColor clearColor];

            cellValue.font = [UIFont systemFontOfSize:12];
            [cell addSubview:cellValue];
            UIButton * btnPhoneNumber= [UIButton buttonWithType:UIButtonTypeCustom];
            [btnPhoneNumber addTarget:self action:@selector(clickPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
            btnPhoneNumber.frame=CGRectMake(100, 0, 200, 40);
            [cell addSubview:btnPhoneNumber];
               
            }
        if (indexPath.row==2) {
                
            UILabel *cellTitle = [[UILabel alloc]init ];
            cellTitle.frame = CGRectMake(5,0, 100, 25);
            cellTitle.text = @"営業時間";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];

            [cell addSubview:cellTitle];
            
            UILabel *cellValue = [[UILabel alloc]init ];
            cellValue.text = @"10:00~20:00階";
            cellValue.frame = CGRectMake(100, 0, 200, 25);
            cellValue.backgroundColor = [UIColor clearColor];

            cellValue.font = [UIFont systemFontOfSize:12];
            [cell addSubview:cellValue];
            
                       }
        if (indexPath.row==3) {
            
            UILabel *cellTitle = [[UILabel alloc]init ];
            cellTitle.frame = CGRectMake(0,0, 100, 25);
            cellTitle.text = @"定休日";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];

            [cell addSubview:cellTitle];
            
            UILabel *cellValue = [[UILabel alloc]init ];
            cellValue.text = @"1月1日のみ";
            cellValue.frame = CGRectMake(100, 0, 200, 25);
            cellValue.backgroundColor = [UIColor clearColor];

            cellValue.font = [UIFont systemFontOfSize:12];
            [cell addSubview:cellValue];
        }
            // Configure the cell...

    return cell;


}


-(IBAction)btnClose:(id)sender
{
    [locationManager stopUpdatingLocation];

    [self dismissModalViewControllerAnimated:YES];

}

//=======================================================================================================================
//Added by Mobiquest team

- (IBAction)getDirectionButtonPressed:(id)sender {
    MapWithRoutesViewController *directionVC=[[MapWithRoutesViewController alloc] initWithNibName:@"MapWithRoutesViewController" bundle:nil];
    directionVC.destination=self.storeLocation;
    directionVC.destinationAddress=@"東京都中央区銀座5-5-4 アルマーニ/銀座タワー 5階";
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
    NSString *phoneNumber = [@"tel://" stringByAppendingString:@"0120-953-816"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}
@end
