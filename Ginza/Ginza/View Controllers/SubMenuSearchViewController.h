//
//  SubMenuSearchViewController.h
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@interface SubMenuSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

{
    
    
    UITableView *tblSearchView;
    
    NSMutableArray *contentsList;
	NSMutableArray *searchResults;
	NSString *savedSearchTerm;
    
    
    UISearchDisplayController *searchDisplayController;
    
    UISearchBar *searchBar;
    
}

@property(nonatomic,retain)IBOutlet    UITableView *tblSearchView;
@property (nonatomic, retain) NSMutableArray *contentsList;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property(nonatomic,retain)DetailViewController *detailsViewlist;
@property(nonatomic,retain)    UISearchDisplayController *searchDisplayController;
@property(nonatomic,retain)UIViewController *fromViewController;


@property(nonatomic,retain)IBOutlet     UISearchBar *searchBar;


- (void)handleSearchForTerm:(NSString *)searchTerm;



@end
