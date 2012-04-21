//
//  ContactViewController.h
//  GinzaSubMenu
//
//  Created by Arul Karthik on 07/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactViewController : UIViewController<UIGestureRecognizerDelegate>
{
    
    
    
}

@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGesture;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *fullViewGesture;

@end
