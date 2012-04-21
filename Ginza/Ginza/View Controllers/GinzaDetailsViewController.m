//
//  GinzaDetailsViewController.m
//  Ginza
//
//  Created by Arul Karthik on 09/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GinzaDetailsViewController.h"
#import "AppDelegate.h"
@interface GinzaDetailsViewController ()

@end

@implementation GinzaDetailsViewController
@synthesize scrollView;

@synthesize tblView;

@synthesize lblOfferTitle;
@synthesize lblOfferSubTitle;
@synthesize lblDistance;

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
    double Latitude = 35.6667;
    double Longitude = 139.767;
    
    
    
    CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    
    
    CLLocationDistance meters = [newLocation distanceFromLocation:storeLocation];
    //4000 mtr = 15 min
    //NSLog(@"meters %d",meters);
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    UIColor *mycolor= [UIColor colorWithRed:119/255.0 green:78/255.0 blue:0/255.0 alpha:5.0];
     self.lblDistance.textColor = mycolor;

    self.lblDistance.text =[NSString stringWithFormat:@" %.fm (徒歩%d分)",meters,time];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view from its nib.
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(299, 1000);
    
    
    
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    Offer *offer =  [appDeligate getOfferDataById:self.offerId];
    
  //  lblDistance.text = offer.offer_title;
   // lblOfferTitle.text=offer.offer_title;
  //  lblOfferSubTitle.text=offer.category;

    
    lblTitle = [[UILabel alloc]init];
    
    UIColor *lblColor= [UIColor colorWithRed:119/255.0 green:78/255.0 blue:0/255.0 alpha:5.0];
    lblOfferTitle.textColor = lblColor;
    lblTitle.text = @"買い物やお食事の合い間に、";
    lblTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblTitle];
    

    


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
#pragma _tableView






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
            cellTitle.frame = CGRectMake(5,20, 60, 25);
            cellTitle.text = @"所在地";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];
            [cell addSubview:cellTitle];
            
            
            UILabel *cellTitle1 = [[UILabel alloc]init ];
            cellTitle1.frame = CGRectMake(100,20, 200,25);
            cellTitle1.text = @"東京都中央区銀座5-5-4 アルマーニ/銀座タワー 5階";
            cellTitle1.font = [UIFont systemFontOfSize:12];

            cellTitle1.lineBreakMode = UILineBreakModeWordWrap;
            cellTitle1.numberOfLines = 1;
            cellTitle1.textColor = [UIColor blackColor];
            cellTitle1.backgroundColor = [UIColor clearColor];
            [cell addSubview:cellTitle1];
            
            
            
            
            
            
                    
            
                        
            }
        if (indexPath.row==1) {
      //  cell.textLabel.text = merchant.phone;
            
            
            UILabel *cellTitle = [[UILabel alloc]init ];
            cellTitle.frame = CGRectMake(5,20, 100, 25);
            cellTitle.text = @"電話番号";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];

            [cell addSubview:cellTitle];
            
            UILabel *cellValue = [[UILabel alloc]init ];
            cellValue.text = @"0120-953-816";
            cellValue.frame = CGRectMake(100, 20, 200, 25);
            cellValue.backgroundColor = [UIColor clearColor];

            cellValue.font = [UIFont systemFontOfSize:12];
            [cell addSubview:cellValue];
               
            }
        if (indexPath.row==2) {
                
            UILabel *cellTitle = [[UILabel alloc]init ];
            cellTitle.frame = CGRectMake(5,20, 100, 25);
            cellTitle.text = @"営業時間";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];

            [cell addSubview:cellTitle];
            
            UILabel *cellValue = [[UILabel alloc]init ];
            cellValue.text = @"10:00~20:00階";
            cellValue.frame = CGRectMake(100, 20, 200, 25);
            cellValue.backgroundColor = [UIColor clearColor];

            cellValue.font = [UIFont systemFontOfSize:12];
            [cell addSubview:cellValue];
            
                       }
        if (indexPath.row==3) {
            
            UILabel *cellTitle = [[UILabel alloc]init ];
            cellTitle.frame = CGRectMake(0,20, 100, 25);
            cellTitle.text = @"定休日";
            cellTitle.textColor = [UIColor grayColor];
            cellTitle.backgroundColor = [UIColor clearColor];

            [cell addSubview:cellTitle];
            
            UILabel *cellValue = [[UILabel alloc]init ];
            cellValue.text = @"1月1日のみ";
            cellValue.frame = CGRectMake(100, 20, 200, 25);
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




@end
