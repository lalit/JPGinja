//
//  ARViewController.m
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomARViewController.h"
#import "GinzaConstants.h"
#import "GinzaMenuViewController.h"
#import "SubMenuHomeController.h"
#import "MainViewController.h"
#import "SearchViewController.h"
#import "GinzaSubViewController.h"
#import <MapKit/MapKit.h>



@interface CustomARViewController ()

@end

@implementation CustomARViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AR", @"AR");
        self.tabBarItem.image = [UIImage imageNamed:@"CameraIcon"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    self.navigationController.navigationBarHidden = YES;

    
   // GinaViewController *detailViewController = [[GinaViewController alloc]init];
   
    //[detailViewController.btnSubMenu addTarget:self action:@selector(btnEventsTouched1:) forControlEvents:UIControlEventTouchUpInside];
   //[self.view addSubview:detailViewController.view];
     
    
   // self.view =viewController.view;
	//[self.view addSubview:viewController.view];
    nav =[[UINavigationController alloc]init ];
    nav.navigationBarHidden =YES;
    //[self.view addSubview:nav.view];
    
      
}

-(IBAction)btnShowEvents:(id)sender
{
    SubMenuHomeController *v =[[SubMenuHomeController alloc]init];
    v.modalPresentationStyle =  UIModalTransitionStyleCoverVertical;

    [self presentModalViewController:v animated:YES];

    //[self.navigationController pushViewController:v animated:YES];
    //[self.view addSubview:v.view];
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


-(IBAction)btnShowSearch:(id)sender
{
   // MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    SearchViewController *search = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    [self presentModalViewController:search animated:NO];
    CGSize theSize = CGSizeMake(320, 460);
    search.view.frame = CGRectMake( theSize.width*2, 12, theSize.width, theSize.height);
    [UIView beginAnimations:@"animationID" context:NULL];
    
    search.view.frame = CGRectMake(0, 16, 320, 460);
    
    [UIView commitAnimations];

}



-(IBAction)btnGinzaMenu:(id)sender
{
    GinzaSubViewController  *infoViewController = [[GinzaSubViewController alloc]init];
    // self.hidesBottomBarWhenPushed = YES;
    // [self.navigationController pushViewController:infoViewController animated:NO];
    CGRect rect = infoViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    infoViewController.view.frame =rect;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = infoViewController.view.frame;
    rect1.origin.y = 0;
    infoViewController.view.frame =rect1;
    
    [UIView commitAnimations];
}
@end
