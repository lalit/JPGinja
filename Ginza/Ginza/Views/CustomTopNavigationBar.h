//
//  CustomTopNavigationBar.h
//  Ginza
//
//  Created by administrator on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTopNavigationBar : UIView
@property(nonatomic,retain)IBOutlet UIView *toplevelSubView;
@property(nonatomic,retain)UIViewController *viewController;
@property(nonatomic,retain)IBOutlet UILabel *lblEventCount;
@property(nonatomic,retain)IBOutlet UILabel *lblFilterText;
-(IBAction)btnGinzaMenu:(id)sender;
-(IBAction)btnNavMenu:(id)sender;
-(IBAction)btnSearchMenu:(id)sender;
@end
