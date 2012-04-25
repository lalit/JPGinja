//
//  DirectionViewController.h
//  Diner Club
//
//  Created by mobimac on 7/27/11.
//  Copyright 2011 Mobiquest Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyAnnotation.h"
#import "FontLabel.h"

@interface DirectionViewController : UIViewController <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	UIBarButtonItem *backBtn;
	IBOutlet UITabBar *tabBar;
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIActivityIndicatorView *indiCator;
	IBOutlet UIImageView *loadingImg;
	FontLabel *lblTitle;
	FontLabel *lblAddress;
	IBOutlet MKMapView *mapView;
	float restLat,restLong;
	float currentLat,currentLong;
	
	NSArray* routes;
	UIImageView* routeView;
	UIColor* lineColor;
	
	NSMutableArray *arrDirectionText;
	NSMutableArray *arrDistance;
	
	UITabBarItem *addressTab;
	UITabBarItem *mapTab;
	UITabBarItem *shareTab;
	UITabBarItem *searchTab;
	
	NSString *strMode;
	NSString *strSummury;
	NSString *strTotalTime,*strTotalDistance;
	NSMutableData *webData;	
	int imgCounter;
	
    float user_lat;
	float user_long;
    
    BOOL mapflag;
    
    CLLocationCoordinate2D currentLocation1;
    CLLocationCoordinate2D givenLocation1;
    MyAnnotation *ann;
    MyAnnotation *annSecond;
	NSString *strLeft,*strRight,*strMerge,*strContinue,*strMerge1;

}
- (NSString *)flattenHTML:(NSString *)html;
- (void)updateData; 
- (void)getDirection;

- (void)setObject:(id)sender;
- (void)setLat:(NSString*)lat setLong:(NSString*)lang;
- (void)setBean:(id)sender;

- (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t;
- (void) updateRouteView;
- (void) centerMap;
- (void) showRoute;

- (IBAction)cancel:(id)sender;
@end
