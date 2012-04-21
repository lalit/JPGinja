/*
 File: pARkViewController.h
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

#import <UIKit/UIKit.h>
#import "RadarViewPortView.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>
#import <math.h>

#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)
#define radianConst M_PI/180.0

@interface pARkViewController : UIViewController <CLLocationManagerDelegate, UIAccelerometerDelegate>{	
    RadarViewPortView *radar;
    Radar *radarView;
    CLLocationManager *locationManager;
    CMDeviceMotionHandler motionHandler;
    CMMotionManager     *motionManager;
    NSOperationQueue    *opQ;
    
    // Graphics
    UIImageView         *rotateImg;
    UIImageView         *compassImg;
    UIImageView         *trueNorth;
    UILabel             *compassDif;
    UILabel             *compassFault;
    UIButton            *calibrateBtn;
    
    NSTimer             *updateTimer;
    
    float               oldHeading;
    float               updatedHeading;
    float               newYaw;
    float               oldYaw;
    float               offsetG;
    float               updateCompass;
    float               newCompassTarget;
    float               currentYaw;
    float               currentHeading;
    float               compassDiff;
    float               northOffest;
    float               radius;
    int                 radiusChanged;
    
}
@property (nonatomic, retain)NSMutableArray *placesOfInterest;
@property (nonatomic)int  orientation;
@property (nonatomic, retain)IBOutlet UIButton *btnSettings;
@property (nonatomic, retain) IBOutlet UILabel *lblDistance;
@property (nonatomic, retain)CLLocation *currentLocation;
@property (nonatomic, retain) IBOutlet UIImageView *rotateImg;
@property (nonatomic, retain) IBOutlet UIImageView *compassImg;
@property (nonatomic, retain) IBOutlet UIImageView *trueNorth;
@property (nonatomic, retain) IBOutlet UILabel *compassDif;
@property (nonatomic, retain) IBOutlet UILabel *compassFault;
@property (nonatomic, retain) IBOutlet UIButton *calibrateBtn;
@property (nonatomic, retain) CLLocationManager	*locationManager;
@property (nonatomic, retain)IBOutlet UILabel *lblFilterText;
@property (nonatomic,retain)IBOutlet UISlider *slider;
@property (nonatomic, retain)IBOutlet UIView *settingView;
@property (nonatomic, retain)IBOutlet UIButton *btnClose;
@property (nonatomic, retain)IBOutlet UILabel *lblEventCount;
@property (nonatomic, retain)IBOutlet UIButton *btnHelp;
@property (nonatomic, retain)IBOutlet UIButton *btnBack;
@property (nonatomic, retain)IBOutlet UIButton *btnVMMode;
@property (nonatomic, retain)IBOutlet UIButton *btnForward;
@property (nonatomic, retain)IBOutlet UIButton *btnReverse;
@property (nonatomic, retain)IBOutlet UIView *helpView;

- (IBAction)calibrate:(id)sender;

-(void)radarSpecificSettings;
-(IBAction)btnGinzaMenu:(id)sender;
-(IBAction)GinzafilterViewDown:(id)sender;
-(IBAction)GinzaSearchView:(id)sender;
-(IBAction)btnNext:(id)sender;
-(IBAction)sliderChanged:(id)sender;
-(IBAction)btnClose:(id)sender;
-(IBAction)btnARViewClicked:(id)sender;
-(IBAction)btnVMModeOn:(id)sender;
-(IBAction)btnVMModeOff:(id)sender;
-(IBAction)btnHelp:(id)sender;
-(IBAction)btnHelpClose:(id)sender;
-(void)updateView;
@end
