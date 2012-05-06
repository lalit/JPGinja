//
//  CustomCallOutView.m
//  Ginza
//
//  Created by administrator on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomCallOutView.h"
#import "AppDelegate.h"
#import "Offer.h"
#import "ShopList.h"
#import "Categories.h"
#import "OfferDetailsViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "pARkViewController.h"
#import "Location.h"
@implementation CustomCallOutView
@synthesize locationManager,currentLocation,offerDataArray,offerTitleLabel;
@synthesize popupThumb,distanceLabel,timeLabel,btnBookmark,popupbg,currentOffer;
@synthesize desLabel,popupButton,parentViewController,distanceLabel1,distanceLabel2,distanceLabel3,distanceLabel4,btnNext,btnPrevious;
@synthesize txtcp;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    
    //locationManager = [[CLLocationManager alloc] init];
    //locationManager.delegate = self;
    //locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;; // 100 m
    //[locationManager startUpdatingLocation];
    currentPos=0;
    return self;

}

-(UIView *)prepareCallOutView:(Offer *)offer offerArray:(NSMutableArray *)offerdataArray
{
    
    offerDataArray= offerdataArray;
    currentOffer =offer;
    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    ShopList *merchant = [deligate getStoreDataById:offer.store_id];
    Categories *categoryData = (Categories *)[deligate getCategoryDataById:merchant.sub_category];

    UIView *popup = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 172 , 163)];
    [popup setContentMode:UIViewContentModeScaleToFill];
    if ([offer.offer_type isEqualToString:@"special"]) {
         popupbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"spbg.png"]];
    }else
    {
    popupbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"annodation.png"]];
    }
    popupbg.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    popup.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[popup setBackgroundColor:[UIColor redColor]];
    [popup addSubview:popupbg];
   // NSLog(@"image =%@",categoryData.image_name);
    popupThumb = [[UIImageView alloc]initWithFrame:CGRectMake(8, 65, 80, 60)];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"/"];
    path = [path stringByAppendingString:[NSString stringWithFormat:@"80x60_%@",categoryData.image_name]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    
    [popupThumb setImage:image];
    
     popupThumb.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [popup addSubview:popupThumb];
    
    offerTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 5, 135, 21)];
    offerTitleLabel.lineBreakMode=UILineBreakModeWordWrap;
    offerTitleLabel.numberOfLines=1;
    offerTitleLabel.font=[UIFont systemFontOfSize:12.0];
    offerTitleLabel.backgroundColor =[UIColor clearColor];
    offerTitleLabel.text = categoryData.category_name;
    offerTitleLabel.textColor =[UIColor grayColor];
    
    offerTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    //offerTitleLabel.adjustsFontSizeToFitWidth = YES;
    //[offerTitleLabel sizeToFit];
    [popup addSubview:offerTitleLabel];
    
    desLabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 25, 135, 21)];
    desLabel.backgroundColor =[UIColor clearColor];
    desLabel.text = merchant.store_name;
    desLabel.lineBreakMode=UILineBreakModeWordWrap;
    desLabel.numberOfLines=1;
    desLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleRightMargin ;
    //desLabel.adjustsFontSizeToFitWidth = YES;
    [popup addSubview:desLabel];
    txtcp = [[UILabel alloc]initWithFrame:CGRectMake(8, 45, 100, 21)];
    desLabel.lineBreakMode=UILineBreakModeWordWrap;
    desLabel.numberOfLines=1;
    txtcp.backgroundColor =[UIColor clearColor];
    //txtcp.text = @"Hello";
    txtcp.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
   // txtcp.adjustsFontSizeToFitWidth = YES;
    [popup addSubview:txtcp];
    double Latitude = [merchant.latitude doubleValue];
    double Longitude = [merchant.longitude doubleValue];
    
    CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    
    
    CLLocationDistance meters = [currentLocation distanceFromLocation:storeLocation];
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    [popup sizeToFit];
     UIColor *mycolor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
    //trmp
    
    /*distanceLabel1 =[[UILabel alloc]initWithFrame:CGRectMake(100, 60, 84, 21)];
    distanceLabel1.backgroundColor =[UIColor clearColor];
    UIColor *mycolor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
    distanceLabel1.textColor = mycolor;
    distanceLabel1.font  =[UIFont systemFontOfSize:10.0];
    distanceLabel1.text = [NSString stringWithFormat:@" %@",merchant.latitude];
    [popup addSubview:distanceLabel1];

    distanceLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(100, 50, 84, 21)];
    distanceLabel2.backgroundColor =[UIColor clearColor];
    mycolor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
    distanceLabel2.textColor = mycolor;
    distanceLabel2.font  =[UIFont systemFontOfSize:10.0];
    distanceLabel2.text = [NSString stringWithFormat:@" %@",merchant.longitude];
    [popup addSubview:distanceLabel2];
    
    
    distanceLabel3 =[[UILabel alloc]initWithFrame:CGRectMake(100, 70, 84, 21)];
    distanceLabel3.backgroundColor =[UIColor clearColor];
    mycolor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
    distanceLabel3.textColor = mycolor;
    distanceLabel3.font  =[UIFont systemFontOfSize:10.0];
    distanceLabel3.text = [NSString stringWithFormat:@" %f",currentLocation.coordinate.latitude];
    [popup addSubview:distanceLabel3];
    
    distanceLabel4 =[[UILabel alloc]initWithFrame:CGRectMake(100, 80, 84, 21)];
    distanceLabel4.backgroundColor =[UIColor clearColor];
    mycolor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
    distanceLabel4.textColor = mycolor;
    distanceLabel4.font  =[UIFont systemFontOfSize:10.0];
    distanceLabel4.text = [NSString stringWithFormat:@" %f",currentLocation.coordinate.longitude];
    [popup addSubview:distanceLabel4];

    
*/
    
    distanceLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 52, 64, 70)];
    distanceLabel.backgroundColor =[UIColor clearColor];
    mycolor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];
    distanceLabel.textColor = mycolor;
    distanceLabel.font  =[UIFont systemFontOfSize:11.0];
    distanceLabel.lineBreakMode=UILineBreakModeWordWrap;
    distanceLabel.numberOfLines=3;
    //distanceLabel.text = [NSString stringWithFormat:@" %.fm",meters];
    distanceLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleTopMargin| UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    distanceLabel.textAlignment = UITextAlignmentLeft;
    //[distanceLabel sizeToFit];
    [popup addSubview:distanceLabel];
    
    timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, 84, 70, 50)];
    timeLabel.backgroundColor =[UIColor clearColor];
    //timeLabel.text = [NSString stringWithFormat:@"(徒歩%d分)",time];;
    timeLabel.font  =[UIFont systemFontOfSize:11.0];
    //[timeLabel sizeToFit];
    timeLabel.lineBreakMode=UILineBreakModeWordWrap;
    timeLabel.numberOfLines=2;
     timeLabel.textAlignment = UITextAlignmentLeft;
   /* timeLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;*/
    timeLabel.textColor = mycolor;
    [popup addSubview:timeLabel];
    
    double dkm=me/1000;
    if (dkm>MIN_DISTANCE) {
        distanceLabel.text=@"この場所までの距離が分かりま せんでした";
    }
    else {
        NSString *formattedTime=[self calculateTime:time];
        NSString *distance=[self calculateDistance:me];
        distanceLabel.text=distance;
        timeLabel.text =formattedTime;
    }

/*   btnBookmark =[[UIButton alloc]initWithFrame:CGRectMake(140, 1, 24, 36)];
    if ([offer.isbookmark isEqualToString:@"1"]) 
        
    {
        [btnBookmark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
    }else
    {
        [btnBookmark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
        
    }
    
    [btnBookmark addTarget:self action:@selector(btnBookMark:) forControlEvents:UIControlEventTouchUpInside];
    btnBookmark.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [popup addSubview:btnBookmark];
*/
    
    popupButton = [[UIButton alloc]initWithFrame:CGRectMake(0,30,200,200)];
    [popupButton addTarget:self action:@selector(btnShowDetails:) forControlEvents:UIControlEventTouchUpInside];
    [popup addSubview:popupButton];

    
    if ([offerdataArray count]>1) {
        self.btnNext =[[UIButton alloc]initWithFrame:CGRectMake(popup.frame.size.width-19-10, popup.frame.size.height/2 -32, 38, 38)];
        [self.btnNext setImage:[UIImage imageNamed:@"nextbtn.png"] forState:UIControlStateNormal];          
        [self.btnNext addTarget:self action:@selector(btnNext:) forControlEvents:UIControlEventTouchUpInside];
        self.btnNext.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        [popup addSubview:self.btnNext];
        self.btnPrevious =[[UIButton alloc]initWithFrame:CGRectMake(-19, popup.frame.size.height/2-32, 38, 38)];
        [self.btnPrevious setImage:[UIImage imageNamed:@"previousBtn.png"] forState:UIControlStateNormal];          
        [self.btnPrevious addTarget:self action:@selector(btnPrevious:) forControlEvents:UIControlEventTouchUpInside];
        self.btnPrevious.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin |  UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
        [popup addSubview:self.btnPrevious];
        self.btnPrevious.hidden=YES;
    }
    self.frame= popup.frame;
    popup.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:popup];
    
    return popup;
}


-(IBAction)btnShowDetails:(id)sender
{
    
    
    OfferDetailsViewController *detail =[[OfferDetailsViewController alloc]init];
   Offer *offer = [offerDataArray objectAtIndex:currentPos];
    
    detail.offerId = offer.id;
    NSLog(@"self.parentViewController  = %@",self.parentViewController );
    if (self.parentViewController ==nil || [self.parentViewController isKindOfClass:[self.parentViewController class]]) {
        AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
        //NSLog(@"parent = %@", deligate.arviewController);
        [deligate.arviewController  presentModalViewController:detail animated:YES];

    }else
    {
    
    [self.parentViewController  presentModalViewController:detail animated:YES];
    
       [self removeFromSuperview];
    }
}
-(void)refreshView:(Offer *)offer
{
    currentOffer =offer;
    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    ShopList *merchant = [deligate getStoreDataById:offer.store_id];
    Categories *categoryData = (Categories *)[deligate getCategoryDataById:merchant.sub_category];
    
    if ([offer.offer_type isEqualToString:@"special"]) {
        [popupbg setImage:[UIImage imageNamed:@"spbg.png"]];
    }else
    {
        [popupbg setImage:[UIImage imageNamed:@"annodation.png"]];
    }

    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"/"];
    path = [path stringByAppendingString:[NSString stringWithFormat:@"80x60_%@",categoryData.image_name]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    [popupThumb setImage:image];
     txtcp.text = offer.copy_text;
    offerTitleLabel.text = categoryData.category_name;

    desLabel.text = merchant.store_name;
 
    
    double Latitude = [merchant.latitude doubleValue];
    double Longitude = [merchant.longitude doubleValue];
    
    CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
    
    currentLocation  = [[Location sharedInstance]currentLocation];
    CLLocationDistance meters = [currentLocation distanceFromLocation:storeLocation];
    double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
    int time = (me/4000)*15;
    double dkm=me/1000;
    if (dkm>MIN_DISTANCE) {
        distanceLabel.text=@"この場所までの距離が分かりま せんでした";
    }
    else {
        NSString *formattedTime=[self calculateTime:time];
        NSString *distance=[self calculateDistance:me];
        timeLabel.text =[NSString stringWithFormat:@"%@ %@",distance,formattedTime];
    }

    distanceLabel1.text = [NSString stringWithFormat:@" %@",merchant.latitude];
    distanceLabel2.text = [NSString stringWithFormat:@" %@",merchant.longitude];
    //distanceLabel.text = [NSString stringWithFormat:@" %.fm",meters];
    //timeLabel.text = [NSString stringWithFormat:@"(徒歩%d分)",time];;
    btnBookmark.tag = [offer.offer_id intValue];
    if ([offer.isbookmark isEqualToString:@"1"]) 
        
    {
        [btnBookmark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
    }else
    {
        [btnBookmark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
        
    }

    
}
-(IBAction)btnNext:(id)sender
{
    UIButton *btn = sender;
    //NSLog(@"Next %d,%@",currentPos,offerDataArray);
    currentPos = currentPos+1;
    if (currentPos<=[offerDataArray count]-1) {
        btn.hidden = NO;
        Offer *offer = [offerDataArray objectAtIndex:currentPos];
        currentOffer =offer;
        [self refreshView:offer];
    }else
    {
        currentPos = [offerDataArray count]-1;
        btn.hidden=YES;
        
    }
   
    if (currentPos==[offerDataArray count]-1) {
        btn.hidden=YES;
    }
    if (currentPos > 0) {
        self.btnPrevious.hidden = NO;
    }
   
}
-(IBAction)btnPrevious:(id)sender
{
    NSLog(@"Previous %d",currentPos);
    UIButton *btn = sender;
    currentPos = currentPos-1;
    if (currentPos<=[offerDataArray count]-1) {
        self.btnNext.hidden=NO;
    }
    if (currentPos >= 0) {
        btn.hidden = NO;
        Offer *offer = [offerDataArray objectAtIndex:currentPos];
        currentOffer = offer;
        [self refreshView:offer];
    }else
    {
        currentPos =0;
        btn.hidden= YES;
    }
    if (currentPos==0) {
        btn.hidden= YES;
    }
   
   
}
-(IBAction)btnBookMark:(id)sender
{

    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    Offer *offer = [offerDataArray objectAtIndex:currentPos];
    [appDeligate updateBookMarkCount:offer];
        
        
        if ([offer.isbookmark isEqualToString:@"0"]) {
            
            [self.btnBookmark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
        }
        else {
            [self.btnBookmark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
            
        }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading 
{
    
    NSLog(@"update heading popup");
       
    
    
}
//Calculate Distance and Time
- (NSString *)calculateDistance : (double) aDistance {
    NSString *strDist;
    double d=aDistance/1000;
    if (d>1.0) {
        strDist=[NSString stringWithFormat:@"%.fkm",d];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

/*-(NSMutableArray *)getPOIViews
{
    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *dataArray = [deligate getOfferData];
    
    NSMutableDictionary *mapDataDict = [[NSMutableDictionary alloc]init ];
    
    for (int index=0; index<[dataArray count]; index++) {
        Offer *offer =[dataArray objectAtIndex:index];
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        {
            if ([mapDataDict valueForKey:[NSString stringWithFormat:@"%@-%@", merchant.latitude,merchant.longitude]]==nil) {
                NSMutableArray *offerdataArray =[[NSMutableArray alloc]init ];
                [offerdataArray addObject:offer];
                [mapDataDict setValue:offerdataArray forKey:[NSString stringWithFormat:@"%@-%@", merchant.latitude,merchant.longitude]];
            }else
            {
                NSMutableArray *offerdataArray =[mapDataDict objectForKey:[NSString stringWithFormat:@"%@-%@", merchant.latitude,merchant.longitude]];
                [offerdataArray addObject:offer];
                [mapDataDict setValue:offerdataArray forKey:[NSString stringWithFormat:@"%@-%@", merchant.latitude,merchant.longitude]];
            }
        }
    }
    NSMutableArray *placesOfInterest = [NSMutableArray arrayWithCapacity:[mapDataDict count]];
    int i=0;
    for (id key in mapDataDict)
    {
        NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
        Offer *offer =[offerdataArray objectAtIndex:0];
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        Categories *categoryData = (Categories *)[deligate getCategoryDataById:merchant.sub_category];
        
        double latitude =[merchant.latitude doubleValue];
        double longitude = [merchant.longitude doubleValue];
        
        CustomMapPopup *customView =[[CustomMapPopup alloc]init];
        customView.offer = offer;
        [customView.btnNext addTarget:self action:@selector(btnNext) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *popup = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 169, 143)];
        UIImageView *popupbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"annodation.png"]];
        [popup addSubview:popupbg];
        
        UIImageView *popupThumb = [[UIImageView alloc]initWithFrame:CGRectMake(8, 50, 80, 60)];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:@"/"];
        path = [path stringByAppendingString:categoryData.image_name];
        
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
        [popupThumb setImage:img];
        
        
        [popup addSubview:popupThumb];
        
        UILabel *offerTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 11, 150, 21)];
        offerTitleLabel.backgroundColor =[UIColor clearColor];
        offerTitleLabel.text = offer.offer_title;
        [popup addSubview:offerTitleLabel];
        
        UILabel *copyTextLabel =[[UILabel alloc]initWithFrame:CGRectMake(8, 30, 150, 21)];
        copyTextLabel.backgroundColor =[UIColor clearColor];
        copyTextLabel.text = offer.lead_text;
        [popup addSubview:copyTextLabel];
        
        double Latitude = [merchant.latitude doubleValue];
        double Longitude = [merchant.longitude doubleValue];
        
        CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:Latitude longitude:Longitude];
        
        
        CLLocationDistance meters = [currentLocation distanceFromLocation:storeLocation];
        double me =[[NSString stringWithFormat:@"%.f",meters] doubleValue];
        int time = (me/4000)*15;
        
        
        
        
        UILabel *distanceLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 80, 84, 21)];
        distanceLabel.backgroundColor =[UIColor clearColor];
        distanceLabel.text = [NSString stringWithFormat:@" %.fm",meters];
        [popup addSubview:distanceLabel];
        
        UILabel *timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(100, 98, 84, 21)];
        timeLabel.backgroundColor =[UIColor clearColor];
        timeLabel.text = [NSString stringWithFormat:@"(徒歩%d分)",time];;
        [popup addSubview:timeLabel];
        
        UIButton *btnBookmark =[[UIButton alloc]initWithFrame:CGRectMake(130, 0, 24, 36)];
        if ([offer.isbookmark isEqualToString:@"1"]) 
            
        {
            [btnBookmark setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
        }else
        {
            [btnBookmark setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
            
        }
        
        [btnBookmark addTarget:self action:@selector(btnNext:) forControlEvents:UIControlEventTouchUpInside];
        [popup addSubview:btnBookmark];
        
        
        
        
        UIButton *btnNext =[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [btnNext setTitle:@"tesr" forState:UIControlStateNormal];
        [btnNext addTarget:self action:@selector(btnNext:) forControlEvents:UIControlEventTouchUpInside];
        [popup addSubview:btnNext];
        
        if ([offerdataArray count]>1) {
            UIButton *btnNext =[[UIButton alloc]initWithFrame:CGRectMake(0, popup.frame.size.height/2-32, 24, 24)];
            [btnNext setImage:[UIImage imageNamed:@"nextbtn.png"] forState:UIControlStateNormal];          
            [btnNext addTarget:self action:@selector(btnNext:) forControlEvents:UIControlEventTouchUpInside];
            [popup addSubview:btnNext];
            UIButton *btnPrevious =[[UIButton alloc]initWithFrame:CGRectMake(popup.frame.size.width-24, popup.frame.size.height/2 -32, 24, 24)];
            [btnPrevious setImage:[UIImage imageNamed:@"previousBtn.png"] forState:UIControlStateNormal];          
            [btnPrevious addTarget:self action:@selector(btnNext:) forControlEvents:UIControlEventTouchUpInside];
            [popup addSubview:btnPrevious];
        }
        PlaceOfInterest *poi1 = [PlaceOfInterest placeOfInterestWithView:popup at:[[CLLocation alloc] initWithLatitude:poiCoords[i].latitude longitude:poiCoords[i].longitude] offerdata:offer];
        // PlaceOfInterest *poi1 =[PlaceOfInterest placeOfInterestWithView:popup at:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] offerdata:offer];
		[placesOfInterest insertObject:poi1 atIndex:i++];
        NSLog(@"No of poi's %d",i);
        
        
    }
    return placesOfInterest;
}*/
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
