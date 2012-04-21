//
//  FilterGroupmetViewController.h
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterGroupmetViewController : UIViewController<UITableViewDelegate>
{
    
    NSMutableArray *arrayOfList;
    
    NSMutableArray *selectedArrayListt;
    

}
@property(nonatomic,retain)    NSMutableArray *arrayOfList;
@property(nonatomic,retain)    NSMutableArray *selectedArrayListt;
@property(nonatomic,retain)    NSMutableArray *arrayOfTitles;

@property(nonatomic,retain) NSMutableArray *arrayOfImages;

@property(nonatomic,retain)IBOutlet     UITableView *tblFilterView;

@property(nonatomic,retain)IBOutlet     UIPanGestureRecognizer *panGesture;

@property(nonatomic,retain) NSString *categoryId;
@end
