//
//  GinzaSubViewController.h
//  GinzaSubMenu
//
//  Created by jeeva karthik on 06/04/12.
//  Copyright (c) 2012  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinzaSubMenuListViewController.h"
@interface GinzaSubViewController : UIViewController<UITableViewDelegate,UIGestureRecognizerDelegate>
{
    
    UITableView *tblView;
    
    UIView *viewGinza;
    UIView *viewList;
    
    NSMutableArray *arrayOflist;
    GinzaSubMenuListViewController *listViewController;
    
    
    UITapGestureRecognizer *tapGesture;
    
    
    
}
@property(nonatomic,retain)UIViewController *currtentViewController;
@property(nonatomic,retain)IBOutlet  UITableView  *tblView;
@property(nonatomic,retain)    NSMutableArray *arrayOflist;
@property(nonatomic,retain)IBOutlet UIView *viewGinza;
@property(nonatomic,retain)IBOutlet UIView *viewList;
@property(nonatomic,retain)    GinzaSubMenuListViewController *listViewController;

@property(nonatomic,retain)IBOutlet    UITapGestureRecognizer *tapGesture;



@end
