//
//  ARViewController.h
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GinaViewController.h"


@interface CustomARViewController : UIViewController <UINavigationControllerDelegate>
{
    
    
    UINavigationController *nav;
    
    
}
-(IBAction)btnShowEvents:(id)sender;
-(IBAction)btnShowSearch:(id)sender;
-(IBAction)btnGinzaMenu:(id)sender;



@end
