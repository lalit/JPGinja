//
//  GinaViewController.h
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GinaViewController : UIViewController<UIGestureRecognizerDelegate>
{
    
    
    IBOutlet UIImageView *imgGinza;
    IBOutlet UIButton *btnSubMenu;
}
@property(nonatomic,retain)IBOutlet UIButton *btnSubMenu;
@property(nonatomic,retain)IBOutlet    UIImageView *imgGinza;


-(void)ginzaAction;

-(void)SearchAction;
-(IBAction)testAction:(id)sender;

-(IBAction)btnEventsTouched:(id)sender;

@end
