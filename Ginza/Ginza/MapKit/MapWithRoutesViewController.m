//
//  MapWithRoutesViewController.m
//  MapWithRoutes
//
//  Created by kadir pekel on 5/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "MapWithRoutesViewController.h"
#import "Location.h"
@implementation MapWithRoutesViewController

@synthesize destination;


/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

	MapView* mapView = [[[MapView alloc] initWithFrame:
						 CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
	
	[self.view addSubview:mapView];
	
    CLLocation *currentLoc=[Location sharedInstance].currentLocation;
    
	Place* source = [[[Place alloc] init] autorelease];
	source.name = @"Current Location";
	source.description = @"";
	source.latitude = 1.324658;
	source.longitude = 103.93238;
	//source.latitude=currentLoc.coordinate.latitude;
   // source.longitude=currentLoc.coordinate.longitude;
	Place* dest = [[[Place alloc] init] autorelease];
	dest.name = @"Destination";
	dest.description = @"Destination";
	//dest.latitude = 1.3296047;
	//dest.longitude = 103.8932174;
	dest.latitude= self.destination.coordinate.latitude;
    dest.longitude=    self.destination.coordinate.longitude;
	
	[mapView showRouteFrom:source to:dest];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self 
               action:@selector(cancel:)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    button.frame = CGRectMake(255, 3, 60,35);
    [self.view addSubview:button];

}

- (void) setDestination:(CLLocation *) aDestination {
       destination=aDestination;
    NSLog(@"Destinat");
}

- (void)cancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
