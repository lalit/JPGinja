//
//  GinzaFilterViewController.h
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FilterGroupmetViewController.h"

@interface GinzaFilterViewController : UIViewController<UITableViewDelegate>
{
    
    
    UITableView *tblFilterView;
    NSMutableArray *arrayOfList;
    
    AppDelegate *sharedView;
    FilterGroupmetViewController *listViewController;
    
    
    UISwitch *btnswitch;
    
    NSMutableArray *selectedCategorieList;


    
}

@property(nonatomic,retain) UIViewController *fromViewController;
@property(nonatomic,retain)    NSMutableArray *selectedCategorieList;

@property(nonatomic,retain)IBOutlet     UITableView *tblFilterView;
@property(nonatomic,retain)    NSMutableArray *arrayOfList;
@property(nonatomic,retain)    AppDelegate *sharedView;

@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGesture;
@property(nonatomic,retain)    FilterGroupmetViewController *listViewController;
@property(nonatomic,retain)IBOutlet     UISwitch *btnswitch;
-(IBAction)btnSwitchChanged:(id)sender;
-(IBAction)btnSubMenuClose:(id)sender;
-(void)selectOrDeselectSubCategories:(NSString *)parent isSelected:(NSString *)isSelected;

@end
