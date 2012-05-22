//
//  ListViewCell.h
//  Ginza
//
//  Created by Prasad M B on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offer.h"
#import "AppDelegate.h"

@interface ListViewCell : UITableViewCell {
    
    UIImageView  *backgroundImageView;
    UIImageView  *thumbnailImageView;
    UIImageView  *GIconImageView;
    UIButton *bookMarkImageView;
    UIImageView *arrowImageView;
    UILabel *lblCategoryName;
    UILabel *lblStoreName;
    UILabel *lblDirection;
    UILabel *lblSpecialOffer;
    UILabel *lblTime;
}

@property (nonatomic,retain) IBOutlet UIImageView  *thumbnailImageView;
@property (nonatomic,retain)IBOutlet UIImageView  *backgroundImageView;
@property (nonatomic,retain) IBOutlet UIButton  *bookMarkImageView;
@property (nonatomic,retain) IBOutlet UIImageView  *arrowImageView;
@property (nonatomic,retain) IBOutlet  UILabel *lblCategoryName;
@property (nonatomic,retain) IBOutlet UILabel *lblTime;
@property (nonatomic,retain) IBOutlet  UILabel *lblStoreName;
@property (nonatomic,retain) IBOutlet UILabel *lblDirection;
@property (nonatomic,retain) IBOutlet UILabel *lblSpecialOffer;
@property (nonatomic,retain) IBOutlet  UIImageView  *GIconImageView;
@property(nonatomic,retain) Offer *offer;

- (IBAction) btnBookmark:(id)sender;

@end
