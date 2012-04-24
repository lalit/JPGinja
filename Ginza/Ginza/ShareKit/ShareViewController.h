//
//  ShareViewController.h
//  CitibankSG_PhaseTwo
//
//  Created by Mobiq on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
//#import "FBFunViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
#import "FBConnect.h"



@class SA_OAuthTwitterEngine;

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate, SA_OAuthTwitterControllerDelegate, FBRequestDelegate,FBDialogDelegate,FBSessionDelegate> {
	
	SA_OAuthTwitterEngine				*_engine;
	MFMailComposeViewController *picker;
	
	NSString *twitterString;
	
	//FBFunViewController *fbVC;
    
    Facebook* _facebook;
    NSArray* _permissions;   
    BOOL  isLoggedIn;
    
    UIView *parentView;
    
    NSString *publishUrl;
    NSString *fbTitle;
    NSString *fbDesc;
    NSString *fbImagePath;
    
}
@property(nonatomic,retain) MFMailComposeViewController *picker;
@property(nonatomic,retain) NSString *twitterString;
//@property (nonatomic, retain) FBFunViewController *fbVC;
@property (nonatomic, retain) NSString *publishUrl;
@property (nonatomic, retain) NSString *fbTitle;
@property (nonatomic, retain) NSString *fbDesc;
@property (nonatomic, retain) NSString *fbImagePath;

-(void)PostToTwitter1;
-(void)PostToTwitter2;
- (void) launchFacebookWithStr: (NSString *) str;
- (void) launchFacebookWithStr: (NSString *) str WithImage:(UIImage *) img;
- (void) launchFacebookWithStr: (NSString *) str WithImage:(UIImage *) img withParentVC: (UIViewController *) parentVC withImagePath: (NSString *) imagepath;
- (void) launchTwitter: (UIViewController *) parentVC  withString:(NSString *) str;
- (void) launchMail:(UIViewController *) parentVC withString: (NSString *) str;
- (void) launchFacebookWithStr: (NSString *) str withParentVC: (UIViewController *) parentVC;

@end
