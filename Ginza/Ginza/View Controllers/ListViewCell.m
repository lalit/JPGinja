//
//  ListViewCell.m
//  Ginza
//
//  Created by Prasad M B on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListViewCell.h"

@implementation ListViewCell
@synthesize thumbnailImageView;
@synthesize lblCategoryName;
@synthesize lblStoreName;
@synthesize lblDirection;
@synthesize bookMarkImageView;
@synthesize arrowImageView;
@synthesize lblSpecialOffer;
@synthesize backgroundImageView;
@synthesize lblTime;
@synthesize offer;
@synthesize GIconImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction)btnBookmark:(id)sender {
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [appDeligate updateBookMarkCount:offer];
    if ([offer.isbookmark isEqualToString:@"0"]) {
        [bookMarkImageView setImage:[UIImage imageNamed:@"Bookmarkplus.png"] forState:UIControlStateNormal];
    }
    else {
        [bookMarkImageView setImage:[UIImage imageNamed:@"Bookmarkminus.png"] forState:UIControlStateNormal];
    }
}

- (void)dealloc  {
    [thumbnailImageView release];
    [bookMarkImageView release];
    [arrowImageView release];
    [lblCategoryName release];
    [lblStoreName release];
    [lblTime release];
    [lblDirection release];
    [lblSpecialOffer release];
    [GIconImageView release];
    [super dealloc];
}

@end
