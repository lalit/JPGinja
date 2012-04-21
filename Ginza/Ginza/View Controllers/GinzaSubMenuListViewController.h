//
//  GinzaSubMenuListViewController.h
//  GinzaSubMenu
//
//  Created by jeeva karthik on 06/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinzaSubMenuDetailsViewController.h"
@interface GinzaSubMenuListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tblListView;
    
    UITableViewCell *cellListView;
    NSMutableArray *arrayEventsDataArray;
    NSMutableArray *arrayOfIcon;
    
    
    GinzaSubMenuDetailsViewController *ginzadetailsView;
    

}
@property(nonatomic,retain)NSString *type; 
@property(nonatomic,retain)IBOutlet     UITableView *tblListView;

@property(nonatomic,retain)IBOutlet     UITableViewCell *cellListView;
@property(nonatomic,retain)    NSMutableArray *arrayEventsDataArray;
@property(nonatomic,retain)    NSMutableArray *arrayOfIcon;

@property(nonatomic,retain)    GinzaSubMenuDetailsViewController *ginzadetailsView;

@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGesture;



@end
