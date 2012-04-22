//
//  MapViewController.h
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomCallOutView.h"
#import "AppDelegate.h"

#define METERS_PER_MILE 1609.344
@interface TransparentToolbar : UIToolbar
@end

@interface MapViewController : UIViewController<MKMapViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>{
	
	IBOutlet MKMapView *mapView;
    CLLocationCoordinate2D selectedCoordinate;
    BOOL showCallout;
    BOOL isFirstTime;
    
    CLLocationManager* locationManager;
    CLLocation* location;

}
 
@property (nonatomic, retain) IBOutlet CustomCallOutView *popup;
@property (nonatomic, retain) AppDelegate *deligate;
@property (nonatomic, retain) IBOutlet UILabel *offerCountLabel;
@property (nonatomic, retain) NSMutableDictionary *mapDataDict;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *annodationView;
@property (nonatomic, retain) IBOutlet TransparentToolbar *mapToolbar;
@property (nonatomic, retain) CLLocationManager* locationManager;
@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, retain) IBOutlet UILabel *lblFilterText;
@property (nonatomic, retain) IBOutlet UILabel *lblEventCount;
@property (nonatomic)  CLLocationCoordinate2D zoomLocation;

- (NSArray *)nearestGinzhaLocationsWithinOneKilometers;

-(IBAction)btnModeChanged:(id)sender;
-(IBAction)btnFindUserLocation:(id)sender;
- (void)plotOfferPositions:(NSString *)responseString;
-(IBAction)btnGinzaMenu:(id)sender;
@end



