//
//  DirectionViewController.m
//  Diner Club
//
//  Created by mobimac on 7/27/11.
//  Copyright 2011 Mobiquest Pte Ltd. All rights reserved.
//

#import "DirectionViewController.h"
#import "TouchXML.h"
#import "RegexKitLite.h"
#import "Location.h"
//#import "SearchDetailViewController.h"
//#import "constant.h"
//#import "AdvanceDetailBean.h"
//#import "Diner_ClubAppDelegate.h"

@implementation DirectionViewController

/*App *appDelegate;
SearchDetailViewController *objSearchDetailVC;
AdvanceDetailBean *objDetailBean;
*/
/*
- (void)setObject:(id)sender {
	objSearchDetailVC = sender;
}

- (void)setBean:(id)sender {
	objDetailBean = sender;
}
 */

#define fontType @"Helvetica-Bold"
#define googleMapApi @"http://maps.googleapis.com/maps/api/directions/xml?origin=%f,%f&destination=%f,%f&waypoints=&sensor=false&mode=%@"


- (void)setLat:(NSString*)lat setLong:(NSString*)lang {
	restLat = [lat floatValue];
	restLong = [lang floatValue];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
	//appDelegate = (Diner_ClubAppDelegate*)[[UIApplication sharedApplication] delegate];
	backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self
															action:@selector(onCLickBackBtn:)];
	self.navigationItem.leftBarButtonItem = backBtn;
	self.navigationItem.hidesBackButton = TRUE;
	
	arrDirectionText = [[NSMutableArray alloc] init];
	arrDistance = [[NSMutableArray alloc] init];
	
	UIImage* mapImg = [UIImage imageNamed:@"Map_off.png"];
	mapTab = [[UITabBarItem alloc] initWithTitle:@"Map" image:mapImg tag:0];
	
	UIImage* addressImg = [UIImage imageNamed:@"Address_off.png"];
	addressTab = [[UITabBarItem alloc] initWithTitle:@"Address" image:addressImg tag:1];
	
	UIImage* shareImg = [UIImage imageNamed:@"Share_off.png"];
	shareTab = [[UITabBarItem alloc] initWithTitle:@"Share" image:shareImg tag:2];
	
	UIImage* searchImg = [UIImage imageNamed:@"Search_off.png"];
	searchTab = [[UITabBarItem alloc] initWithTitle:@"Search" image:searchImg tag:3];
	[tabBar setItems:[NSArray arrayWithObjects:mapTab,addressTab,shareTab,searchTab,nil]];
	
	strLeft = @"left";
	strRight = @"right";
	strMerge = @"merge";
	strContinue = @"Continue";
	strMerge1 = @"Merge";
}

- (void)viewWillAppear:(BOOL)animated {
	locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
	[locationManager startUpdatingLocation];
	
    mapflag = FALSE;
    imgCounter = 0;
    
	FontLabel *fl;
	for (UIView *v in [scrollView subviews]) {
		if ([v isKindOfClass:[FontLabel class]]) {
			fl = (FontLabel *)v;
			[fl removeFromSuperview];
		}
	}
	
	UIImageView *im;
	for (UIView *v in [scrollView subviews]) {
		if ([v isKindOfClass:[UIImageView class]]) {
			im = (UIImageView *)v;
			[im removeFromSuperview];
		}
	}
	[indiCator removeFromSuperview];
	
	
	loadingImg = [[UIImageView alloc] initWithFrame:CGRectMake(84,110,151,54)];
	[loadingImg setImage:[UIImage imageNamed:@"LoadingImage.png"]];
	[scrollView addSubview:loadingImg];
	
	indiCator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(150,115,20,20)];
	indiCator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
	indiCator.hidesWhenStopped = TRUE;
	[scrollView addSubview:indiCator];
	
	routeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mapView.frame.size.width, mapView.frame.size.height)];
	routeView.userInteractionEnabled = NO;
	lineColor = [UIColor blueColor];
	[mapView addSubview:routeView];	
	
	//lblTitle = [[FontLabel alloc] initWithFrame:CGRectMake(20,4,280,21)
	///											  fontName:fontType pointSize:16.0];
	[lblTitle setBackgroundColor:[UIColor clearColor]];
	//[lblTitle setFont:[UIFont fontWithName:fontType size:16.0]];
	[lblTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
	[lblTitle setTextColor:[UIColor colorWithRed:1.0/255.0 green:102.0/255.0 blue:206.0/255.0 alpha:1.0]];
	[scrollView addSubview:lblTitle];
	[lblTitle release];
	
	lblAddress = [[FontLabel alloc] initWithFrame:CGRectMake(20,23,204,39)
													 fontName:fontType pointSize:14.0];
	[lblAddress setBackgroundColor:[UIColor clearColor]];
	//[lblAddress setFont:[UIFont fontWithName:fontType size:14.0]];
	[lblAddress setNumberOfLines:0];
	[lblAddress setTextColor:[UIColor lightGrayColor]];
	[scrollView addSubview:lblAddress];
	[lblAddress release];
	
	//[self getDirection];
	
	[tabBar setSelectedItem:[tabBar.items objectAtIndex:0]];
	[scrollView setContentSize:CGSizeMake(320,mapView.frame.origin.y+mapView.frame.size.height + 15)];
	
	[indiCator startAnimating];
	loadingImg.hidden = FALSE;
	
	//lblTitle.text = objDetailBean.strMerchantName;
	//lblAddress.text = objDetailBean.strAddress;	
}

- (void)locationManager:(CLLocationManager *)manager
	 didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    /*user_lat = -33.8589009;
    user_long = 151.2070914;
     
    appDelegate.lattitude = -33.8589009;
    appDelegate.longitude = 151.2070914;*/
    
	user_lat = newLocation.coordinate.latitude;
    user_long = newLocation.coordinate.longitude;
    
	//appDelegate.lattitude = newLocation.coordinate.latitude;
	//appDelegate.longitude = newLocation.coordinate.longitude;
    
	[locationManager stopUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated {
	[self showRoute];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
	if (item.tag == 0) {
		//objSearchDetailVC.tabIndex = 0;
	}
	if (item.tag == 1) {
		//objSearchDetailVC.tabIndex = 1;
		[self.navigationController popViewControllerAnimated:YES];
	}
	if (item.tag == 2) {
		//objSearchDetailVC.tabIndex = 2;
		[self.navigationController popViewControllerAnimated:YES];
	}
	if (item.tag == 3) {
		[self.navigationController popToRootViewControllerAnimated:YES];
	}
}

- (void)onCLickBackBtn:(id)sender {
	
	routeView.hidden = TRUE;
	[mapView removeAnnotations:mapView.annotations];
	[self.navigationController popViewControllerAnimated:YES];
	
}

-(void)viewWillDisappear:(BOOL)animated {
	[routeView removeFromSuperview];
	[mapView removeAnnotations:mapView.annotations];
}

#pragma mark
#pragma mark Current Location Methods

- (CLLocationCoordinate2D) currentLocation {
	CLLocationCoordinate2D location;
    location.latitude = -33.8589009;
	location.longitude  = 151.2070914;
    
	//location.latitude = [[Location sharedInstance] currentLocation].coordinate.latitude;
	//location.longitude = [[Location sharedInstance] currentLocation].coordinate.longitude;;
	
	return location;
}

- (CLLocationCoordinate2D) addressLocation {
	CLLocationCoordinate2D location;
	location.latitude = restLat;
	location.longitude = restLong;
	return location;
}

- (void)getDirection 
{	
	strMode = @"driving";
	NSString *lat=[NSString stringWithFormat:@"%lf",[[Location sharedInstance] currentLocation].coordinate.latitude];
    NSString *lon=[NSString stringWithFormat:@"%lf",[[Location sharedInstance] currentLocation].coordinate.longitude];
	//NSString *strUrl = [NSString stringWithFormat:googleMapApi,lat,lon,restLat,restLong,strMode];
	NSString *strUrl = @"http://maps.googleapis.com/maps/api/directions/xml?origin=-33.868900,151.207092&destination=-33.868904,151.206238&waypoints=&sensor=false&mode=driving";
	
	NSURL *url = [NSURL URLWithString:strUrl];
	NSLog(@"\n URL >> %@",url);
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];	
	if( theConnection ) {		
		webData = [[NSMutableData data] retain];
	}
	else {
		NSLog(@"theConnection is NULL");
	}
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
	webData = [[NSMutableData data] retain];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	UIAlertView *connectionAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Internet / Service Connection Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[connectionAlert show];
	[connectionAlert release];
	[connection release];
	[webData release];
	return;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSString *theXML = [[NSString alloc] initWithBytes:[webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	//NSLog(@"\n>>%@>>\n",theXML);
	//[theXML release];
	
	[arrDirectionText removeAllObjects];
	[arrDistance removeAllObjects];
	
	CXMLDocument *doc = [[[CXMLDocument alloc] initWithData:webData options:0 error:nil] autorelease];
	NSArray *nodes = [doc nodesForXPath:@"//step" error:nil];
	for (CXMLElement *node in nodes) {
		for(int counter = 0; counter < [node childCount]; counter++) {
			if ([[[node childAtIndex:counter] name] isEqualToString:@"html_instructions"]) {
				NSString *strData = [[node childAtIndex:counter] stringValue];
				strData = [self flattenHTML:strData];
				//NSLog(@"StrData >> %@",strData);
				[arrDirectionText addObject:strData];
			}
		}
	}
	
	nodes = [doc nodesForXPath:@"//route" error:nil];		
	for (CXMLElement *node in nodes) {
		for(int counter = 0; counter < [node childCount]; counter++) {
			if ([[[node childAtIndex:counter] name] isEqualToString:@"summary"]) {
				strSummury = [[node childAtIndex:counter] stringValue];
			}
		}
	}
	
	NSArray *items = [doc nodesForXPath:@"//step" error:nil];
	for (CXMLElement *item in items) {
		NSArray *titles = [item elementsForName:@"distance"];
		for(CXMLElement *title in titles) {
			for(int counter = 0; counter < [title childCount]; counter++) {
				if ([[[title childAtIndex:counter] name] isEqualToString:@"text"]) {
					NSString *strDist = [[title childAtIndex:counter] stringValue];
					if (counter == 3) {
						[arrDistance addObject:strDist];
					}
				}
			}
		}
	}
	
	items = [doc nodesForXPath:@"//leg" error:nil];
	for (CXMLElement *item in items) {
		NSArray *titles = [item elementsForName:@"distance"];
		for(CXMLElement *title in titles) {
			for(int counter = 0; counter < [title childCount]; counter++) {
				if ([[[title childAtIndex:counter] name] isEqualToString:@"text"]) {
					if (counter == 3) {
						strTotalDistance = [[title childAtIndex:counter] stringValue];						
					}
				}
			}
		}
	}
	
	items = [doc nodesForXPath:@"//leg" error:nil];
	for (CXMLElement *item in items) {
		NSArray *titles = [item elementsForName:@"duration"];
		for(CXMLElement *title in titles) {
			for(int counter = 0; counter < [title childCount]; counter++) {
				if ([[[title childAtIndex:counter] name] isEqualToString:@"text"]) {
					if (counter == 3) {
						strTotalTime = [[title childAtIndex:counter] stringValue];						
					}										
				}
			}
		}
	}	
	[self updateData];
}

- (NSString *)flattenHTML:(NSString *)html {
	NSScanner *theScanner;
	NSString *text = nil;
	theScanner = [NSScanner scannerWithString:html];
	
	while ([theScanner isAtEnd] == NO) {		
		// find start of tag
		[theScanner scanUpToString:@"<" intoString:NULL] ; 		
		// find end of tag
		[theScanner scanUpToString:@">" intoString:&text] ;
		// replace the found tag with a space
		//(you can filter multi-spaces out later if you wish)
		html = [html stringByReplacingOccurrencesOfString:
				  [ NSString stringWithFormat:@"%@>", text]
															withString:@" "];		
	} // while //	
	return html;	
}

- (void)updateData {
	CGSize size;
	int yPadding = 340;
	FontLabel *lbltable;
	
	lbltable = [[FontLabel alloc] initWithFrame:CGRectMake(10,yPadding-10,300,2) 
												  fontName:fontType pointSize:12.0];
	lbltable.backgroundColor = [UIColor lightGrayColor];
	//[scrollView addSubview:lbltable];
	//[lbltable release];
	
	
	UIImageView *imgA = [[UIImageView alloc] initWithFrame:CGRectMake(15,yPadding,25,37)];
	[imgA setImage:[UIImage imageNamed:@"A.png"]];
	[scrollView addSubview:imgA];[imgA release];
	
	size = [strSummury sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(140,499) lineBreakMode:UILineBreakModeWordWrap];	
	FontLabel *start = [[FontLabel alloc] initWithFrame:CGRectMake(45,yPadding,size.width,size.height)
															 fontName:fontType pointSize:14.0];
	[start setBackgroundColor:[UIColor clearColor]];
	start.text = strSummury;
	start.numberOfLines = 0;
	[start setFont:[UIFont fontWithName:fontType size:14.0]];
	[start setFont:[UIFont boldSystemFontOfSize:14.0]];
	[start setTextColor:[UIColor lightGrayColor]];
	[scrollView addSubview:start];
	[start release];
	
	FontLabel *lblTotalTime = [[FontLabel alloc] initWithFrame:CGRectMake(180,yPadding-3,120,25)
																	  fontName:fontType pointSize:14.0];;
	[lblTotalTime setBackgroundColor:[UIColor clearColor]];
	lblTotalTime.text = strTotalTime;
	lblTotalTime.textAlignment = UITextAlignmentRight;
	//[lblTotalTime setFont:[UIFont fontWithName:fontType size:14.0]];
	[lblTotalTime setFont:[UIFont boldSystemFontOfSize:14.0]];
	[lblTotalTime setTextColor:[UIColor lightGrayColor]];
	[scrollView addSubview:lblTotalTime];
	[lblTotalTime release];
	
	yPadding = start.frame.origin.y + start.frame.size.height;
	
	FontLabel *lblTotalDist = [[FontLabel alloc] initWithFrame:CGRectMake(45,yPadding,80,25)
																	  fontName:fontType pointSize:14.0];;
	[lblTotalDist setBackgroundColor:[UIColor clearColor]];
	lblTotalDist.text = strTotalDistance;
	[lblTotalDist setFont:[UIFont fontWithName:fontType size:14.0]];
	[lblTotalDist setFont:[UIFont boldSystemFontOfSize:14.0]];
	[lblTotalDist setTextColor:[UIColor lightGrayColor]];
	[scrollView addSubview:lblTotalDist];
	[lblTotalDist release];
	
	yPadding = lblTotalDist.frame.origin.y + lblTotalDist.frame.size.height;
	
	for (int i = 0; i < [arrDistance count]; i++) {
		
		size = [[arrDirectionText objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:CGSizeMake(260,999) lineBreakMode:UILineBreakModeWordWrap];
		/*FontLabel *lbl = [[FontLabel alloc] initWithFrame:CGRectMake(40,yPadding+4,size.width,size.height)
															  fontName:fontType pointSize:14.0];*/
		
		FontLabel *lbl = [[FontLabel alloc] initWithFrame:CGRectMake(40,yPadding+4,size.width - 50 ,size.height + 25)
												 fontName:fontType pointSize:14.0];
		
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setFont:[UIFont fontWithName:fontType size:14.0]];
		[lbl setNumberOfLines:0];
		lbl.text = [arrDirectionText objectAtIndex:i];
		
		UIImage *img = [UIImage imageNamed:@"1.png"];
		NSRange range = [[arrDirectionText objectAtIndex:i] rangeOfString:strLeft];
		if (range.location != NSNotFound) {
			img = [UIImage imageNamed:@"3.png"];
		} 
		
		 range = [[arrDirectionText objectAtIndex:i] rangeOfString:strRight];
		if (range.location != NSNotFound) {
			img = [UIImage imageNamed:@"2.png"];
		}
		
		 range = [[arrDirectionText objectAtIndex:i] rangeOfString:strMerge];
		if (range.location != NSNotFound) {
			img = [UIImage imageNamed:@"4.png"];
		} 
		
		 range = [[arrDirectionText objectAtIndex:i] rangeOfString:strMerge1];
		if (range.location != NSNotFound) {
			img = [UIImage imageNamed:@"4.png"];
		} 
		
		 range = [[arrDirectionText objectAtIndex:i] rangeOfString:strContinue];
		if (range.location != NSNotFound) {
			img = [UIImage imageNamed:@"1.png"];
		} 
		
		[lbl setTextColor:[UIColor lightGrayColor]];
		[scrollView addSubview:lbl];
		[lbl release];
		
		UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(15,yPadding+4,21,21)];
		[imgArrow setImage:img];
		[scrollView addSubview:imgArrow];[imgArrow release];
		
		yPadding = yPadding + lbl.frame.size.height + 25;
		FontLabel *lblDist = [[FontLabel alloc] initWithFrame:CGRectMake(245,yPadding-20,55,25)
																	fontName:fontType pointSize:14.0];
		[lblDist setBackgroundColor:[UIColor clearColor]];
		[lblDist setFont:[UIFont fontWithName:fontType size:14.0]];
		[lblDist setNumberOfLines:1];
		lblDist.text = [arrDistance objectAtIndex:i];
		[lblDist setTextColor:[UIColor lightGrayColor]];
		[scrollView addSubview:lblDist];
		[lblDist release];
		
		FontLabel *lblLine = [[FontLabel alloc] initWithFrame:CGRectMake(10,yPadding,300,2)
																	fontName:fontType pointSize:14.0];
		[lblLine setBackgroundColor:[UIColor lightGrayColor]];
		[scrollView addSubview:lblLine];
		[lblLine release];
	}
	
	UIImageView *imgB = [[UIImageView alloc] initWithFrame:CGRectMake(15,yPadding+15,25,37)];
	[imgB setImage:[UIImage imageNamed:@"B.png"]];
	[scrollView addSubview:imgB];[imgB release];
	
	FontLabel *end = [[FontLabel alloc] initWithFrame:CGRectMake(45,yPadding,240,70)
														  fontName:fontType pointSize:14.0];
	[end setBackgroundColor:[UIColor clearColor]];
	end.numberOfLines = 3;
	[end setFont:[UIFont boldSystemFontOfSize:14.0]];
	[end setTextColor:[UIColor lightGrayColor]];
	/*NSString *strText = [NSString stringWithFormat:@"%@\n%@",objDetailBean.strMerchantName,objDetailBean.strAddress];
	strText = [strText stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
	end.text = strText;
	[scrollView addSubview:end];*/
	//[end release];	
	
	lbltable = [[FontLabel alloc] initWithFrame:CGRectMake(10,330,2,end.frame.origin.y-270) 
												  fontName:fontType pointSize:12.0];
	lbltable.backgroundColor = [UIColor lightGrayColor];
	//[scrollView addSubview:lbltable];
	//[lbltable release];
	
	lbltable = [[FontLabel alloc] initWithFrame:CGRectMake(310,330,2,end.frame.origin.y-270) 
												  fontName:fontType pointSize:12.0];
	lbltable.backgroundColor = [UIColor lightGrayColor];
	//[scrollView addSubview:lbltable];
	//[lbltable release];
	
	lbltable = [[FontLabel alloc] initWithFrame:CGRectMake(10,yPadding+end.frame.size.height-10,302,2) 
												  fontName:fontType pointSize:12.0];
	lbltable.backgroundColor = [UIColor lightGrayColor];
	//[scrollView addSubview:lbltable];
	//[lbltable release];
	
	scrollView.contentSize = CGSizeMake(320,yPadding + 70);
}

#pragma mark
#pragma mark Show routeView Methods

- (void) showRoute {	
    
	MKCoordinateSpan span;
	span.latitudeDelta = 0.0005;
	span.longitudeDelta = 0.0005;
    
	[mapView setMapType:MKMapTypeStandard];	
    currentLocation1 = [self currentLocation];
	
	MKCoordinateRegion region;
    ann = [[MyAnnotation alloc] init];
	ann.title = @"Current Location";
	
	region.center = currentLocation1; 
	ann.coordinate = region.center;
	[mapView addAnnotation:ann];
    [self performSelector:@selector(secondAnnCall) withObject:nil afterDelay:0.7];
}

- (void)secondAnnCall {
    givenLocation1 = [self addressLocation];
    MKCoordinateRegion region;
        
    annSecond = [[MyAnnotation alloc] init];
	region.center = givenLocation1;
	//annSecond.title = objDetailBean.strMerchantName;
	
	annSecond.coordinate = region.center;
	[mapView addAnnotation:annSecond];
	//[mapView setRegion:region animated:TRUE];
	routes = [[self calculateRoutesFrom:currentLocation1 to:givenLocation1] retain];
    [self getDirection];
	[self updateRouteView];
}

#pragma mark 
#pragma mark Get Direction Methods

//http://maps.googleapis.com/maps/api/directions/xml?origin=Boston,MA&destination=Concord,MA&waypoints=Charlestown,MA|Lexington,MA&sensor=false 


- (NSMutableArray *)decodePolyLine: (NSMutableString *)encoded {
	[encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
											options:NSLiteralSearch
											range:NSMakeRange(0, [encoded length])];
	NSInteger len = [encoded length];
	NSInteger index = 0;
	NSMutableArray *array = [[NSMutableArray alloc] init];
	NSInteger lat=0;
	NSInteger lng=0;
	while (index < len) {
		NSInteger b;
		NSInteger shift = 0;
		NSInteger result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lat += dlat;
		shift = 0;
		result = 0;
		do {
			b = [encoded characterAtIndex:index++] - 63;
			result |= (b & 0x1f) << shift;
			shift += 5;
		} while (b >= 0x20);
		NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
		lng += dlng;
		NSNumber *latitude = [[[NSNumber alloc] initWithFloat:lat * 1e-5] autorelease];
		NSNumber *longitude = [[[NSNumber alloc] initWithFloat:lng * 1e-5] autorelease];
		
		CLLocation *loc = [[[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]] autorelease];
		[array addObject:loc];
	}
	return array;
}

- (NSArray*) calculateRoutesFrom:(CLLocationCoordinate2D) f to: (CLLocationCoordinate2D) t {
	NSError* error;
	
	NSString* saddr = [NSString stringWithFormat:@"%f,%f", f.latitude, f.longitude];
	NSString* daddr = [NSString stringWithFormat:@"%f,%f", t.latitude, t.longitude];
	NSString* apiUrlStr = [NSString stringWithFormat:@"http://maps.google.com/maps?output=dragdir&saddr=%@&daddr=%@", saddr, daddr];

	NSURL* apiUrl = [NSURL URLWithString:apiUrlStr];
	NSString *apiResponse = [NSString stringWithContentsOfURL:apiUrl encoding:NSASCIIStringEncoding error:&error];
	NSString* encodedPoints = [apiResponse stringByMatching:@"points:\\\"([^\\\"]*)\\\"" capture:1L];
	
	routes = [self decodePolyLine:[encodedPoints mutableCopy]];
	[self updateRouteView];
	[self centerMap];
	return routes;
}

- (void) centerMap {
	@try {
        MKCoordinateRegion region;
        
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
        
        for(int idx = 0; idx < routes.count; idx++) {
            CLLocation* currentLocation = [routes objectAtIndex:idx];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        
        region.center.latitude = (maxLat + minLat) / 2;
        region.center.longitude = (maxLon + minLon) / 2;
        region.span.latitudeDelta = maxLat - minLat;
        region.span.longitudeDelta = maxLon - minLon;	 
        [mapView setRegion:region animated:YES];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception >>> %@",exception);
    }
    @finally {
        
    }
}

- (void) updateRouteView {
	CGContextRef context = 	CGBitmapContextCreate(nil, 
																 routeView.frame.size.width, 
																 routeView.frame.size.height, 
																 8, 
																 4 * routeView.frame.size.width,
																 CGColorSpaceCreateDeviceRGB(),
																 kCGImageAlphaPremultipliedLast);
	
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
	CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
	CGContextSetLineWidth(context, 3.0);
	
	for(int i = 0; i < routes.count; i++) {
		CLLocation* location1 = [routes objectAtIndex:i];
		CGPoint point = [mapView convertCoordinate:location1.coordinate toPointToView:routeView];
		if(i == 0) {
			CGContextMoveToPoint(context, point.x, routeView.frame.size.height - point.y);
		} else {
			CGContextAddLineToPoint(context, point.x, routeView.frame.size.height - point.y);
		}
	}
	
	CGContextStrokePath(context);
	CGImageRef image = CGBitmapContextCreateImage(context);
	UIImage* img = [UIImage imageWithCGImage:image];
	
	routeView.image = img;
	CGContextRelease(context);
}

# pragma mark -
# pragma mark mapView delegate methods 

- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation {
	/*static NSString *defaultPinID = @"com.invasivecode.pin";
	MKPinAnnotationView *pinView  = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
	pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];
	pinView.pinColor = MKPinAnnotationColorPurple;
	
	//pinView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	//pinView.rightCalloutAccessoryView.tag = 101;
	
	pinView.canShowCallout = YES;
	pinView.animatesDrop = YES;*/
	
	/*UIImage *image = [[UIImage alloc] init];
    if (appDelegate.lattitude == user_lat && imgCounter == 0) {
        image = [UIImage imageNamed:@"A.png"];
        imgCounter = 1;
    }
    else  {        
        [indiCator stopAnimating];
        loadingImg.hidden = TRUE;        
        image = [UIImage imageNamed:@"B.png"];
    }*?
	/*if (imgCounter == 1) {
		image = [UIImage imageNamed:@"A.png"];
	} 
	if (imgCounter == 2) {
		image = [UIImage imageNamed:@"B.png"];
		imgCounter = 0;
	}*/
	
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:image];	
    MKPinAnnotationView *pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
   // [pinView addSubview:imageView];
    return pinView;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
	routeView.hidden = YES;
}

- (void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated {
	[self updateRouteView];
	routeView.hidden = NO;
	[routeView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
