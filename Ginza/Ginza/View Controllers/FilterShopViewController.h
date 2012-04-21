//
//  FilterShopViewController.h
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterShopViewController : UIViewController<UITableViewDelegate>
{
    
    NSMutableArray *arrayOfList;
    
}
@property(nonatomic,retain)    NSMutableArray *arrayOfList;

@property(nonatomic,retain)IBOutlet     UITableView *tblFilterView;

@end
