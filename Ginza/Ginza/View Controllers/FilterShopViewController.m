//
//  FilterShopViewController.m
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterShopViewController.h"

@interface FilterShopViewController ()

@end

@implementation FilterShopViewController
@synthesize tblFilterView;
@synthesize arrayOfList;
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfList.count;
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
    
    
    NSData *object = [arrayOfList objectAtIndex:indexPath.row];
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
    
}


-(IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    
}
@end