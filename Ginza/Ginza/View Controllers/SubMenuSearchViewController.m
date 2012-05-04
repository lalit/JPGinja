//
//  SubMenuSearchViewController.m
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubMenuSearchViewController.h"
#import "AppDelegate.h"
#import "OfferDetailsViewController.h"

@interface SubMenuSearchViewController ()

@end

@implementation SubMenuSearchViewController
@synthesize tblSearchView;
@synthesize contentsList;
@synthesize searchResults;
@synthesize savedSearchTerm;
@synthesize  detailsView ;
@synthesize searchDisplayController;
@synthesize searchBar,fromViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSMutableArray *dataArray =  [deligate getOfferData];
   
	NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i=0; i<[dataArray count]; i++) {
        Offer *offer =[dataArray objectAtIndex:i];
        [array addObject:[NSString stringWithFormat:@"%@-%@",offer.offer_id, offer.offer_title]];
        [array addObject:[NSString stringWithFormat:@"%@-%@",offer.offer_id,offer.copy_text]];
        [array addObject:[NSString stringWithFormat:@"%@-%@",offer.offer_id,offer.lead_text]];
        [array addObject:[NSString stringWithFormat:@"%@-%@",offer.offer_id,offer.free_text]];
    }
	[self setContentsList:array];
	
	// Restore search term
    
    
    for(id subview in [searchBar subviews])
    {
        if ([subview isKindOfClass:[UIButton class]]) {
            [subview setEnabled:NO];
            [subview setShowsSearchResultsButton:NO];
        }
    }
    
	if ([self savedSearchTerm])
	{
        [[[self searchDisplayController] searchBar] setText:[self savedSearchTerm]];
        
        
           
    }
    
    
    
    searchDisplayController.searchBar.showsCancelButton = NO;
    [searchDisplayController.searchBar setShowsCancelButton:NO animated:NO];
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

    [searchDisplayController.searchBar setBackgroundColor:[UIColor clearColor]];

}

- (void)viewWillAppear:(BOOL)animated
{
	
    [super viewWillAppear:animated];
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

	[[self tblSearchView] reloadData];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)handleSearchForTerm:(NSString *)searchTerm
{
	
	[self setSavedSearchTerm:searchTerm];
    
	
	if ([self searchResults] == nil)
	{
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[self setSearchResults:array];
	}
	
	[[self searchResults] removeAllObjects];
	
	if ([[self savedSearchTerm] length] != 0)
	{
		for (NSString *currentString in [self contentsList])
		{
			if ([currentString rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound)
			{
				[[self searchResults] addObject:currentString];
                
			}
		}
	}
	
}

#pragma mark -
#pragma mark UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	
	NSInteger rows;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
		rows = [[self searchResults] count];
	else
		rows = [[self contentsList] count];
	
	NSLog(@"rows is: %d", rows);
	return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
        
        
		contentForThisRow = [[self searchResults] objectAtIndex:row];
    
    
    
    
    
    
	else
		contentForThisRow = [[self contentsList] objectAtIndex:row];
	
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
		// Do anything that should be the same on EACH cell here.  Fonts, colors, etc.
	}
	
	// Do anything that COULD be different on each cell here.  Text, images, etc.
    
    /*
    
    UIActivityIndicatorView *spin = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGRect spinnerFrame = CGRectMake(12.0, 12.0, 20.0, 20.0);
    spin.frame = spinnerFrame;
    spin.clipsToBounds = YES;
    spin.backgroundColor = [UIColor whiteColor];
    
    
    
    // [self performSelectorOnMainThread:@selector(contentForThisRow:) withObject:searchBar.text waitUntilDone:YES];
    
    
    
    [cell addSubview:spin];
    [spin startAnimating];
    
    
    */
      NSArray *a = [contentForThisRow componentsSeparatedByString:@"-"];
    if ([a count]==2) {
        [[cell textLabel] setText:[a objectAtIndex:1]];
    }
	
    UIColor *lblColor= [UIColor colorWithRed:0/255.0 green:105/255.0 blue:170/255.0 alpha:1.0];

    cell.textLabel.textColor = lblColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
	
    searchDisplayController.searchBar.showsCancelButton = NO;
    [searchDisplayController.searchBar setShowsCancelButton:NO animated:NO];
    
  //  searchDisplayController.searchBar.frame = CGRectMake(0, 0, 251, 44);
    
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

    
    
	return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    searchDisplayController.searchBar.showsCancelButton = NO;
    [searchDisplayController.searchBar setShowsCancelButton:NO animated:NO];
    
    searchDisplayController.searchBar.frame = CGRectMake(0, 0, 251, 44);
    
    
    
    
    NSInteger row = [indexPath row];
	NSString *contentForThisRow = nil;
	
	if (tableView == [[self searchDisplayController] searchResultsTableView])
        
        
		contentForThisRow = [[self searchResults] objectAtIndex:row];
    
    
    
    
    
    
	else
		contentForThisRow = [[self contentsList] objectAtIndex:row];
    
    NSArray *a = [contentForThisRow componentsSeparatedByString:@"-"];
    if ([a count]==2) {
        if (detailsView==nil) {
            detailsView =[[OfferDetailsViewController alloc]init];
        }
       
        detailsView.offerId = [a objectAtIndex:0];
        
        [self presentModalViewController:detailsView animated:YES];
    }
    
    //[self.navigationController pushViewController:self.detailsViewlist animated:YES];
	
    
    
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    
    //controller.searchBar.showsCancelButton = NO;
    [controller.searchBar setShowsCancelButton:NO animated:NO];

    
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

	
	[self handleSearchForTerm:searchString];
    
  
   
    //  [self performSelectorOnMainThread:@selector(handleSearchForTerm:) withObject://searchString waitUntilDone:YES];
    // [spin stopAnimating];
    //[spin removeFromSuperview];
    
       
    
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    controller.searchBar.showsCancelButton = NO;

	[self setSavedSearchTerm:nil];
    
	
	[[self tblSearchView] reloadData];
     
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

    
    
	
}






-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
    searchDisplayController.searchBar.showsCancelButton = NO;

    [searchDisplayController.searchBar setShowsCancelButton:NO animated:NO];

    [searchDisplayController.searchBar setBackgroundColor:[UIColor clearColor]];
    
   
    
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);
    
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    [searchDisplayController.searchBar setShowsCancelButton:NO];
    
    [searchDisplayController.searchBar setShowsCancelButton:NO animated:NO];
    
    
    [searchDisplayController.searchBar setBackgroundColor:[UIColor clearColor]];
    
   
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

    
    return YES;
}




-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller

{
    controller.searchBar.showsCancelButton = NO;
    [controller.searchBar setShowsCancelButton:NO animated:NO];

    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);
    
    
    
    
    [controller.searchBar setBackgroundColor:[UIColor clearColor]];
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller 
{
    controller.searchBar.showsCancelButton = NO;
    [controller.searchBar setShowsCancelButton:NO animated:NO];

    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);
    [controller.searchBar setBackgroundColor:[UIColor clearColor]];

}



-(void)viewDidAppear:(BOOL)animated
{
    
    searchDisplayController.searchBar.frame = CGRectMake(30, 0, 217, 44);

}


-(IBAction)backAction:(id)sender
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


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



@end
