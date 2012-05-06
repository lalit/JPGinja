//
//  GinzaSubMenuListViewController.m
//  GinzaSubMenu
//
//  Created by jeeva karthik on 06/04/12.
//  Copyright (c) 2012  All rights reserved.
//

#import "GinzaSubMenuListViewController.h"
#import "GinzaSubMenuDetailsViewController.h"
#import "GinzaListCell.h"
#import "GinzaSubViewController.h"
#import "ListViewController.h"
#import "Offer.h"
#import "Constants .h"

@interface GinzaSubMenuListViewController ()

@end

@implementation GinzaSubMenuListViewController
@synthesize tblListView;
@synthesize cellListView;
@synthesize arrayEventsDataArray;
@synthesize arrayOfIcon;
@synthesize ginzadetailsView;
@synthesize panGesture,type;


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
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSLog(@"%@",type);
    if ([type isEqualToString:@"services"]) {
        self.arrayEventsDataArray = [appDeligate getServices];
    }else
    {
    self.arrayEventsDataArray = [appDeligate getGinzaEvents];  
    }

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


#pragma _
#pragma tableview


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
     return 100;
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return[arrayEventsDataArray count];
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
    static NSString *CellIdentifier = @"Cell";
    
    GinzaListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if cell is null then create new object
    if (cell == nil) {
        
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"GinzaListCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (GinzaListCell*)view;
               // NSLog(@"cells");
            }
        }
    }

    Offer *offer = [self.arrayEventsDataArray objectAtIndex:indexPath.row];
    cell.lblOfferTitle.text = offer.offer_title;
    cell.lblCopyText.text = offer.copy_text;
   // cell.imgShopImage.image = [UIImage imageNamed:offer.image_name];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@png",eventImageURL,[offer.image_name substringToIndex:[offer.image_name length] - 3]];
    NSURL * imageURL = [NSURL URLWithString:url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage * image = [UIImage imageWithData:imageData];
    cell.imgShopImage.image = image;
    NSLog(@"image url = %@/%@",eventImageURL, offer.image_name);

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.ginzadetailsView = [[GinzaSubMenuDetailsViewController alloc] initWithNibName:@"GinzaSubMenuDetailsViewController" bundle:nil];
    Offer *event = [self.arrayEventsDataArray objectAtIndex:indexPath.row];
    self.ginzadetailsView.event= event;
    [self.navigationController pushViewController:self.ginzadetailsView animated:YES];

    
}

-(IBAction)closeGinzaView:(id)sender
{
    
    
    NSLog(@"Ginza List View");
    
    ListViewController *listViewController = [[ListViewController alloc]initWithNibName:@"ListViewController" bundle:nil];
    
    
    
    listViewController.view.frame = CGRectMake(0,-100,320,480);
    
    [UIView beginAnimations:@"" context:nil];
    
   // [self dismissModalViewControllerAnimated:NO];

    [self.navigationController pushViewController:listViewController animated:NO];
    
    //self.tabBarController.hidesBottomBarWhenPushed = YES;
    
    
    [UIView setAnimationDuration:0.4]; 
    self.view.frame = CGRectMake(0,0,320,480);
    [UIView commitAnimations];
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
        
    GinzaSubViewController *infoViewController = [[GinzaSubViewController alloc]initWithNibName:@"GinzaSubViewController" bundle:nil];
        
        
        
    infoViewController.view.frame = CGRectMake(0,-100,320,480);
        
    [UIView beginAnimations:@"" context:nil];
        
        
    [self.navigationController pushViewController:infoViewController animated:NO];
        
    self.tabBarController.hidesBottomBarWhenPushed = YES;
        
        
    [UIView setAnimationDuration:0.4]; 
    infoViewController.view.frame = CGRectMake(0,0,320,480);
    [UIView commitAnimations];
        
        
        
   
    
}

@end
