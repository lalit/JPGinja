//
//  MapViewController.m
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "GinzaConstants.h"
#import "GinaViewController.h"
#import "CustomCallOutView.h"
#import "AddressAnnotation.h"


@implementation UIToolbar(Transparent) 
-(void)drawRect:(CGRect)rect {
    // do nothing in here
}
@end



@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapView,annodationView,mapToolbar,lblFilterText,popup,offerCountLabel,mapDataDict,lblEventCount,zoomLocation;
@synthesize deligate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"地図", @"地図");
        self.tabBarItem.image = [UIImage imageNamed:@"Mapicon.png"];  
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    self.lblEventCount.text =[NSString stringWithFormat:@"%d",[self.deligate.ginzaEvents count]];
    if ([self.deligate.ginzaEvents count]<=0) {
        self.lblEventCount.hidden =YES;
    }

    
    self.navigationController.navigationBarHidden = YES;
    
    
    
    MKUserTrackingBarButtonItem *buttonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    [self.mapToolbar setItems:[NSArray arrayWithObject:buttonItem] animated:YES];
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.mapToolbar setBackgroundImage:transparentImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addPin:)];
    [recognizer setNumberOfTapsRequired:1];
    self.mapView.delegate= self;
   // [self.mapView addGestureRecognizer:recognizer];
    
}

- (void)addPin:(UITapGestureRecognizer*)recognizer
{
    [self.mapView removeGestureRecognizer:recognizer];
}

-(void)viewDidAppear:(BOOL)animated
{

    [self plotOfferPositions:@"all"];
}
- (void)viewWillAppear:(BOOL)animated 
{  
    self.navigationController.navigationBarHidden = YES;
    if (!isFirstTime) {
        zoomLocation.latitude = 35.67163555;
        zoomLocation.longitude= 139.76395295;
        isFirstTime = YES;
    }
    zoomLocation.latitude = 35.67163555;
    zoomLocation.longitude= 139.76395295;
    // 2
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.2*METERS_PER_MILE, 0.2*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    // 4
    [mapView setRegion:adjustedRegion animated:YES];      
    
    
    CLLocationCoordinate2D originalCenter = CLLocationCoordinate2DMake(zoomLocation.latitude, zoomLocation.longitude);
    // ... adjust region
    [mapView setCenterCoordinate:originalCenter animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
(id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = nil; 
	if(annotation != mapView.userLocation) 
	{
		static NSString *defaultPinID = @"com.code.pin";
		pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
        pinView=nil;
		if ( pinView == nil ) pinView = [[MKPinAnnotationView alloc]
										  initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        
		pinView.pinColor = MKPinAnnotationColorRed; 
		pinView.canShowCallout = NO;
		pinView.animatesDrop = YES;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 50, 30)] ;
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = UITextAlignmentCenter;
        CGPoint r = pinView.center;
        r.x = r.x+7;
        r.y = r.y+7;
        lbl.center = r;
        lbl.font = [UIFont boldSystemFontOfSize:10.0];
        CLLocationCoordinate2D cor = [annotation coordinate];
        NSString *key =[NSString stringWithFormat:@"%f-%f",cor.latitude,cor.longitude];
        lbl.text = [NSString stringWithFormat:@"%d",[[self.mapDataDict objectForKey:key] count]];
        
        [pinView addSubview:lbl];
        
    } 
	else {
		[mapView.userLocation setTitle:@"I am here"];
	}
	return pinView;
}


- (void)plotOfferPositions:(NSString *)responseString {
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    
   self.mapDataDict = self.deligate.poiDataDictionary;
    for (id key in mapDataDict)
    {
        //NSMutableArray *offerdataArray  = [mapDataDict objectForKey:key];
        
        NSArray *latlong = [key componentsSeparatedByString:@"-"];
        double latitude =[[latlong objectAtIndex:0] doubleValue];
        double longitude = [[latlong objectAtIndex:1] doubleValue];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude;
        coordinate.longitude = longitude;            
        //CustomAnnodation *annotation = [[CustomAnnodation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
        
        AddressAnnotation *annotation =[[AddressAnnotation alloc]init];
        annotation.coordinate =coordinate;
        [mapView addAnnotation:annotation];
    }
    
}



-(IBAction)btnFindUserLocation:(id)sender
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 35.67163555;
    zoomLocation.longitude= 139.76395295;
    // 2
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.2*METERS_PER_MILE, 0.2*METERS_PER_MILE);
    // 3
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    // 4
    [mapView setRegion:adjustedRegion animated:YES];      
    
    
    CLLocationCoordinate2D originalCenter = CLLocationCoordinate2DMake(zoomLocation.latitude, zoomLocation.longitude);
    // ... adjust region
    [mapView setCenterCoordinate:originalCenter animated:YES];
}

-(IBAction)btnModeChanged:(id)sender
{
    BOOL ios5 = [mapView respondsToSelector:@selector(setUserTrackingMode:animated:)];
    if(ios5)
    {        
        [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    }
    else
    {
        // Do it the version 4.0 way
    }
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    //[self.mapView co];
    CGPoint newPoint = [self.mapView convertCoordinate:selectedCoordinate toPointToView:self.view];
    [self.popup  setCenter:CGPointMake(newPoint.x+5,newPoint.y-((self.popup.frame.size.height/2)-17))];
    [self.popup setHidden:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    CGPoint newPoint = [self.mapView convertCoordinate:selectedCoordinate toPointToView:self.view];

    [self.popup  setCenter:CGPointMake(newPoint.x,newPoint.y-((self.popup.frame.size.height/2)+(self.popup.frame.size.height/2)-17))];
    [self.popup setHidden:NO];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view 
{  
   
    showCallout = YES;
    for (UIView *view1 in self.mapView.subviews) {
        if ([view1 isKindOfClass:CustomCallOutView.class]) {
            [view1 removeFromSuperview];
        }
    }
     selectedCoordinate = view.annotation.coordinate;
    NSString *key =[NSString stringWithFormat:@"%f-%f",selectedCoordinate.latitude,selectedCoordinate.longitude];
    NSMutableArray *offerArray =  [mapDataDict objectForKey:key];
   
    if ([offerArray count]>0) {
        Offer *offer =[offerArray objectAtIndex:0];
        popup =[[CustomCallOutView alloc]init];
        CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
        CLLocation *storeLocation = [[CLLocation alloc]initWithLatitude:location.latitude longitude:location.longitude];
        zoomLocation = location;
        popup.currentLocation = storeLocation;
        [popup prepareCallOutView:offer offerArray:offerArray];
        popup.parentViewController = self;
        CGPoint point = [self.mapView convertPoint:view.frame.origin fromView:view.superview];
        [popup  setCenter:CGPointMake(point.x+7,point.y-(self.popup.frame.size.height/2)+12)];
        [self.mapView addSubview:popup];
        
        [self.popup setHidden:NO];
        

    }
       
    //[self animateIn];
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view 
{
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.popup removeFromSuperview];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    UITouch *touch = [[event allTouches] anyObject];
    if ( touch.tapCount == 1 ) {
          
        
        }
}

@end


@implementation TransparentToolbar

// Override draw rect to avoid
// background coloring
- (void)drawRect:(CGRect)rect {
    // do nothing in here
}

// Set properties to make background
// translucent.
- (void) applyTranslucentBackground
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.translucent = YES;
}

// Override init.
- (id) init
{
    self = [super init];
    [self applyTranslucentBackground];
    return self;
}

// Override initWithFrame.
- (id) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    [self applyTranslucentBackground];
    return self;
}

@end

