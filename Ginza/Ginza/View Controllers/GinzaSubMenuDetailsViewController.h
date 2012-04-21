//
//  GinzaSubMenuDetailsViewController.h
//  GinzaSubMenu
//
//  Created by jeeva karthik on 07/04/12.
//  Copyright (c) 2012 arulkarthikgd@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Offer.h"

@interface GinzaSubMenuDetailsViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    
    
    
    
}
@property(nonatomic,retain)IBOutlet UIWebView *webDetails;
@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGesture;
@property(nonatomic,retain)Offer *event;
@property(nonatomic,retain)IBOutlet AppDelegate *delegate;

@end
