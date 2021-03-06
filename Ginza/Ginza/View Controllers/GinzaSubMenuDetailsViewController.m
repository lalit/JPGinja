//
//  GinzaSubMenuDetailsViewController.m
//  GinzaSubMenu
//
//  Created by jeeva karthik on 07/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import "GinzaSubMenuDetailsViewController.h"
#import "GinzaSubViewController.h"
#import "Constants .h"
@interface GinzaSubMenuDetailsViewController ()

@end

@implementation GinzaSubMenuDetailsViewController
@synthesize webDetails,event;
@synthesize panGesture;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    delegate.tabBarController.hidesBottomBarWhenPushed = YES;
    self.webDetails.backgroundColor =[UIColor clearColor];
    [self.webDetails setOpaque:NO];
     NSString *url = [NSString stringWithFormat:@"%@/%@png",eventImageURL,[event.image_name substringToIndex:[event.image_name length] - 3]];
    NSLog(@"image URL = %@",url);
    NSString *data =[NSString stringWithFormat:@"<HTML><meta name=\"viewport\" content=\"width=device-width\" /><body style=\"background-color:transparent\"><table><tr  span =2><td colspan=2>%@</td></tr><tr><td><b>%@</b></td><td><img src = \"%@\" width = 60 height = 80/></td></tr><tr><td colspan =2>%@</td></tr><tr><td colspan =2>%@</td></tr></table></HTML>",event.offer_title,event.copy_text,url,event.lead_text,event.free_text];
    [self.webDetails loadHTMLString:data baseURL:nil];

    
    
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

-(IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


-(IBAction)swipeUPAction:(id)sender
{
    
    NSLog(@"swipe Up");
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseOut animations:^(void) {
        //CGRect frame = self.view.frame;
    }
                     completion:^(BOOL finished) {                         
                         [UIView animateWithDuration:0.2 delay:0 options:0 animations:^(void) {
                             CGRect rect1 = self.view.frame;
                             rect1.origin.y = -1*rect1.size.height-20;
                             self.view.frame =rect1;
                             
                         } completion:^(BOOL finished) {
                             //currtentViewController.hidesBottomBarWhenPushed =NO;
                             //[self.navigationController popViewControllerAnimated:NO];
                             self.hidesBottomBarWhenPushed =NO;
                             
                             [self.navigationController popToRootViewControllerAnimated:NO];
                             //[self.view removeFromSuperview];
                         }];
                         
                     }];
    return;    
}


@end
