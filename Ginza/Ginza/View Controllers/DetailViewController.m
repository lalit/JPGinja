//
//  DetailViewController.m
//  DetailsTableView
//
//  Created by Arul Karthik on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
//#import "CustomNavigationBar.h"
#import "ListViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()


@end

@implementation DetailViewController


@synthesize viewDetails;
@synthesize viewOfferDetails;
@synthesize viewstoresDetails;

@synthesize scrollView;
@synthesize webView;

@synthesize btnOpenOffer;
@synthesize btnCloseOffer;
@synthesize btnClose;

@synthesize tblView;

@synthesize cellloaction;
@synthesize celltelephoneno;
@synthesize cellbusinesshrs;
@synthesize cellhollydays;


@synthesize imgBookmark;

@synthesize lblTitle;
@synthesize lblshopingSpecialityTitle;
@synthesize imgShopingImage;
@synthesize lblDistance;

@synthesize txtViewdetails;
@synthesize swipeGesture;

@synthesize imgTopBar;


@synthesize arrayOfContacts,offerId;

#pragma mark - Managing the detail item





- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    
    /* check offer  special / ginza */
    
    self.navigationController.navigationBarHidden = YES;

    
    imgTopBar.image = [UIImage imageNamed:@"navigtionBarbg_details.png"];

    
    
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width ,
                                             self.scrollView.frame.size.height+1200);
    
    
    [scrollView addSubview:viewDetails];    
    [self.view addSubview:imgBookmark];
    
    
    
    
    
    [imgBookmark bringSubviewToFront:self.view];      
    [self.view addSubview:btnClose];      
    [btnClose bringSubviewToFront:self.view];    
    
    
    swipeGesture.delegate = self;
    
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(bookmarkUPAction:)];    
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];    
    [imgBookmark addGestureRecognizer:swipeUp];
    
    
    
    
    y_position = self.viewDetails.frame.size.height;

    viewOfferDetails.frame = CGRectMake(self.viewOfferDetails.frame.origin.x,y_position,self.viewOfferDetails.frame.size.width,(self.viewOfferDetails.frame.size.height));
    
    [scrollView addSubview:viewOfferDetails];
    
    
    y_offerposition = self.viewOfferDetails.frame.size.height;

    
    y_storeposition = y_position + y_offerposition;
    
    viewstoresDetails.frame = CGRectMake(self.viewstoresDetails.frame.origin.x,y_storeposition,self.viewstoresDetails.frame.size.width,(self.viewstoresDetails.frame.size.height));
    
    [scrollView addSubview:viewstoresDetails];
    
    
   
    arrayOfContacts = [NSMutableArray arrayWithObjects:@"34636743",@"34646",@"34754756856",@"6856856",@"464575685", nil];
    
    
      AppDelegate  *appDeligate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    
   // Offer *offer =  [appDeligate getOfferDataById:offerId];
   

    
    
    
    
    NSString *strwebviewContents =@"お買い物やお食事の合い間に、";
    NSString *strbwebContents = @"取扱いサービス ・フリードリンクサービス ・手荷物預かりサービス";
    
    
    NSString *htmlString = [NSString stringWithFormat:@"<HTML><body><table><tr><td> </td><td>: %@</td></tr><tr><td> </td><td>: %@</td></tr></table>",strwebviewContents,strbwebContents];
    
    
    [webView setBackgroundColor:[UIColor clearColor]];
    webView.opaque = NO;
    
    [webView loadHTMLString:[htmlString description] baseURL:nil];
    
    
    
    /*  details Test View */
    
    
    
    
    NSString *details =@"利用条件                                                                                                      座ダイナー スクラブカード本会員様 および家族会員様と、その同伴者1名 様まで無料でご利用いただけます。以 降は、同伴者1名様につき1,000円をご 請求させていただきます(お支払いは ダイナースクラブカードをご利用くださ い)。  ";
    
    
    NSString *strdetails2 = @"混雑時にはご入室いただけない場合 があります。また、混雑状況によりご利 用時間制限をさせていただく場合もあ りますのでご了承ください。   ";
    
    NSString *strdetails3 = @"゙利用目的は休憩のみとし、商談など はご遠慮ください。    ";
    
    NSString *strdetails4 = @"ラウンジ内で提供している飲食物以外 のご飲食はご遠慮ください。    ";
    
    txtViewdetails.text = [NSString stringWithFormat:@"%@ \n,   %@ \n ,  %@ \n,   %@ \n", details, strdetails2,strdetails3,strdetails4];

    
   
    
}


#pragma _
#pragma _bookmar


-(IBAction)bookmarkUPAction:(id)sender
{
    
    
    
    NSLog(@"bookmark UP action ");
    
    imgBookmark.image = [UIImage imageNamed:@"bookmarkoff.png"];
}

-(IBAction)bookmarkDownAction:(id)sender
{
    
    
    
    NSLog(@"bookmark  Down Action ");
    
    imgBookmark.image = [UIImage imageNamed:@"bookmarkon.png"];
}


- (BOOL)gestureRecognizerShouldBegin:(UISwipeGestureRecognizer *)gestureRecognizer
{

    NSLog(@"should began gesture %@", gestureRecognizer);
    return YES;
}




-(IBAction)btnCloseAction:(id)sender
{
    
   // [ self.view removeFromSuperview];
    
    //[self.navigationController dismissModalViewControllerAnimated:YES];
    
    
 /*   ListViewController *listViewController = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
    
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewContentModeTop];
    
    [UIView setAnimationTransition:UIViewContentModeTop 
                           forView:self.navigationController.view cache:NO];
    
    
    
    [self.navigationController pushViewController:listViewController animated:YES];
    [UIView commitAnimations];
  
  */
    
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}





#pragma mark - Table View




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if([indexPath row] ==0 ) return cellloaction;
    if([indexPath row] == 1) return celltelephoneno;
    if([indexPath row] == 2) return cellbusinesshrs;
    if([indexPath row] == 3) return cellhollydays;

    
    return nil;
    
    
    
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}



-(IBAction)btnOfferOpenAction:(id)sender
{
    
    
    y_position = self.viewDetails.frame.size.height;

    y_offerposition = self.viewOfferDetails.frame.size.height;

    y_storeposition = y_position + y_offerposition;
    
    
    
    [UIView beginAnimations:@"" context:nil];
    
    [UIView setAnimationDuration:0.4]; 

    
    viewOfferDetails.frame = CGRectMake(self.viewOfferDetails.frame.origin.x,y_position,self.viewOfferDetails.frame.size.width,(self.viewOfferDetails.frame.size.height)*2);
    
    
    CGFloat curretPosition = viewOfferDetails.frame.size.height*2;
    
    
    viewstoresDetails.frame = CGRectMake(self.viewstoresDetails.frame.origin.x,curretPosition,self.viewstoresDetails.frame.size.width,self.viewstoresDetails.frame.size.height);
    
    
    [UIView commitAnimations];

    
    
    btnOpenOffer.hidden = YES;
    btnCloseOffer.hidden = NO;
    

       
    
    
    
    
}


-(IBAction)btnOfferCloseAction:(id)sender
{
    
    
    y_position = self.viewDetails.frame.size.height;
    
    y_offerposition = self.viewOfferDetails.frame.size.height;
    
    y_storeposition = y_position + y_offerposition;
    

    
    [UIView beginAnimations:@"" context:nil];
    
    [UIView setAnimationDuration:0.4]; 
    viewOfferDetails.frame = CGRectMake(self.viewOfferDetails.frame.origin.x,y_position,self.viewOfferDetails.frame.size.width,(self.viewOfferDetails.frame.size.height)/2);
    
    
    
        
    CGFloat curretPosition = self.viewOfferDetails.frame.size.height+y_position;
    
    viewstoresDetails.frame = CGRectMake(self.viewstoresDetails.frame.origin.x,curretPosition,self.viewstoresDetails.frame.size.width,self.viewstoresDetails.frame.size.height);
    
    
    [UIView commitAnimations];
    
    
    
    btnOpenOffer.hidden = NO;
    btnCloseOffer.hidden = YES;
    
    
}



							
@end
