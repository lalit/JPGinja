//
//  AboutViewController.h
//  GinzaSubMenu
//
//  Created by Arul Karthik on 07/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    
    
}
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)IBOutlet UIView *aboutDetailsView;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGesture;

@end
