//
//  ShareViewController.m
//  CitibankSG_PhaseTwo
//
//  Created by Mobiq on 5/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareViewController.h"
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"
//#import "CitiCardsJPAppDelegate.h"
#import "SBJSON.h"

//#define kOAuthConsumerKey				@"H36F32LfjJhtIkMQBZGDQ"		//REPLACE ME
//#define kOAuthConsumerSecret			@"O9CzEHFO1vJdQCouxWB6Nc5YBqtLKy0i0BN0gMJIiI"		//REPLACE ME

#define kOAuthConsumerKey				@"fY5ZUfbXpdtyeCbqPghSLA"		//REPLACE ME
#define kOAuthConsumerSecret			@"97Onh405be1V01Po2BSad9oKcsdpp9sYCKATPxXA"		//REPLACE ME

//MDA Key
//#define kOAuthConsumerKey				@"f5SfVfhOjlj6UurYC45A"		//REPLACE ME
//#define kOAuthConsumerSecret			@"53K9NWVGwPRkBupSJXayQr141evpYTSZuXiOhyBNM"

#define kAppId @"208721592572737"

@implementation ShareViewController

@synthesize picker, twitterString;
@synthesize publishUrl;
@synthesize fbTitle;
@synthesize fbDesc;
@synthesize fbImagePath;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
        
        _permissions =  [[NSArray arrayWithObjects:
                          @"read_stream", @"offline_access",nil] retain];
        _facebook = [[Facebook alloc] init];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization.
        
        _permissions =  [[NSArray arrayWithObjects:
                          @"read_stream", @"offline_access",nil] retain];
        _facebook = [[Facebook alloc] init];
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) launchMail:(UIViewController *) parentVC withString: (NSString *) str
{
	Class class = NSClassFromString(@"MFMailComposeViewController");
	if (class != nil) {
        picker = [[MFMailComposeViewController alloc] init];
        if (picker != nil) {
            picker.mailComposeDelegate = self;
            
            [picker setSubject:@"Citibank"];
            
            // Set up recipients
            //	NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
            //	[picker setToRecipients:toRecipients];
            
            picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            
            // Set up recipients
            //NSArray *toRecipients = [NSArray arrayWithObject:@""]; 
            //NSArray *toRecipients = [NSArray alloc:@""]; 
            //[picker setToRecipients:toRecipients];
            
            
            
            
            NSString	*emailBody = str;
            
            [picker setMessageBody:emailBody isHTML:NO];
            /// TODO : Replace above strings with number of goals scored 
            //NSString *emailBody = @"Think you can beat me at Finger Football? If you want to beat me, you’ll have to score more than 20 goals. Just download the iPhone application from www.singtelfootballfrenzy.com and see if you can match my skills.";		[picker setMessageBody:emailBody isHTML:NO];
            [parentVC presentModalViewController:picker animated:YES];
            
            //picker.view.frame = self.view.frame;
            //[self.view addSubview:picker.view]; 
        }
		else
        {
            //NSLog(@"Mail picker object is nil");
        }
		
		
	}
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSString *msg = @"", *msgTitle = @"";
	if (result == MFMailComposeResultSent) {
		msgTitle = @"メールを送信しました。";
	}
	else if (result == MFMailComposeResultSaved) {
		msgTitle = @"メールが保存されました。";
	}
	else if (result == MFMailComposeResultCancelled) {
		msgTitle = @"メールをキャンセルしました。";
	}
	else if (result == MFMailComposeResultFailed) {
		msgTitle = @"メールを送信できませんでした";
		msg = [error description];
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msgTitle message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	//[picker.view removeFromSuperview];
	//[self.navigationController popViewControllerAnimated:YES];
	[picker dismissModalViewControllerAnimated:YES];
	[picker release];

}


- (void) launchFacebookWithStr: (NSString *) str WithImage:(UIImage *) img withParentVC: (UIViewController *) parentVC withImagePath: (NSString *) imagepath
{
	//NSLog(@"launchFacebookWithStr with image path with string: <%@>", str);
  //  parentView = parentVC.view;
    self.fbImagePath = imagepath;
    self.fbTitle = str;
    self.publishUrl = @"";
    self.fbDesc = @"";
    
    if (isLoggedIn) {
        //[self addCaption];
        [self publishOnWall];
    } else {
        [self login];
    }
    
    
	/*self.fbVC = [[FBFunViewController alloc] initWithNibName:@"FBFunViewController" bundle:nil];
	//self.fbVC.filePath = path;
	self.fbVC.selectedImage = img;
	//self.fbVC.selectedImageView.image = selectedImage;
	[self.fbVC setImageForSelect:img];
	CGRect frm = self.fbVC.view.frame;
	//NSLog(@"FB VC Frame: <%@>",NSStringFromCGRect(self.fbVC.view.frame));
	frm.origin.y = 0;
	self.fbVC.view.frame = frm;
	self.fbVC.postmessage = str;
    self.fbVC.imagePath = imagepath;
	[self.fbVC setLoginState];
	[self.fbVC refresh];
	//[self.fbVC login];
	[self.fbVC.view setHidden:NO];
	
	[parentVC.view addSubview:self.fbVC.view];*/
	
}

- (void) launchFacebookWithStr: (NSString *) str WithImage:(UIImage *) img withParentVC: (UIViewController *) parentVC
{
  //  parentView = parentVC.view;
    //NSLog(@"launch facebook with str without image url path");
    self.fbImagePath = @"";
    self.title = str;
    self.publishUrl = @"";
    self.fbDesc = @"";
    
    if (isLoggedIn) {
        //[self addCaption];
        [self publishOnWall];
    } else {
        [self login];
    }
    
	/*//NSLog(@"launchFacebook");
	self.fbVC = [[FBFunViewController alloc] initWithNibName:@"FBFunViewController" bundle:nil];
	//self.fbVC.filePath = path;
	self.fbVC.selectedImage = img;
	//self.fbVC.selectedImageView.image = selectedImage;
	[self.fbVC setImageForSelect:img];
	CGRect frm = self.fbVC.view.frame;
	//NSLog(@"FB VC Frame: <%@>",NSStringFromCGRect(self.fbVC.view.frame));
	frm.origin.y = 0;
	self.fbVC.view.frame = frm;
	self.fbVC.postmessage = str;
	[self.fbVC setLoginState];
	[self.fbVC refresh];
	//[self.fbVC login];
	[self.fbVC.view setHidden:NO];
	
	[parentVC.view addSubview:self.fbVC.view];*/
	
}

- (void) launchFacebookWithStr: (NSString *) str withParentVC: (UIViewController *) parentVC
{
   // parentView = parentVC.view;
    
    self.fbImagePath = @"";
    self.title = str;
    self.publishUrl = @"";
    self.fbDesc = @"";
    
    if (isLoggedIn) {
        //[self addCaption];
        [self publishOnWall];
    } else {
        [self login];
    }
    
	/*[[[[UIApplication sharedApplication] delegate] facebook] post:str];
	
	self.fbVC = [[FBFunViewController alloc] initWithNibName:@"FBFunViewController" bundle:nil];
	//self.fbVC.filePath = path;
	//self.fbVC.selectedImage = img;
	//self.fbVC.selectedImageView.image = selectedImage;
	//[self.fbVC setImageForSelect:img];
	CGRect frm = self.fbVC.view.frame;
	frm.origin.y = 0;
	self.fbVC.view.frame = frm;
	self.fbVC.postmessage = str;
	[self.fbVC setLoginState];
	[self.fbVC refresh];
	//[self.fbVC login];
	[self.fbVC.view setHidden:NO];
	
	[parentVC.view addSubview:fbVC.view];*/
    
    
}

- (void) launchFacebookWithStr: (NSString *) str
{
    self.fbImagePath = @"";
    self.title = str;
    self.publishUrl = @"";
    self.fbDesc = @"";
    
    if (isLoggedIn) {
        //[self addCaption];
        [self publishOnWall];
    } else {
        [self login];
    }
	/*[[[[UIApplication sharedApplication] delegate] facebook] post:str];
	
	self.fbVC = [[FBFunViewController alloc] initWithNibName:@"FBFunViewController" bundle:nil];
	//self.fbVC.filePath = path;
	//self.fbVC.selectedImage = img;
	//self.fbVC.selectedImageView.image = selectedImage;
	//[self.fbVC setImageForSelect:img];
	CGRect frm = self.fbVC.view.frame;
	frm.origin.y = 0;
	self.fbVC.view.frame = frm;
	self.fbVC.postmessage = str;
	[self.fbVC setLoginState];
	[self.fbVC refresh];
	//[self.fbVC login];
	[self.fbVC.view setHidden:NO];
	
	[self.view addSubview:fbVC.view];*/
}

-(void)removeFBVC
{
	//NSLog(@"inside remove");
	//[self.fbVC.view removeFromSuperview];
	//[self.fbVC.view setHidden:YES];
	
}

- (void) launchTwitter: (UIViewController *) parentVC  withString:(NSString *) str
{
	//CitibankSG_PhaseTwoAppDelegate *appDelegate = (CitibankSG_PhaseTwoAppDelegate *)[[UIApplication sharedApplication]delegate];
	/*[appDelegate fromShareView_loadTwitterView:offerName 
	 WithOfferAddress:[appDelegate getOfferAddress] 
	 WithPageView:@"SHARE" 
	 withOfferDetails:[appDelegate getOfferDetails]];*/
	
	//if (_engine) return;
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	
	self.twitterString = str;
	UIViewController* controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) 
	{
		//NSLog(@"inside if");
		[parentVC presentModalViewController:controller animated: YES];
	}
	else {
		[self PostToTwitter2];
	}
}


#pragma mark Twitter Delegates
-(void)PostToTwitter1
{
	//UIActionSheet * loadingActionSheet;
	//CitibankSG_PhaseTwoAppDelegate	*appDelegate =(CitibankSG_PhaseTwoAppDelegate *)[[UIApplication sharedApplication]delegate];
		NSString *str_temp =@"...";
	//NSString *url = [NSString stringWithFormat:@"%@%@", uHost, currentMerchant.[appDelegate getOfferID]];
	//	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	//	str_temp = [str_temp stringByAppendingString:url];
	//	str = [str stringByAppendingString:str_temp];	
	if ( [twitterString length] > 140)
	{
		int range_max = 139-[str_temp length];
		//NSLog(@"PostToTwitter1 if :%d",range_max);
		NSString *trimmedText = twitterString;
		trimmedText = [trimmedText substringWithRange:NSMakeRange(0, range_max)];
		trimmedText = [trimmedText stringByAppendingString:str_temp];
		
		
		[_engine sendUpdate:trimmedText];
		[_engine clearAccessToken];
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	else{
		//NSLog(@"PostToTwitter1 else");
		[_engine sendUpdate:twitterString];
		[_engine clearAccessToken];
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}	
	
}

-(void)PostToTwitter2
{
	//NSLog(@"control in post twitter 2");
	//UIActionSheet * loadingActionSheet;
	//CitibankSG_PhaseTwoAppDelegate	*appDelegate =(CitibankSG_PhaseTwoAppDelegate *)[[UIApplication sharedApplication]delegate];
		//NSString *url = [NSString stringWithFormat:@"%@%@", uHost, currentMerchant.[appDelegate getOfferID]];
//	url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//	str_temp = [str_temp stringByAppendingString:url];
//	str = [str stringByAppendingString:str_temp];	
	NSString *str_temp =@"...";
	if ( [twitterString length] > 140)
	{
		int range_max = 139-[str_temp length];
		//NSLog(@"PostToTwitter2 if :%d",range_max);
		NSString *trimmedText = twitterString;
		trimmedText = [trimmedText substringWithRange:NSMakeRange(0, range_max)];
		trimmedText = [trimmedText stringByAppendingString:str_temp];
		
		[_engine sendUpdate:trimmedText];
		[_engine clearAccessToken];
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	else{
		//NSLog(@"PostToTwitter2 else");
		[_engine sendUpdate:twitterString];
		[_engine clearAccessToken];
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}	
	
}


//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	//NSLog(@"Authenicated for %@", username);
	[self PostToTwitter1];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Failed!");
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	//NSLog(@"Authentication Canceled.");
	[self.navigationController popViewControllerAnimated:YES];
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
	//NSLog(@"Request %@ succeeded", requestIdentifier);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"投稿しました。" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	//NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Post Failed" message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma Facebook

- (void)onClickFacebook {   
    if (isLoggedIn) {
        //[self addCaption];
        [self publishOnWall];
    } else {
        [self login];
    }
}
#pragma mark Facebook

- (void) login {
    [_facebook authorize:kAppId permissions:_permissions delegate:self];
}

- (void) logout {
    [_facebook logout:self];
}

-(void) publishOnWall {
    
    //SBJSON *jsonWriter = [[SBJSON new] autorelease];   
    //NSData *receivedData = [[NSData dataWithContentsOfURL:[NSURL URLWithString:objModel.photo]] retain];
    //UIImage *image = [[UIImage alloc] initWithData:receivedData] ;
    
    
    /*NSDictionary* attachment = [NSDictionary dictionaryWithObjectsAndKeys:
     objModel.title,@"name",
     objModel.blurb,@"description",
     objModel.photo,@"link",
     // @"http://app.st701.com", @"link",
     nil];
     NSDictionary* imageShare = [NSDictionary dictionaryWithObjectsAndKeys:
     @"image", @"type",
     objModel.photo, @"src",
     @"http://app.st701.com",@"href",
     nil];
     
     NSString *attachmentStr = [jsonWriter stringWithObject:attachment];
     NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     kAppId, @"api_key",
     @"Share on Facebook",  @"user_message_prompt",                             
     attachmentStr, @"attachment",                                              
     nil];
     [_facebook dialog: @"stream.publish"
     andParams:params
     andDelegate:self];*/
    
    /*NSMutableDictionary * paramimg = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     objModel.photo, @"link",
     @"Test Image" ,@"caption",
     nil];
     [_facebook requestWithMethodName: @"photos.upload"
     andParams: paramimg
     andHttpMethod: @"POST"
     andDelegate: self];*/
    
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"api_key",
                                   //@"http://developers.facebook.com/docs/reference/dialogs/", @"link",
                                   self.publishUrl,@"link",
                                   self.fbImagePath, @"picture",
                                   self.fbTitle, @"name",
                                   [NSString stringWithFormat:@"%@",self.fbDesc],@"description",                                                               
                                   nil];
    [_facebook dialog:@"feed"
            andParams:params
          andDelegate:self];
    
}

-(void) uploadPhotoOnWall {
    //[appDelegate showLoadingView];
    /*NSMutableDictionary * params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     asyncImage, @"picture",
     @"Test Image" ,@"caption",
     nil];
     [_facebook requestWithMethodName: @"photos.upload"
     andParams: params
     andHttpMethod: @"POST"
     andDelegate: self];*/
}
// Callback for facebook login

-(void) fbDidLogin {
    isLoggedIn = TRUE;
    [self publishOnWall];
}
// Callback for facebook did not login

- (void)fbDidNotLogin:(BOOL)cancelled {
    isLoggedIn = FALSE;
}

//Callback for facebook logout
-(void) fbDidLogout {
    isLoggedIn = FALSE;
}


- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse*)response{
    //[appDelegate hideLoadingView];
    //[self logout];
    //[self AlertWithTitle:@"Message!!" message:@"Photo has been uploaded"];
}

// Called when an error prevents the request from completing successfully.

- (void)request:(FBRequest*)request didFailWithError:(NSError*)error{
    
}


- (void)dialogDidSucceed:(FBDialog *)dialog {
}

- (void)request:(FBRequest*)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    if ([result objectForKey:@"owner"]) {
        
    } else {
        
    }
}

- (void)dialogCompleteWithUrl:(NSURL *)url {
   // [parentView setHidden:FALSE];
    //[indicator1 startAnimating];
    
    NSString *theURLString = [url absoluteString];   
    NSString *successString = @"fbconnect://success?post_id=";
    NSString *skipString = @"fbconnect://success";
    
    NSString *subStringURL = nil;
    if ([theURLString length] > [successString length]) {
        subStringURL = [[url absoluteString] substringToIndex:28];
        // //NSLog(@"%@",subStringURL);       
    }   
    if ([subStringURL isEqualToString:successString])
    {
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"投稿しました。" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [successAlert show];
        [successAlert release];
    }
    
    if ([theURLString isEqualToString:skipString]) {
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"エラーが発生しました。\nもう一度試してください" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [successAlert show];
        [successAlert release];        
    }
   // [parentView setHidden:TRUE];
    
    //[indicator1 stopAnimating];
    
}


- (void)dialogDidComplete:(FBDialog*)dialog{
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Published Successfully" message:@"" delegate:self //cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    //[alert release];
}


- (void)dealloc {
	//NSLog(@"******************** Share View Controller:DEALLOC***************");
	self.twitterString = nil;
	self.picker = nil;
	[_engine release];
	//self.fbVC = nil;
    [super dealloc];
}



@end
