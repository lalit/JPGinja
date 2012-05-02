/*
 File: pARkViewController.m
 Abstract: Simple view controller for the pARk example. Provides a hard-coded list of places-of-interest to its associated ARView when loaded, starts the ARView when it appears, and stops it when it disappears.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2011 Apple Inc. All Rights Reserved.
 
 */

#import "pARkViewController.h"
#import "PlaceOfInterest.h"
#import "ARView.h"
#import "RadarViewPortView.h"
#import "Offer.h"
#import "GinzaSubViewController.h"
#import "GinzaFilterViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "Categories.h"
#import "CustomCallOutView.h"
#import "Location.h"
#import "CustomTopNavigationBar.h"

@implementation pARkViewController

//#define SYNTHESIZE_SINGLETON_FOR_CLASS(pARkViewController);


#define DEGREES_TO_RADIANS (M_PI/180.0)
#define degreesToRadianX(x) (M_PI * (x) / 180.0)

@synthesize rotateImg,compassImg,trueNorth;
@synthesize compassDif,compassFault,calibrateBtn,lblFilterText,slider,settingView,btnClose,lblDistance,btnSettings,orientation,lblEventCount,placesOfInterest,btnVMMode,btnBack,btnHelp,helpView,btnForward,btnReverse,virtualwalkArrow,waitingMessage,arView,lblMessage,cbar,actionsView;
@synthesize lblRadius,viewSetting,sdrRadius,settingRadar,settingRadarViewPort,viewScale,isFirstTime,actionViewLandScape;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AR", @"AR");
        self.tabBarItem.image = [UIImage imageNamed:@"CameraIcon.png"];
        self.navigationController.navigationBar.hidden = YES; 

        arView = (ARView *)self.view;
        arView.parentActionView = self.actionsView;
        arView.parentViewController= self;
        //btnSettings = [UIButton buttonWithType:UIButtonTypeRoundedRect];        
        //[btnSettings addTarget:self action:@selector(btnARViewClicked:) forControlEvents:UIControlEventTouchUpInside];
        //btnSettings.frame = CGRectMake(80.0, 210.0, 100.0,100.0);
        [btnSettings.layer setZPosition:205.0f];
        //[self.view addSubview:btnSettings];
        //[arView bringSubviewToFront:btnSettings];
        [arView start];
        NSLog(@"init");
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"AR update location");
   // currentLocation = newLocation;
    Location *loc = [[Location sharedInstance]init];
    
   // loc.currentLocation=currentLocation;
    //if (radiusChanged == 1) {
    //
    radiusChanged=0;
    //}
    
    //
    
    if (isFirstTime) {
        [self updateView];
        self.isFirstTime=NO;
    }
    
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
    float x = acceleration.x;
    float y = acceleration.y;
    float z = acceleration.z;
    //NSLog(@"%f,%f,%f",x,y,z);
    if (self.tabBarController.selectedIndex==0) {
        if (z>=-0.9) {
            //self.tabBarController.selectedIndex =0;
        }else
        {
            //self.tabBarController.selectedIndex =1;
        }
    }
    
}




-(IBAction)sliderChanged:(id)sender
{
    NSLog(@"slider changed %d",(int)slider.value);
    if ((int)self.sdrRadius.value==4) {
        arView.radius=0;
    }
    if ((int)self.sdrRadius.value==3) {
        arView.radius=50;
    }
    if ((int)self.sdrRadius.value==2) {
        arView.radius=200;
    }
    if ((int)self.sdrRadius.value==1) {
        arView.radius=500;
    }
    if ((int)self.sdrRadius.value==0) {
        arView.radius=1000;
    }
    NSLog(@"radius = %f",arView.radius);
    radius = arView.radius;
    self.lblDistance.text =[NSString stringWithFormat:@"%.f",arView.radius];
    self.lblRadius.text =[NSString stringWithFormat:@"%.f",arView.radius];
    [self.lblDistance sizeToFit];
    
    
    if ([self.placesOfInterest count]==0) {
        [self constructCalloutPOI];
    }
    int i=0;
    NSMutableArray *placesOfInterestTemp = [[NSMutableArray alloc]init ];
    for (PlaceOfInterest *poi in self.placesOfInterest) {
        //NSLog(@"UPdate view POI %@",[NSDate date]);
        CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        CLLocation *pointBLocation = poi.location;  
        
        float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        
        //NSLog(@"distanceMeters = %f,%f,%f",distanceMeters,currentDistance,radius);
        //radius=250;
        if (distanceMeters >= currentDistance /*&& distanceAndIndex->distance<=self.maxtDistance*/) {
            
            if (distanceMeters<radius) {
                NSLog(@"radius POI insert = %f",radius);
                [placesOfInterestTemp insertObject:poi atIndex:i++];
            }
            
        }
        
    }
    self.settingRadarViewPort.placesOfInterest = placesOfInterestTemp;
    [self.settingRadarViewPort setNeedsDisplay];
}



-(void)constructCalloutPOI
{
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSMutableDictionary *mapDataDict = deligate.poiDataDictionary;
    placesOfInterest = [[NSMutableArray alloc]init];
    NSLog(@"UPdate view loop start1 %@",[NSDate date]);
    int i=0;
    for (id key in mapDataDict)
    {
        NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
        Offer *offer =[offerdataArray objectAtIndex:0];
        NSLog(@"Callout construction %@",offer.offer_id);
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        double latitude =[merchant.latitude doubleValue];
        double longitude = [merchant.longitude doubleValue];
        
        //For testing
        //CLLocation *pointALocation = currentLocation;
        //CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        //CLLocation *pointBLocation = [[CLLocation alloc] initWithLatitude:[merchant.latitude doubleValue] longitude:[merchant.longitude doubleValue]];  
        
        // float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        //radius=250;
        //if (distanceMeters >= currentDistance /*&& distanceAndIndex->distance<=self.maxtDistance*/) {
        
        //if (distanceMeters<radius) {
        
        CustomCallOutView *popup =[[CustomCallOutView alloc]init];
        //popup.currentLocation = _currentAction;
        NSLog(@"PARENT = %@",deligate.arviewController);
        popup.parentViewController = deligate.arviewController;
        [popup prepareCallOutView:offer offerArray:offerdataArray];
        
        PlaceOfInterest *poi1 =[PlaceOfInterest placeOfInterestWithView:popup at:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] offerdata:offer];
        [self.placesOfInterest insertObject:poi1 atIndex:i++];
        //}
        
        //}
    }
    NSLog(@"UPdate view loop end %@",[NSDate date]);   
    
}


- (void)viewDidLoad
{
 self.navigationController.navigationBar.hidden = YES;   
    NSLog(@"View loading start");
    rotationAngle=0;
     UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
    tabbarRect = tabBar.frame;
    [super viewDidLoad];
    [self.actionsView.layer setZPosition:101.0f];
    //[[UIAccelerometer sharedAccelerometer] setDelegate: self ];
    //[[UIAccelerometer sharedAccelerometer] setUpdateInterval:2.0f];
    
    //self.waitingMessage = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please wait loading data" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //[self.waitingMessage  show];
    currentDistance = 150;
    zoomlevel=1;
   // [self updateView];
    self.sdrRadius.transform= CGAffineTransformRotate(self.slider.transform, 90 * M_PI /180);
    
	
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    
   
    
    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[deligate.ginzaEvents count]];
    if ([deligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }
    
    
    NSString *filterCatString =@"";
    deligate.arraySelectedCategories =[[NSMutableArray alloc]init ];
    [deligate getCategories];
    [deligate getSubCategories];
    
    for (int index=0; index<[deligate.arraySelectedCategories count]; index++) {
        
        Categories *c =(Categories *)[deligate getCategoryDataById:[deligate.arraySelectedCategories objectAtIndex:index]];
        filterCatString =[filterCatString stringByAppendingFormat:@"%@,",c.category_name];
    }
    self.lblFilterText.text = filterCatString;
    
    self.navigationController.navigationBarHidden = YES;
    
    
    
	arView = (ARView *)self.view;
	
       [arView bringSubviewToFront:btnSettings];
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width-100, 200, 120, 25)];
	[self.slider addTarget:self action:@selector(sliderChanged:)     forControlEvents:UIControlEventValueChanged];
    self.slider.transform = CGAffineTransformRotate(self.slider.transform, 90 * M_PI /180);
    

	//self.slider.backgroundColor = [UIColor clearColor];
	//self.slider.value = 0;
	//[self.slider setMaximumValue:4];
    //[self.slider setValue:4];
    self.settingView = [[UIView alloc]initWithFrame:self.view.frame];
    CGRect rect = self.settingView.frame;
    rect.origin.y = 20;
    self.settingView.frame = rect;
    self.settingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.settingView.backgroundColor =[UIColor blackColor];
    // self.settingView.alpha = 0.8;
    btnClose = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 37)];
    [btnClose setTitle:@"閉じる" forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.settingView addSubview:btnClose];
    
    //[self.settingView addSubview:self.slider];
    [arView addSubview:self.settingView];
    self.settingView.hidden=YES;
    
    
    
    self.isFirstTime = YES;
    
    //[self radarSpecificSettings];
    self.slider.value = 3;
    radius=50;
    //self.lblDistance.text = [NSString stringWithFormat:@"%d m",30];
    self.orientation = UIInterfaceOrientationPortrait;
    
    
    //radar setting
    int radarRadius = 75;
    self.settingRadar = [[Radar alloc]initWithFrame:CGRectMake(50,150, radarRadius*2, radarRadius*2)];	
    self.settingRadar.RADIUS = radarRadius;
    self.settingRadarViewPort = [[RadarViewPortView alloc]initWithFrame:CGRectMake(50+radarRadius/2,150+radarRadius/2, radarRadius*2, radarRadius*2)];
    self.settingRadarViewPort.RADIUS =radarRadius;
    [self.viewSetting addSubview:self.settingRadar];
    [self.viewSetting addSubview:self.settingRadarViewPort];
    
    [self constructCalloutPOI];
    //[arView start];
    NSLog(@"View loading end");
    
}
-(IBAction)btnMoveForward:(id)sender
{
    arView.currentDistance =arView.currentDistance+1;
    CGRect rect = arView.captureLayer.frame;
    rect.size.width = rect.size.width+20;
    rect.size.height = rect.size.height+20;
    arView.captureLayer.frame = rect;
    [arView updateView];
}

-(IBAction)btnMoveReverse:(id)sender
{
    //ARView *arView = (ARView *)self.view;
    
    arView.currentDistance =arView.currentDistance-1;
    CGRect rect = arView.captureLayer.frame;
    rect.size.width = rect.size.width-20;
    rect.size.height = rect.size.height-20;
    arView.captureLayer.frame = rect;    
    [arView updateView];
}
-(IBAction)btnClose:(id)sender
{

    [self.settingView setHidden:YES];
}




- (IBAction)calibrate:(id)sender
{   
    // Set offset so the compassImg will be calibrated to northOffset
    northOffest = updatedHeading - 0;
    compassFault.text = [NSString stringWithFormat:@"Northoffset: %f",northOffest]; // Debug
}







- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
   
    self.navigationController.navigationBar.hidden= YES;
	[self.settingView.layer setZPosition:250.0f];
    
    arView.radius =50;
           
	//arView = (ARView *)self.view;
	[arView start];
    
    //[locationManager startUpdatingHeading];
    //[locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSLog(@"%d",[self.tabBarController.view.subviews count]);
    //if (cbar ==nil) 
    {
        UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
        
        cbar = [[CustomTopNavigationBar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
        cbar.viewController = self;
        cbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [transView addSubview:cbar];
        /*CGRect rect = self.actionsView.frame;
        rect.origin.y = self.view.frame.size.height-rect.size.height;
        self.actionsView.frame = rect;
        [self.actionsView.layer setZPosition:200.0f];*/
        [transView addSubview:self.actionsView];
        
        [transView addSubview:btnSettings];
        [transView addSubview:lblDistance];
    }

    
    CLLocation *offerLoc = [[CLLocation alloc] initWithLatitude: 35.671635 longitude:139.763952];
   // double distance = [currentLocation distanceFromLocation: offerLoc];
    
    //distance =500;
    /*if (distance>1000) {
        self.tabBarController.selectedIndex =2;
        return;
    }*/

	[super viewDidAppear:animated];
    //[locationManager startUpdatingHeading];
    //[locationManager startUpdatingLocation];
    self.lblMessage.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    //[locationManager stopUpdatingHeading];
    //[locationManager stopUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    //[locationManager stopUpdatingHeading];
    //[locationManager stopUpdatingLocation];
    
	//ARView *arView = (ARView *)self.view;
	[arView stop];
    
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{ 
    
    return;
    UIInterfaceOrientation toOrientation = self.interfaceOrientation;
    //[self.arView setNeedsLayout];
    
    if ( self.tabBarController.view.subviews.count >= 2 )
    {
        UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
        
        transView.transform = CGAffineTransformIdentity;
        arView.radar.transform = CGAffineTransformIdentity;
        self.actionsView.transform = CGAffineTransformIdentity;
        switch (fromInterfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                transView.transform = CGAffineTransformMakeRotation(M_PI_2);
                 arView.radar.transform = CGAffineTransformMakeRotation(M_PI_2);// 90 degress
                break;
            case UIInterfaceOrientationLandscapeRight:
                transView.transform = CGAffineTransformMakeRotation(M_PI + M_PI_2); // 270 degrees
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                transView.transform = CGAffineTransformMakeRotation(M_PI); // 180 degrees
                break;
            default:
                transView.transform = CGAffineTransformMakeRotation(0.0);
                break;
        }
        
        
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    self.lblDistance.transform = CGAffineTransformIdentity;
    arView.radarView.transform = CGAffineTransformIdentity;
     //self.lblDistance.center = CGPointMake(self.view.frame.size.width-40, 50);
    //self.btnSettings.center = CGPointMake(self.lblDistance.frame.origin.x, 100);
    if ( self.tabBarController.view.subviews.count >= 2 )
    {
      //  UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
        
        self.arView.transform = CGAffineTransformIdentity;
        
        //self.actionsView.transform = CGAffineTransformIdentity;
        //self.actionsView.transform = CGAffineTransformMakeRotation(M_PI_2);
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.arView.transform = CGAffineTransformMakeRotation(M_PI_2);
                arView.radarView.transform = CGAffineTransformMakeRotation(-M_PI_2);
                // 90 degress
                break;
            case UIInterfaceOrientationLandscapeRight:
                self.arView.transform = CGAffineTransformMakeRotation(M_PI + M_PI_2); // 270 degrees
                arView.radarView.transform = CGAffineTransformMakeRotation(M_PI_2);
                //self.lblDistance.center = CGPointMake(50, 30);
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                self.arView.transform = CGAffineTransformMakeRotation(M_PI); 
                 // 180 degrees
                //self.actionsView.transform = CGAffineTransformMakeRotation(M_PI_2);
                //self.actionsView.frame = self.view.frame;
                break;
            default:
                self.arView.transform = CGAffineTransformMakeRotation(0.0);
                [self.actionViewLandScape removeFromSuperview];
                
               // self.cbar.transform = CGAffineTransformMakeRotation(0.0);
                break;
        }
        
        
    }

    
    
    return YES;
    UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
    UIView *tabBar = [self.tabBarController.view.subviews objectAtIndex:1];
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        tabBar.transform = CGAffineTransformIdentity;
        

    }
    if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
       
        
        NSLog(@"land");
        rotationAngle =90;
        tabBar.transform = CGAffineTransformIdentity;
        tabBar.transform = CGAffineTransformMakeRotation(degreesToRadianX(rotationAngle));
        CGRect rect = tabBar.frame;
        rect.origin.x=0;//self.view.frame.size.width-50;
        rect.origin.y = 20;//self.view.frame.size.height - 50;
        rect.size.height = self.view.frame.size.height;
        tabBar.frame = rect;
        

        
    } 
    return NO;
    return interfaceOrientation == UIInterfaceOrientationPortrait;
    //ARView *arView = (ARView *)self.view;
    
}

-(IBAction)settingOpen:(id)sender
{
    NSLog(@"setting");
    self.actionsView.hidden = YES;
    self.settingView.hidden= NO;
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
-(IBAction)btnVMModeOn:(id)sender
{
    self.btnVMMode.hidden=YES;
    self.btnBack.hidden =NO;
    self.btnForward.hidden =NO;
    self.btnReverse.hidden=NO;
    self.virtualwalkArrow.hidden=NO;
    
}
-(IBAction)btnVMModeOff:(id)sender
{
    self.btnVMMode.hidden=NO;
    self.btnBack.hidden =YES;
    self.btnForward.hidden =YES;
    self.btnReverse.hidden=YES;
    self.virtualwalkArrow.hidden=YES;
    
}


-(IBAction)btnHelp:(id)sender
{
    [self.view addSubview:self.helpView];
    
}
-(IBAction)btnHelpClose:(id)sender
{
    [self.helpView removeFromSuperview];
}

-(IBAction)btnPrevious:(id)sender
{
    
}
-(IBAction)btnNext:(id)sender
{
    NSLog(@"next");
}


-(IBAction)btnARViewClicked:(id)sender
{
    
    viewSetting.frame = self.view.frame;
    CGRect rect = viewSetting.frame;
    rect.origin.y=20;
    viewSetting.frame=rect;
    UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
    [transView addSubview:self.viewSetting];
    int i=0;
    NSMutableArray *placesOfInterestTemp = [[NSMutableArray alloc]init ];
    for (PlaceOfInterest *poi in self.placesOfInterest) {
        //NSLog(@"UPdate view POI %@",[NSDate date]);
        CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        CLLocation *pointBLocation = poi.location;  
        
        float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        
        //NSLog(@"distanceMeters = %f,%f,%f",distanceMeters,currentDistance,radius);
        //radius=250;
        if (distanceMeters >= currentDistance /*&& distanceAndIndex->distance<=self.maxtDistance*/) {
            
            if (distanceMeters<radius) {
                NSLog(@"radius POI insert = %f",radius);
                [placesOfInterestTemp insertObject:poi atIndex:i++];
            }
            
        }
        
    }
    self.settingRadarViewPort.placesOfInterest = placesOfInterestTemp;
    [self.settingRadarViewPort setNeedsDisplay];
}

-(IBAction)btnSettingClose:(id)sender
{
    //[arView stop];
    //[arView start];
    [arView updateView];
    [self.viewSetting removeFromSuperview];
    
   }

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.view.subviews) {
        if ([view pointInside:[self.view convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}
@end
