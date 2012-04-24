//
//  GinzaSubViewController.m
//  GinzaSubMenu
//
//  Created by jeeva karthik on 06/04/12.
//  Copyright (c) 2012  All rights reserved.
//

#import "GinzaSubViewController.h"
#import "GinzaSubMenuListViewController.h"
#import "ApplayCardViewController.h"
#import "AboutViewController.h"
#import "ContactViewController.h"
@interface GinzaSubViewController ()

@end

@implementation GinzaSubViewController
@synthesize tblView;
@synthesize arrayOflist;
@synthesize viewGinza;
@synthesize viewList;
@synthesize listViewController;

@synthesize tapGesture,currtentViewController,fromViewController;


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
    
    arrayOflist = [NSMutableArray arrayWithObjects:@"イベントのご案内",@"カード適用",@"このアプリについて ",@"お問い合わせ",@"銀座ラウンジのサービスについて", nil];
    
    [self.view addSubview:viewGinza];
    
    self.navigationController.navigationBarHidden = YES;
    
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOflist.count;
}

// Customize the appearance of table view cells.


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    NSData *object = [arrayOflist objectAtIndex:indexPath.row];
    cell.textLabel.text = [object description];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
  
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.listViewController) {
//        self.listViewController = [[GinzaSubMenuListViewController alloc] initWithNibName:@"GinzaSubMenuListViewController" bundle:nil];
//    }
//    NSData *object = [arrayOflist objectAtIndex:indexPath.row];
//    //  self.detailViewController.detailItem = object;
//    [self.navigationController pushViewController:self.listViewController animated:YES];
//    
    
    
    
    if (indexPath.row==0) {
        GinzaSubMenuListViewController *ginzaDetails = [[GinzaSubMenuListViewController alloc] initWithNibName:@"GinzaSubMenuListViewController" bundle:nil];
        
        ginzaDetails.type = @"event";
        [self.navigationController pushViewController:ginzaDetails animated:YES]; 
       
        
    
    }

    if (indexPath.row==4) {
        GinzaSubMenuListViewController *ginzaDetails = [[GinzaSubMenuListViewController alloc] initWithNibName:@"GinzaSubMenuListViewController" bundle:nil];
        ginzaDetails.type = @"services";
        
        [self.navigationController pushViewController:ginzaDetails animated:YES]; 
        
        
        
    }

    
    if (indexPath.row==1) {
        ApplayCardViewController *aboutViewController = [[ApplayCardViewController alloc] initWithNibName:@"ApplayCardViewController" bundle:nil];
        
        
        [self.navigationController pushViewController:aboutViewController animated:YES];    
        
    }

    
    if (indexPath.row==2) {
        AboutViewController *aboutViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
        
        
        [self.navigationController pushViewController:aboutViewController animated:YES];    
        
    }
   
    if (indexPath.row==3) {
        ContactViewController *contactViewController = [[ContactViewController alloc] initWithNibName:@"ContactViewController" bundle:nil];
        
        
        [self.navigationController pushViewController:contactViewController animated:YES];    
        
    }
    
}





-(IBAction)ActionSubMenuClose:(id)sender
{
      
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseOut animations:^(void) {
        //CGRect frame = self.view.frame;
            }
                     completion:^(BOOL finished) {                         
                         [UIView animateWithDuration:0.2 delay:0 options:0 animations:^(void) {
                             CGRect rect1 = self.view.frame;
                             rect1.origin.y = -1*rect1.size.height-20;
                             self.view.frame =rect1;
                           
                         } completion:^(BOOL finished) {
                             self.fromViewController.hidesBottomBarWhenPushed =NO;
                             [self.navigationController popViewControllerAnimated:NO];
                             //[self.view removeFromSuperview];
                         }];
                         
                     }];
    return;
        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationDidStopSelector:@selector(pulseAnimationDidStop:finished:context:)];
    CGRect rect1 = self.view.frame;
    rect1.origin.y = -1*rect1.size.height;
    self.view.frame =rect1;
    
    [UIView commitAnimations];
    }
- (void)pulseAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
[self.navigationController popViewControllerAnimated:NO];
}


@end
