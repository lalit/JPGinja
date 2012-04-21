//
//  GinaViewController.m
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GinaViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SubMenuHomeController.h"

@interface GinaViewController ()

@end

@implementation GinaViewController
@synthesize btnSubMenu;

@synthesize imgGinza;


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
    
    
    UISwipeGestureRecognizer *swipeRecognizer = 
    [[UISwipeGestureRecognizer alloc]
     initWithTarget:self 
     action:@selector(swipeAction)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.imgGinza addGestureRecognizer:swipeRecognizer];   
    
    
}


-(void)swipeAction
{
    NSLog(@"test");
}




- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}





- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(void)btnevent
{
    SubMenuHomeController *subMenu =[[SubMenuHomeController alloc]init];
    [self.view addSubview:subMenu.view];
}
@end
