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
}

@property(nonatomic,retain)   CLLocation *destination;
- (void) setDestination:(CLLocation *) aDestination;
- (IBAction)cancel:(id)sender;
@end

