//
//  GinzaMenuViewController.m
//  Ginza
//
//  Created by Arul Karthik on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GinzaMenuViewController.h"

@interface GinzaMenuViewController ()

@end

@implementation GinzaMenuViewController
@synthesize imgSwipe;
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
    [self.imgSwipe addGestureRecognizer:swipeRecognizer];
}



-(void)swipeAction
{
    NSLog(@"test");
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

@end
