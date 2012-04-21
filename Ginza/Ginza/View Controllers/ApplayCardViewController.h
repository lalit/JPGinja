//
//  ApplayCardViewController.h
//  GinzaSubMenu
//
//  Created by Arul Karthik on 07/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinzaMenuView.h"
@interface ApplayCardViewController : UIViewController<UIGestureRecognizerDelegate>
{
    
    GinzaMenuView *ginzaTopView;
    UISwipeGestureRecognizer *swipeGesture;
    UIPanGestureRecognizer *panGesture;
    UIPanGestureRecognizer *fullViewGesture;
    
}
@property(nonatomic,retain)IBOutlet     UISwipeGestureRecognizer *swipeGesture;
@property(nonatomic,retain)IBOutlet     GinzaMenuView *ginzaTopView;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGesture;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *fullViewGesture;



@end
