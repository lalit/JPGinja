//
//  MapWithRoutesViewController.h
//  MapWithRoutes
//
//  Created by kadir pekel on 5/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "Place.h"

@interface MapWithRoutesViewController : UIViewController {

    CLLocation *destination;
    NSString *destinationAddress;
}

@property(nonatomic,retain)  CLLocation *destination;
@property(nonatomic,retain)  NSString *destinationAddress;
- (void) setDestination:(CLLocation *) aDestination;
- (void)cancel:(id)sender;
- (void) createTopBar;
@end

