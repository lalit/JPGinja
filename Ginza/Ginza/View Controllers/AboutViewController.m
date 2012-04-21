//
//  AboutViewController.m
//  GinzaSubMenu
//
//  Created by Arul Karthik on 07/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import "AboutViewController.h"
#import "GinzaSubViewController.h"
@interface AboutViewController ()

@end

@implementation AboutViewController
@synthesize scrollView;
@synthesize aboutDetailsView;
@synthesize panGesture;

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
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width ,
                                             self.scrollView.frame.size.height+500);
    
    
    [self.view addSubview:scrollView]; 
    
    [scrollView addSubview:aboutDetailsView];
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
    
    GinzaSubViewController *infoViewController = [[GinzaSubViewController alloc]initWithNibName:@"GinzaSubViewController" bundle:nil];
    
         
        
    infoViewController.view.frame = CGRectMake(0,-100,320,480);
    
    [UIView beginAnimations:@"" context:nil];
       

   [self.navigationController pushViewController:infoViewController animated:NO];
    
    self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    
    [UIView setAnimationDuration:0.4]; 
    self.view.frame = CGRectMake(0,0,320,480);
    [UIView commitAnimations];
    
    
    
}

@end
