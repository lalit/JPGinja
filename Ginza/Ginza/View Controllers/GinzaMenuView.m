//
//  GinzaMenuView.m
//  GinzaSubMenu
//
//  Created by jeeva karthik on 08/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import "GinzaMenuView.h"

@implementation GinzaMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




-(IBAction)GinzaDownView:(id)sender
{
    NSLog(@"Ginza Down");
 /*   GinzaSubViewController *infoViewController = [[GinzaSubViewController alloc]initWithNibName:@"GinzaSubViewController" bundle:nil];
    
    
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewContentModeTop];
    
    [UIView setAnimationTransition:UIViewContentModeTop 
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController pushViewController:infoViewController animated:YES];
    [UIView commitAnimations];
  
  */
    
    
}
-(IBAction)GinzaUpView:(id)sender
{
    NSLog(@"Ginza Up");

    
}

@end
