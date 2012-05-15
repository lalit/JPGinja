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
#import "Constants .h"

@implementation pARkViewController
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
        self.tabBarItem.image = [UIImage imageNamed:@"Camera"];
        //self.navigationController.navigationBar.hidden = YES; 

        arView = (ARView *)self.view;
        arView.parentActionView = self.actionsView;
        arView.parentViewController= self;
        [btnSettings.layer setZPosition:205.0f];
        [arView start];
        lblDistance.text=@"50";
        lblDistance.hidden=YES;
        
        NSError *error;
        if (![[GANTracker sharedTracker] trackPageview:@"/app_ar"
                                             withError:&error]) {
            // Handle error here
        }
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"pARK View update location started");
    [Location sharedInstance].currentLocation=newLocation;
    if (isFirstTime) {
        [self updateView];
        self.isFirstTime=NO;
    }
    
    
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    
    //float x = acceleration.x;
    //float y = acceleration.y;
    float z = acceleration.z;
    if (self.tabBarController.selectedIndex==0) {
        if (z>=-0.9) {
            //self.tabBarController.selectedIndex =0;
        }else
        {
            //self.tabBarController.selectedIndex =1;
        }
    }
    
}







-(void)constructCalloutPOI
{
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [deligate getPointOfInterestItems];
    NSMutableDictionary *mapDataDict = deligate.poiDataDictionary;
    placesOfInterest = [[NSMutableArray alloc]init];
   
    int i=0;
    for (id key in mapDataDict)
    {
        NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
        Offer *offer =[offerdataArray objectAtIndex:0];
        ShopList *merchant = [deligate getStoreDataById:offer.store_id];
        double latitude =[merchant.latitude doubleValue];
        double longitude = [merchant.longitude doubleValue];
        
        //For testing
        //CLLocation *pointALocation = currentLocation;
        CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        CLLocation *pointBLocation = [[CLLocation alloc] initWithLatitude:[merchant.latitude doubleValue] longitude:[merchant.longitude doubleValue]];  
        
        float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        CustomCallOutView *popup =[[CustomCallOutView alloc]init];
        popup.parentViewController = deligate.arviewController;
        [popup prepareCallOutView:offer offerArray:offerdataArray];
        
        PlaceOfInterest *poi1 =[[PlaceOfInterest placeOfInterestWithView:popup at:[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] offerdata:offer distance:distanceMeters]autorelease];
        [self.placesOfInterest insertObject:poi1 atIndex:i++];
    }
      
    
}


- (void)viewDidLoad
{
    [self rotateSlider];
    [self drawSettingRadarView];
    return;
    
    currentDistance = 150;
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
    
   self.actionsView.hidden=NO;
    self.navigationController.navigationBar.hidden= YES;
	[self.settingView.layer setZPosition:250.0f];
    if ([self.placesOfInterest count]==0) {
        [self constructCalloutPOI];
    }
    [arView updateView];
    [arView.radar setNeedsDisplay];
    [arView.radarView setNeedsDisplay];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    //NSLog(@"%d",[self.tabBarController.view.subviews count]);
    //if (cbar ==nil) 
    {
        UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
        cbar = [[CustomTopNavigationBar alloc]initWithFrame:CGRectMake(0, 8, transView.frame.size.width, 40)];
        
        cbar.viewController = self;
        cbar.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [transView addSubview:cbar];
        [transView addSubview:self.actionsView];
        [transView addSubview:btnSettings];
        [transView addSubview:lblDistance];
        lblDistance.hidden=NO;
    }

    
    //CLLocation *offerLoc = [[CLLocation alloc] initWithLatitude: 35.671635 longitude:139.763952];
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
    self.actionsView.hidden=YES;
   
    //[locationManager stopUpdatingHeading];
    //[locationManager stopUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    self.actionsView.hidden=YES;
    self.cbar.hidden=YES;
    self.lblDistance.hidden = YES;
    //[locationManager stopUpdatingHeading];
    //[locationManager stopUpdatingLocation];
    
	//ARView *arView = (ARView *)self.view;
	//[arView stop];
    
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
        lblDistance.center = CGPointMake(self.tabBarController.tabBar.frame.size.width-40, 65);
         //self.settingRadar.center = CGPointMake(100, self.view.frame.size.height/2);
        
         btnSettings.center = CGPointMake(self.tabBarController.tabBar.frame.size.width-40, 110);
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




-(IBAction)btnPrevious:(id)sender
{
    
}
-(IBAction)btnNext:(id)sender
{
    NSLog(@"next");
}




#pragma Virtual walk
//Virtual walk move forward increase the current position by increment of 5 and zoom in cameraview by 40 pixel
-(IBAction)btnMoveForward:(id)sender
{
    if (currentDistance>=0) {
        currentDistance = currentDistance+5;
        arView.currentDistance =currentDistance;
        CGRect rect = arView.captureLayer.frame;
        rect.size.width = rect.size.width+40;
        rect.size.height = rect.size.height+40;
        arView.captureLayer.frame = rect;
        [arView updateView];
    }
   
}

//Virtual walk move reverse decrease the current position by decrement of 5 and zoom out cameraview by 40 pixel
-(IBAction)btnMoveReverse:(id)sender
{
    if (currentDistance>=0) {
        currentDistance = currentDistance-5;
        arView.currentDistance =currentDistance;
        CGRect rect = arView.captureLayer.frame;
        rect.size.width = rect.size.width-40;
        rect.size.height = rect.size.height-40;
        arView.captureLayer.frame = rect;    
        [arView updateView];

    }
}
#pragma radius Setting view
//Rotate radius setting slider to vertical
-(void)rotateSlider
{
     self.sdrRadius.transform= CGAffineTransformRotate(self.slider.transform, 90 * M_PI /180);
}
//Initialize and draw radar, radarViewport
-(void)drawSettingRadarView
{
    self.settingRadar = [[Radar alloc]initWithFrame:CGRectMake(50,100, settingRadarRadius*2, settingRadarRadius*2)];	
    self.settingRadar.RADIUS = settingRadarRadius;
    self.settingRadarViewPort = [[RadarViewPortView alloc]initWithFrame:CGRectMake(50+settingRadarRadius/2,100+settingRadarRadius/2, settingRadarRadius*2, settingRadarRadius*2)];
    self.settingRadarViewPort.RADIUS =settingRadarRadius;
    [self.viewSetting addSubview:self.settingRadar];
    [self.viewSetting addSubview:self.settingRadarViewPort];
}

//Close button action on setting view
-(IBAction)btnSettingClose:(id)sender
{
    actionsView.hidden=NO; //Hide setting view
    arView.radar.hidden=NO;
    arView.radarView.hidden=NO;
    [arView updateView]; // refresh POI's
    [self.viewSetting removeFromSuperview];
    
}


//Change the distance recreate POI's 
-(IBAction)sliderChanged:(id)sender
{
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
        CLLocation *pointALocation = [[[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295]autorelease];
        CLLocation *pointBLocation = poi.location;  
        
        float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        if (distanceMeters >= currentDistance /*&& distanceAndIndex->distance<=self.maxtDistance*/) {
            
            if (distanceMeters<radius) {
                [placesOfInterestTemp insertObject:poi atIndex:i++];
            }
            
        }
        
    }
    self.settingRadarViewPort.placesOfInterest = placesOfInterestTemp;
    [placesOfInterestTemp release];
    [self.settingRadarViewPort setNeedsDisplay];
}

//Open setting view construct radar points accoding to distance selection
-(IBAction)btnARViewClicked:(id)sender
{
    actionsView.hidden=YES;
    viewSetting.frame = self.view.frame;
    arView.radar.hidden=YES;
    arView.radarView.hidden=YES;
    CGRect rect = viewSetting.frame;
    rect.origin.y=20;
    viewSetting.frame=rect;
    UIView *transView = [self.tabBarController.view.subviews objectAtIndex:0];
    [transView addSubview:self.viewSetting];
   
    /*
     // Not needed radar view holds last state always
     int i=0;
    NSMutableArray *placesOfInterestTemp = [[NSMutableArray alloc]init ];
    for (PlaceOfInterest *poi in self.placesOfInterest) {
        CLLocation *pointALocation = [[CLLocation alloc] initWithLatitude:35.67163555 longitude:139.76395295];
        CLLocation *pointBLocation = poi.location;  
        
        float distanceMeters = [pointALocation distanceFromLocation:pointBLocation];
        if (distanceMeters >= currentDistance ) {
            
            if (distanceMeters<radius) {
                [placesOfInterestTemp insertObject:poi atIndex:i++];
            }
            
        }
        
    }
    //self.settingRadarViewPort.placesOfInterest = placesOfInterestTemp;
    //[self.settingRadarViewPort setNeedsDisplay];*/
}
#pragma Help related
//Open help layer
-(IBAction)btnHelp:(id)sender
{
    [self.view addSubview:self.helpView];
    self.btnHelp.hidden =YES;
    self.actionsView.hidden=YES;
    
}
//Close help layer
-(IBAction)btnHelpClose:(id)sender
{
    [self.helpView removeFromSuperview];
    self.btnHelp.hidden =NO;
    self.actionsView.hidden=NO;
}
@end
