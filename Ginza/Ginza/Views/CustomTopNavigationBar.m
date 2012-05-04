//
//  CustomTopNavigationBar.m
//  Ginza
//
//  Created by administrator on 24/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomTopNavigationBar.h"
#import "GinzaSubViewController.h"
#import "GinzaFilterViewController.h"
#import "SubMenuSearchViewController.h"

@implementation CustomTopNavigationBar
@synthesize toplevelSubView,viewController,lblEventCount,lblFilterText;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSBundle mainBundle] loadNibNamed:@"CustomTopNavigationBar" owner:self options:nil];
        toplevelSubView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.toplevelSubView];
    }
    
    
    AppDelegate *deligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[deligate.ginzaEvents count]];
    if ([deligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }
    
    
    NSString *filterCatString =@"";
    deligate.arraySelectedCategories =[[NSMutableArray alloc]init ];
    [deligate getCategories];
    [deligate getSubCategories];
    //NSMutableArray *dataArray = [deligate getOfferData];
    for (int index=0; index<[deligate.arraySelectedCategories count]; index++) {
        
        Categories *c =(Categories *)[deligate getCategoryDataById:[deligate.arraySelectedCategories objectAtIndex:index]];
        filterCatString =[filterCatString stringByAppendingFormat:@"%@,",c.category_name];
    }
    self.lblFilterText.text = filterCatString;
    

    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(IBAction)btnGinzaMenu:(id)sender
{
    GinzaSubViewController  *infoViewController = [[GinzaSubViewController alloc]init];
    self.viewController.hidesBottomBarWhenPushed = YES;
    [infoViewController.view.layer setZPosition:700.0f];
    [self.viewController.navigationController pushViewController:infoViewController animated:NO];
    infoViewController.fromViewController = self.viewController;
    CGRect rect = infoViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    infoViewController.view.frame =rect;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = infoViewController.view.frame;
    rect1.origin.y = 0;
    infoViewController.view.frame =rect1;
        [UIView commitAnimations];

}

-(IBAction)btnNavMenu:(id)sender
{
    GinzaFilterViewController  *filterViewController = [[GinzaFilterViewController alloc]init];
    self.viewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:filterViewController animated:NO];
    filterViewController.fromViewController = self.viewController;
    CGRect rect = filterViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    filterViewController.view.frame =rect;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = filterViewController.view.frame;
    rect1.origin.y = 0;
    filterViewController.view.frame =rect1;
    
    [UIView commitAnimations];
}

-(IBAction)btnSearchMenu:(id)sender
{
    SubMenuSearchViewController  *searchViewController = [[SubMenuSearchViewController alloc]init];
    
    self.viewController.hidesBottomBarWhenPushed = YES;
    [self.viewController.navigationController pushViewController:searchViewController animated:NO];
    searchViewController.fromViewController = self.viewController;
    CGRect rect = searchViewController.view.frame;
    rect.origin.y = -1*rect.size.height;
    searchViewController.view.frame =rect;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDuration:0.75];
    CGRect rect1 = searchViewController.view.frame;
    rect1.origin.y = 0;
    searchViewController.view.frame =rect1;
    
    [UIView commitAnimations];


}
@end
