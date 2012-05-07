//
//  AppDelegate.m
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "CustomARViewController.h"
#import "ListViewController.h"
#import "MapViewController.h"
#import "BookMarkViewController.h"
#import "pARkViewController.h"
#import "ShopList.h"
#import "Offer.h"
#import"Categories.h"
#import "Constants .h"
#import <QuartzCore/QuartzCore.h>

@implementation AppDelegate


@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjectModel,managedObjectContext,persistentStoreCoordinator,filterString,arraySelectedCategories,arraySelectedSubCategories,splashView,isFilterOn,arrayStoreIds,bookmarkviewController,lastmerchantsynceddate,offerDataArray,poiDataDictionary,offerType,listViewDataArray,ginzaEvents,isSyncON,arviewController;
@synthesize subCategoriesArray;

//test
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    isSyncON = NO;
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"filtersetting.plist"]; //3
    self.isFilterOn =@"0";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"filtersetting" ofType:@"plist"]; //5
        
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    isFilterOn = [savedStock objectForKey:@"filterall"];
    NSString *lastSyncedDate = [savedStock objectForKey:@"lastsynceddate"];
    self.lastmerchantsynceddate =[savedStock objectForKey:@"lastmerchantsynceddate"];
    if (lastSyncedDate ==nil) {
        lastSyncedDate = @"";
    }
    
    if (self.lastmerchantsynceddate ==nil) {
        self.lastmerchantsynceddate = @"";
    }
    NSLog(@"lastSyncedDate = %@",self.lastmerchantsynceddate);
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.arraySelectedCategories =[[NSMutableArray alloc]init ];
    filterString =@"";
    
    [self getOfferData];
    self.poiDataDictionary = [self getPointOfInterestItems];
    [self getListViewData];
    [self getGinzaEvents];
    
        
    
    NSString *URLString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"]];
    BOOL val =  ( URLString != NULL ) ? YES : NO;
    if (! val) {
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Internet Required" message:@"Please choose internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
    }
    
    else
    {
        // splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        //UIActivityIndicatorView *myIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //myIndicator.center = CGPointMake(160, 240);
        //myIndicator.hidesWhenStopped = NO;
        
        //splashView.image = [UIImage imageNamed:@"Default.png"];
        //[self.window addSubview:splashView];
        //[self.window addSubview:myIndicator];
        //[self.window bringSubviewToFront:splashView];
        //[self.window bringSubviewToFront:myIndicator];
        //[myIndicator startAnimating];
        
        //dispatch_async(kBgQueue, ^{
        //[self fetchCategoryData];
        //       
        // NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://staging.citiworldprivileges.com/mobile/ginza-promotions/shop-list/?created_on=2012-03-02"]];
        //[self performSelectorOnMainThread:@selector(fetchedData:) 
        //                 withObject:data waitUntilDone:NO];
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Data Fetch started %@",[NSDate date]);
        @try {
            [self fetchOfferData:lastSyncedDate];
            
            //[self performSelectorInBackground:@selector(fetchOfferData:) withObject:lastSyncedDate];
            NSLog(@"fetch offers");
            
        }
        @catch (NSException *exception) {
                   }
        @finally {
        }
        
        
        @try {
            [self fetchCategoryData];
            
            //[self performSelectorInBackground:@selector(fetchCategoryData) withObject:nil];
            NSLog(@"fetch categories");
        }
        @catch (NSException *exception) {
            NSLog(@"fecth Category data %@",exception);
        }
        @finally {
           
        }
            if (isSyncON) {

                [self performSelectorInBackground:@selector(refreshData) withObject:nil];
            }
              
            
      });
         NSLog(@"Data Fetch ended %@",[NSDate date]);
    }
    
   
    NSLog(@"End");
    self.arviewController = [[pARkViewController alloc] initWithNibName:@"pARkViewController_iPhone" bundle:nil];

    
    UINavigationController *navigation1 = [[UINavigationController alloc]initWithRootViewController:self.arviewController];
    
    
   // UIViewController *listviewController = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    
    UIViewController* listviewController = [[ListViewController alloc] 
                                      initWithNibName:@"ListViewController" bundle:nil];

    
    UINavigationController *navigation2 = [[UINavigationController alloc]initWithRootViewController:listviewController];
    
    
    UIViewController *mapviewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    
    
    UINavigationController *navigation3 = [[UINavigationController alloc]initWithRootViewController:mapviewController];
    
    
    self.bookmarkviewController = [[BookMarkViewController alloc] initWithNibName:@"BookMarkViewController" bundle:nil];
    
    UINavigationController *navigation4 = [[UINavigationController alloc]initWithRootViewController:self.bookmarkviewController];
    if([[self getBookmarkOfferData]count]>0)
    {
         self. bookmarkviewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", [[self getBookmarkOfferData]  count]];    
    }
                                  
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:navigation1, navigation2,navigation3,navigation4, nil];
    
    //self.tabBarController.viewControllers = [NSArray arrayWithObjects: navigation2,navigation3, nil];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}
-(void)refreshData
{
    NSLog(@"assign offers");
    [self getOfferData];
    NSLog(@"assign pois");
    self.poiDataDictionary = [self getPointOfInterestItems];
    NSLog(@"assign list view data");
    [self getListViewData];
    NSLog(@"assign events");
    [self getGinzaEvents];

}

-(NSMutableArray *)getSubCategories:(NSString *)parent
{
    NSError* error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:context];
    [request setEntity:entity];
  
    NSLog(@"Parent = %@",parent);
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"parent == %@",parent];
    
    [request setPredicate:predicate];
    self.arraySelectedCategories =[[NSMutableArray alloc]init ];
    NSMutableArray *array = (NSMutableArray *)[managedObjectContext executeFetchRequest:request error:&error];
    for (int index=0; index<[array count]; index++) {
        Categories *cat =[array objectAtIndex:index];
        if ([cat.selected isEqualToString:@"1"]) {
            [self.arraySelectedCategories addObject:cat.category_id];
        }
        
    }    
    return array;
}

-(NSMutableArray *)getSubCategories
{
    NSError* error;
   
    NSManagedObjectContext *context =managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:context];
    [request setEntity:entity];
    
   
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"parent >0"];
    
    [request setPredicate:predicate];
    
    NSMutableArray *array = (NSMutableArray *)[managedObjectContext executeFetchRequest:request error:&error];
    for (int index=0; index<[array count]; index++) {
        Categories *cat =[array objectAtIndex:index];
        if ([cat.selected isEqualToString:@"1"]) {
            [self.arraySelectedCategories addObject:cat.category_id];
        }
        
    }   
    self.subCategoriesArray=array;
    return array;
}


-(NSMutableArray *)getCategories
{
     NSLog(@"fetch categories data");
    NSError* error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSString *str =[NSString stringWithFormat:@"parent == '0'"];// %@",filterString];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:str];
    
    [request setPredicate:predicate];
    
    NSMutableArray *array = (NSMutableArray *)[managedObjectContext executeFetchRequest:request error:&error];
    
    
   
    
    for (int index=0; index<[array count]; index++) {
        Categories *cat =[array objectAtIndex:index];
        if ([cat.selected isEqualToString:@"1"]) {
            [self.arraySelectedCategories addObject:cat.category_id];
        }
        
    }    
    return array;
    
    
    
}




-(ShopList *)getStoreDataById:(NSString *)storeid
{
    NSError* error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShopList" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"store_id == %@ ", storeid];
    
    [request setPredicate:predicate];
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    ShopList *shopDetail;
    if ([array count]>0) {
        
        shopDetail = [array objectAtIndex:0];
        //NSLog(@"array = %@, %@",shopDetail.store_id, shopDetail.store_name);
    }
    return shopDetail;
}

-(Offer *)getOfferDataById:(NSString *)offer_id
{
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [request setEntity:entity];
   
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"id == %@  && store_id >0", offer_id];
    
    [request setPredicate:predicate];
    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    Offer *offer;
    if ([array count]>0) {
        offer = [array objectAtIndex:0];
    }
    return offer;

}


-(Categories *)getCategoryDataById:(NSString *)category_id
{
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"category_id == %@ ", category_id];
    
    [request setPredicate:predicate];    
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    Categories *category;
    if ([array count]>0) {
        category = [array objectAtIndex:0];
    }
    return category;
    
}
-(NSMutableArray *)getGinzaEvents
{
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"offer_type == 'event'"];
    
    [request setPredicate:predicate];
    
    self.ginzaEvents = (NSMutableArray *)[managedObjectContext executeFetchRequest:request error:&error];

    return self.ginzaEvents;
}

-(NSMutableArray *)getServices
{
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"offer_type == 'service'"];
    
    [request setPredicate:predicate];
    
    NSMutableArray *array = (NSMutableArray *)[managedObjectContext executeFetchRequest:request error:&error];
    
    return array;
}

-(NSMutableArray *)getOfferData
{
    
    NSLog(@"Assign offer data start %@",[NSDate date]);
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [request setEntity:entity];
     NSString *predicateString = @"store_id > 0";
    /*if ([isFilterOn intValue]==1) {
        filterString = [self getFilterString];
         
        if ([filterString length]>0) {
            filterString = [filterString substringToIndex:[filterString length] - 2];
            NSLog(@"isFilter = %@,%@",isFilterOn,filterString);
           //predicateString = [NSString stringWithFormat:@"Offer.store_id > 0 && Offer.store_id == ShopList.store_id" ];
        }
        
    }*/
    
    
       NSPredicate *predicate =
    [NSPredicate predicateWithFormat:predicateString];
    
    [request setPredicate:predicate];
    
    NSMutableArray *array = (NSMutableArray *)[managedObjectContext executeFetchRequest:request error:&error];
    self.offerDataArray = array;
     NSLog(@"Assign offer data end %d",[array count]);
    return array;
    
}

-(NSString *)getFilterString
{
  NSString *filterString1= [[[NSString alloc]init]retain];
    
    NSMutableArray *catArray =  [self getCategories];
    for (Categories *cat in catArray) {
        NSLog(@"parent =%@",cat.parent);
        NSString *value;
        if ([cat.parent isEqualToString:@"0"]) {
            //value = [NSString stringWithFormat:@"%@-%@",cat.parent];
        }
        if ([cat.selected isEqualToString:@"1"]) {
            
            filterString1 = [filterString1 stringByAppendingFormat:@"category =%@ ||",cat.category_id ];
            
        }
        else {
            filterString1 = [filterString1 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"|| category =%@ ",cat.category_id ] withString: @""];
        }

    }
    catArray = [self getSubCategories];
    for (Categories *cat in catArray) {
        NSLog(@"selected =%@",cat.selected);
        if ([cat.selected isEqualToString:@"1"]) {
            filterString1 = [filterString1 stringByAppendingFormat:@"%@-%@ ||",cat.parent, cat.category_id ];
            
        }
        else {
            filterString1 = [filterString1 stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"|| %@-%@ ",cat.parent, cat.category_id ] withString: @""];
        }
        
    }

    
        
    //[appDeligate getCategories];
    NSLog(@"filterString = %@",filterString1);
    return filterString1;

}
-(NSMutableArray *)getBookmarkOfferData
{
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"isbookmark == 1"];
    
    [request setPredicate:predicate];
    
    NSMutableArray *array = (NSMutableArray *)[managedObjectContext executeFetchRequest:request error:&error];
    
    
    
    return array;
    
}

-(void)fetchMerchantData:(NSData *)responseData{
    
    NSLog(@"fetch merchant data");
       
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    //NSFetchRequest *request = [[NSFetchRequest alloc] init];

    NSArray* json = [NSJSONSerialization 
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions 
                     error:&error];
    NSLog(@"%@",[error userInfo]);
    NSArray *dataArray = json;
    
    NSLog(@" offer data count = %d",[dataArray count]);
    
    int g=0;
    
    //for (int j=0; j<2; j++)
    {
        for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            int count =0;
            if (count==0) {
                g++;
                
                NSManagedObject *datas;
                
                NSLog(@"Merchant  data %d",i);
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"ShopList" inManagedObjectContext:context];
                
                [datas setValue:[data objectForKey:@"address"] forKey:@"address"];
                [datas setValue:[data objectForKey:@"area"] forKey:@"area"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                [datas setValue:[data objectForKey:@"holiday"] forKey:@"holiday"];
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"is_child"] forKey:@"is_child"];
                [datas setValue:[data objectForKey:@"is_lunch"] forKey:@"is_lunch"];
                [datas setValue:[data objectForKey:@"is_private"] forKey:@"is_private"];
                [datas setValue:[data objectForKey:@"latitude"] forKey:@"latitude"];
                [datas setValue:[data objectForKey:@"longitude"] forKey:@"longitude"];
                [datas setValue:[data objectForKey:@"store_name"] forKey:@"store_name"];
                [datas setValue:[data objectForKey:@"url"] forKey:@"url"];
                [datas setValue:[data objectForKey:@"phone"] forKey:@"phone"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                [datas setValue:[data objectForKey:@"sub_category"] forKey:@"sub_category"];

                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@", [error userInfo]);
                }
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
                NSString *documentsDirectory = [paths objectAtIndex:0]; //2
                NSString *path = [documentsDirectory stringByAppendingPathComponent:@"filtersetting.plist"]; //3
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                if (![fileManager fileExistsAtPath: path]) //4
                {
                    NSString *bundle = [[NSBundle mainBundle] pathForResource:@"filtersetting" ofType:@"plist"]; //5
                    
                    [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
                }
                
                
                NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
                [data setObject:self.lastmerchantsynceddate forKey:@"lastmerchantsynceddate"];
                
                [data writeToFile: path atomically:YES]; 
            }    
            
        }
    }
    
    
    
}

-(void)fetchOfferData:(NSString *)lastSyncedDate{
    int c=0;
    NSLog(@"fetch offer data");
    NSString *urlString = @"";
    if ([lastSyncedDate length]==0) {
        urlString = [NSString stringWithFormat:@"%@/offers/",dataURL];
    }else
    {
        urlString = [NSString stringWithFormat:@"%@/offers/?created_on=%@",dataURL,lastSyncedDate];
    }
    
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    NSLog(@"fetch offer data1");
    // Check if the data length is zero return. This means their is no new offers available in the online database     
    if (responseData.length<=0) {
        NSLog(@"fetch offer data 2");
        return;
    }
    isSyncON = YES;
    NSLog(@"fetch offer data 3");
    NSError *error;
    NSArray* json = [NSJSONSerialization 
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions 
                     error:&error];
    
        
    
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
    [request setEntity:entity];

    
    NSArray *dataArray = json;
    
     UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"Total No of offer fetched" message:[NSString stringWithFormat:@"%d",[dataArray count]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    [alert1 show];
    NSLog(@" offer data count = %d",[dataArray count]);
    
    int g=0;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"filtersetting.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"filtersetting" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }

    
    //for (int j=0; j<2; j++)
    {
        for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            int count =0;
            if (count==0) {
                g++;
                c++;
                NSManagedObject *datas;
                
                NSLog(@"Offer data %d",i);
                if (i==40) {
                    //return;
                }
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"Offer" inManagedObjectContext:context];
                
               
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"copy_text"] forKey:@"copy_text"];
                [datas setValue:[data objectForKey:@"created_by"] forKey:@"created_by"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                lastSyncedDate = [data objectForKey:@"created_on"];
                [datas setValue:[data objectForKey:@"end_date"] forKey:@"end_date"];
                [datas setValue:[data objectForKey:@"image_name"] forKey:@"image_name"];
                [datas setValue:[data objectForKey:@"image_position"] forKey:@"image_position"];
                [datas setValue:[data objectForKey:@"lead_text"] forKey:@"lead_text"];
                [datas setValue:[data objectForKey:@"offer_id"] forKey:@"offer_id"];
                [datas setValue:[data objectForKey:@"offer_title"] forKey:@"offer_title"];
                [datas setValue:[data objectForKey:@"offer_type"] forKey:@"offer_type"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                [datas setValue:[data objectForKey:@"start_date"] forKey:@"start_date"];
                 [datas setValue:[data objectForKey:@"free_text"] forKey:@"free_text"];
                               
                [self.arrayStoreIds addObject:[data objectForKey:@"store_id"] ];
                [self storeMerchantData:[data objectForKey:@"store_id"]];
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@", [error userInfo]);
                }
               
            }   
            
            NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
            [data1 setObject:lastSyncedDate forKey:@"lastsynceddate"];
            
            [data1 writeToFile: path atomically:YES];
            
        }
    }
   
}

-(void)storeMerchantData:(NSString *)store_id
{
    
    NSString *url =[NSString stringWithFormat:@"%@/shop-list/?store_id=%@",dataURL,store_id];
    NSLog(@"Store data %@",url);
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    //NSLog(@"res %@",responseData);
    if (responseData !=nil) {
        NSError *error;
        AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context =[appDeligate managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShopList" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSArray* dataArray = [NSJSONSerialization 
                              JSONObjectWithData:responseData //1
                              
                              options:kNilOptions 
                              error:&error];
        for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            
            
            NSString *storeName = [data objectForKey:@"store_id"];
            
            
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"store_id == %@ ", storeName];
            
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
            NSUInteger count =0;
            if (array != nil) {
                count = [array count]; 
                //NSLog(@"%d",count);
            }
            else {
                // Deal with error.
            }
            
            
            if (count==0) {
                
                NSManagedObject *datas;
                
                AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context =[appDeligate managedObjectContext];
                
                NSLog(@"Merchant data %d",i);
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"ShopList" inManagedObjectContext:context];
                
                [datas setValue:[data objectForKey:@"address"] forKey:@"address"];
                [datas setValue:[data objectForKey:@"area"] forKey:@"area"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                [datas setValue:[data objectForKey:@"holiday"] forKey:@"holiday"];
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"is_child"] forKey:@"is_child"];
                [datas setValue:[data objectForKey:@"is_lunch"] forKey:@"is_lunch"];
                [datas setValue:[data objectForKey:@"is_private"] forKey:@"is_private"];
                [datas setValue:[data objectForKey:@"latitude"] forKey:@"latitude"];
                [datas setValue:[data objectForKey:@"longitude"] forKey:@"longitude"];
                [datas setValue:[data objectForKey:@"store_name"] forKey:@"store_name"];
                [datas setValue:[data objectForKey:@"url"] forKey:@"url"];
                [datas setValue:[data objectForKey:@"phone"] forKey:@"phone"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                [datas setValue:[data objectForKey:@"sub_category"] forKey:@"sub_category"];
                
                //
                
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@",error);
                }    
                
            }    
            
        }
        
    }
    
    
}



-(void)storeMerchantDatatemp:(NSString *)store_id
{
    
    NSString *url =[NSString stringWithFormat:@"%@/shop-list/?store_id=%@",dataURL,store_id];
    NSLog(@"Store data %@",url);
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    //NSLog(@"res %@",responseData);
    if (responseData !=nil) {
        NSError *error;
        AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context =[appDeligate managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShopList" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSArray* dataArray = [NSJSONSerialization 
                              JSONObjectWithData:responseData //1
                              
                              options:kNilOptions 
                              error:&error];
        for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            
            
            NSString *storeName = [data objectForKey:@"store_id"];
            
            
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"store_id == %@ ", storeName];
            
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
            NSUInteger count =0;
            if (array != nil) {
                count = [array count]; 
                //NSLog(@"%d",count);
            }
            else {
                // Deal with error.
            }
            
            
            if (count==0) {
                
                NSManagedObject *datas;
                
                AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context =[appDeligate managedObjectContext];
                
                NSLog(@"Merchant data %d",i);
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"ShopList" inManagedObjectContext:context];
                
                [datas setValue:[data objectForKey:@"address"] forKey:@"address"];
                [datas setValue:[data objectForKey:@"area"] forKey:@"area"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                [datas setValue:[data objectForKey:@"holiday"] forKey:@"holiday"];
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"is_child"] forKey:@"is_child"];
                [datas setValue:[data objectForKey:@"is_lunch"] forKey:@"is_lunch"];
                [datas setValue:[data objectForKey:@"is_private"] forKey:@"is_private"];
                [datas setValue:[data objectForKey:@"latitude"] forKey:@"latitude"];
                [datas setValue:[data objectForKey:@"longitude"] forKey:@"longitude"];
                [datas setValue:[data objectForKey:@"store_name"] forKey:@"store_name"];
                [datas setValue:[data objectForKey:@"url"] forKey:@"url"];
                [datas setValue:[data objectForKey:@"phone"] forKey:@"phone"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                [datas setValue:[data objectForKey:@"sub_category"] forKey:@"sub_category"];
                
                //
                
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@",error);
                }    
                
            }    
            
        }
        
    }
    
    
}

-(void)storeMerchantData1:(NSString *)store_id
{
   
    NSString *url =[NSString stringWithFormat:@"%@/shop-list/?store_id=%@",dataURL,store_id];
     NSLog(@"Store data %@",url);
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"res %@",responseData);
    if (responseData !=nil) {
        NSError *error;
        AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context =[appDeligate managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShopList" inManagedObjectContext:context];
        [request setEntity:entity];
        
        NSArray* dataArray = [NSJSONSerialization 
                              JSONObjectWithData:responseData //1
                              
                              options:kNilOptions 
                              error:&error];
        for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            
            
            NSString *storeName = [data objectForKey:@"store_id"];
            
            
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"store_id == %@ ", storeName];
            
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
            NSUInteger count =0;
            if (array != nil) {
                count = [array count]; 
                //NSLog(@"%d",count);
            }
            else {
                // Deal with error.
            }
            
            
            if (count==0) {

                NSManagedObject *datas;
                
                AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context =[appDeligate managedObjectContext];
                
                NSLog(@"Merchant data %d",i);
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"ShopList" inManagedObjectContext:context];
                
                [datas setValue:[data objectForKey:@"address"] forKey:@"address"];
                [datas setValue:[data objectForKey:@"area"] forKey:@"area"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                [datas setValue:[data objectForKey:@"holiday"] forKey:@"holiday"];
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"is_child"] forKey:@"is_child"];
                [datas setValue:[data objectForKey:@"is_lunch"] forKey:@"is_lunch"];
                [datas setValue:[data objectForKey:@"is_private"] forKey:@"is_private"];
                [datas setValue:[data objectForKey:@"latitude"] forKey:@"latitude"];
                [datas setValue:[data objectForKey:@"longitude"] forKey:@"longitude"];
                [datas setValue:[data objectForKey:@"store_name"] forKey:@"store_name"];
                [datas setValue:[data objectForKey:@"url"] forKey:@"url"];
                [datas setValue:[data objectForKey:@"phone"] forKey:@"phone"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                [datas setValue:[data objectForKey:@"sub_category"] forKey:@"sub_category"];
                
                //
                
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@",error);
                }    
                
            }    
            
        }

    }
    
    
}
- (void)fetchedData:(NSData *)responseData{
    NSLog(@"fetch shop data");
    NSError* error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShopList" inManagedObjectContext:context];
    [request setEntity:entity];
       
    NSArray* json = [NSJSONSerialization 
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions 
                     error:&error];
    
    NSArray *dataArray = json;
    
    int g=0;
    
    //for (int j=0; j<2; j++)
    {
        for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            
            
            NSString *storeName = [data objectForKey:@"store_id"];
            
            
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"store_id == %@ ", storeName];
            
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
            NSUInteger count =0;
            if (array != nil) {
                count = [array count]; 
                //NSLog(@"%d",count);
            }
            else {
                // Deal with error.
            }
            
            
            if (count==0) {
                g++;
                NSManagedObject *datas;
                
                AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context =[appDeligate managedObjectContext];
                
                NSLog(@"Merchant data %d",i);
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"ShopList" inManagedObjectContext:context];
                
                [datas setValue:[data objectForKey:@"address"] forKey:@"address"];
                [datas setValue:[data objectForKey:@"area"] forKey:@"area"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                [datas setValue:[data objectForKey:@"holiday"] forKey:@"holiday"];
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"is_child"] forKey:@"is_child"];
                [datas setValue:[data objectForKey:@"is_lunch"] forKey:@"is_lunch"];
                [datas setValue:[data objectForKey:@"is_private"] forKey:@"is_private"];
                [datas setValue:[data objectForKey:@"latitude"] forKey:@"latitude"];
                [datas setValue:[data objectForKey:@"longitude"] forKey:@"longitude"];
                [datas setValue:[data objectForKey:@"store_name"] forKey:@"store_name"];
                [datas setValue:[data objectForKey:@"url"] forKey:@"url"];
                [datas setValue:[data objectForKey:@"phone"] forKey:@"phone"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                [datas setValue:[data objectForKey:@"sub_category"] forKey:@"sub_category"];
                
                //
                
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@",error);
                }    
                
            }    
            
        }
    }
    
    
}



- (void)fetchedData1:(NSData *)responseData{
     NSLog(@"fetch shop data");
    NSError* error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShopList" inManagedObjectContext:context];
    [request setEntity:entity];
     
    //NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://staging.citiworldprivileges.com/mobile/ginza-promotions/shop-list/?created_on=2012-03-02"]];

    //
    //parse out the json data
   
        
    NSArray* json = [NSJSONSerialization 
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions 
                          error:&error];
    
    NSArray *dataArray = json;
    
    int g=0;
    
    //for (int j=0; j<2; j++)
    {
        for (int i=0; i<[dataArray count]; i++) {
        NSDictionary *data =[dataArray objectAtIndex:i];
        
            
            NSString *storeName = [data objectForKey:@"store_id"];
           
             
           
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"store_id == %@ ", storeName];
           
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
            NSUInteger count =0;
            if (array != nil) {
                count = [array count]; 
                //NSLog(@"%d",count);
            }
            else {
                // Deal with error.
            }
            
             
            if (count==0) {
                g++;
                NSManagedObject *datas;
                
                AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context =[appDeligate managedObjectContext];
                
                NSLog(@"Merchant data %d",i);
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"ShopList" inManagedObjectContext:context];
                
                [datas setValue:[data objectForKey:@"address"] forKey:@"address"];
                [datas setValue:[data objectForKey:@"area"] forKey:@"area"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                [datas setValue:[data objectForKey:@"holiday"] forKey:@"holiday"];
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"is_child"] forKey:@"is_child"];
                [datas setValue:[data objectForKey:@"is_lunch"] forKey:@"is_lunch"];
                [datas setValue:[data objectForKey:@"is_private"] forKey:@"is_private"];
                [datas setValue:[data objectForKey:@"latitude"] forKey:@"latitude"];
                [datas setValue:[data objectForKey:@"longitude"] forKey:@"longitude"];
                [datas setValue:[data objectForKey:@"store_name"] forKey:@"store_name"];
                [datas setValue:[data objectForKey:@"url"] forKey:@"url"];
                [datas setValue:[data objectForKey:@"phone"] forKey:@"phone"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                 [datas setValue:[data objectForKey:@"sub_category"] forKey:@"sub_category"];
                
                //
              
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@",error);
                }    

            }    
                  
           }
    }
     
    
}


- (void)fetchedData{
    NSLog(@"fetch shop data");
    NSError* error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ShopList" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/?created_on=2012-03-02",dataURL]]];
    
    //
    //parse out the json data
    
    
    NSArray* json = [NSJSONSerialization 
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions 
                     error:&error];
    
    NSArray *dataArray = json;
    
    int g=0;
    
    //for (int j=0; j<2; j++)
    {
        for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            
            
            NSString *storeName = [data objectForKey:@"store_name"];
            NSString *address = [data objectForKey:@"address"];
            NSString *latitude = [data objectForKey:@"latitude"];
            NSString *longitude = [data objectForKey:@"longitude"];
            
            
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"store_name == %@ && address = %@ && latitude = %@ && longitude = %@", storeName,address,latitude,longitude];
            
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
            NSUInteger count =0;
            if (array != nil) {
                count = [array count]; 
                //NSLog(@"%d",count);
            }
            else {
                // Deal with error.
            }
            
            
            if (count==0) {
                g++;
                NSManagedObject *datas;
                
                AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context =[appDeligate managedObjectContext];
                
                NSLog(@"Merchant data %d",i);
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"ShopList" inManagedObjectContext:context];
                
                [datas setValue:[data objectForKey:@"address"] forKey:@"address"];
                [datas setValue:[data objectForKey:@"area"] forKey:@"area"];
                [datas setValue:[data objectForKey:@"category"] forKey:@"category"];
                [datas setValue:[data objectForKey:@"created_on"] forKey:@"created_on"];
                [datas setValue:[data objectForKey:@"holiday"] forKey:@"holiday"];
                [datas setValue:[data objectForKey:@"id"] forKey:@"id"];
                [datas setValue:[data objectForKey:@"is_child"] forKey:@"is_child"];
                [datas setValue:[data objectForKey:@"is_lunch"] forKey:@"is_lunch"];
                [datas setValue:[data objectForKey:@"is_private"] forKey:@"is_private"];
                [datas setValue:[data objectForKey:@"latitude"] forKey:@"latitude"];
                [datas setValue:[data objectForKey:@"longitude"] forKey:@"longitude"];
                [datas setValue:[data objectForKey:@"store_name"] forKey:@"store_name"];
                [datas setValue:[data objectForKey:@"url"] forKey:@"url"];
                [datas setValue:[data objectForKey:@"phone"] forKey:@"phone"];
                [datas setValue:[data objectForKey:@"store_id"] forKey:@"store_id"];
                [datas setValue:[data objectForKey:@"sub_category"] forKey:@"sub_category"];
                
                //
                
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@",error);
                }    
                
            }    
            
        }
    }
    
    
}







#import "Categories.h"
-(void)fetchCategoryData{
    
    
    
    NSData* responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[ NSString stringWithFormat: @"%@/categories/?created_on=2012-03-02",dataURL]]];
    if (responseData.length<=0) {
        return;
    }
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:context];
    [request setEntity:entity];
       //parse out the json data
    
    
    NSArray* json = [NSJSONSerialization 
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions 
                     error:&error];
    
    NSArray *dataArray = json;
    
    
    
    int g=0;
    
          for (int i=0; i<[dataArray count]; i++) {
            NSDictionary *data =[dataArray objectAtIndex:i];
            
            
            NSString *category_id = [data objectForKey:@"category_id"];
            //NSString *category_name = [data objectForKey:@"category_name"];
            //    NSString *category_parent = [data objectForKey:@"parent"];
            
            
            
            
            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"category_id == %@ ", category_id];
            
            [request setPredicate:predicate];
            
            NSError *error = nil;
            NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
            NSUInteger count =0;
            if (array != nil) {
                count = [array count]; 
                
            }
            else {
                // Deal with error.
            }
            
            
            if (count==0) {
                g++;
                
                NSManagedObject *datas;
                
                AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
                NSManagedObjectContext *context =[appDeligate managedObjectContext];
                
                
                
                datas = [NSEntityDescription insertNewObjectForEntityForName:@"Categories" inManagedObjectContext:context];
                
                
                [datas setValue:[data objectForKey:@"category_id"] forKey:@"category_id"];
                [datas setValue:[data objectForKey:@"category_name"] forKey:@"category_name"];
                [datas setValue:[data objectForKey:@"parent" ] forKey:@"parent"]; 
                [datas setValue:[data objectForKey:@"image_name" ] forKey:@"image_name"]; 
                [datas setValue:@"1" forKey:@"selected"]; 
                
                NSString *imgurl =[NSString stringWithFormat:@"%@/%@",categoryImageURL,[data objectForKey:@"image_name" ]];
                
                NSURL *url = [NSURL URLWithString:imgurl];
                NSData *data1 = [NSData dataWithContentsOfURL:url];
                
              
                
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                path = [path stringByAppendingString:@"/"];
                path = [path stringByAppendingString:[data objectForKey:@"image_name" ]];
                
                
                
                                
                NSFileManager *fileManager = [NSFileManager defaultManager];
               
                BOOL exists = [fileManager fileExistsAtPath:path];
                if (exists) {
                    [data1 writeToFile:path atomically:NO];
                }else
                {
                    [data1 writeToFile:path atomically:NO];
                }
                //[self resizeTableViewImages:[data objectForKey:@"image_name" ]];
                [self performSelectorInBackground:@selector(resizeTableViewImages:) withObject:[data objectForKey:@"image_name" ]];
                
                if (![managedObjectContext save:&error]) {
                    NSLog(@"%@",error);
                }    
                
                NSLog(@"category==%@",[data objectForKey:@"category_name"]);
            }    
            
           }
    
    
    
}

-(void)resizeTableViewImages:(NSString *)category_image_name
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"/"];
    path = [path stringByAppendingString:category_image_name];
    

  //  dataPath = [path stringByAppendingString:category_image_name];
    
    NSString *writePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    writePath = [writePath stringByAppendingString:@"/80x60_"];
    writePath = [writePath stringByAppendingString:category_image_name];
    
    
    NSData*imageData =  UIImagePNGRepresentation([self imageWithImage:[UIImage imageWithContentsOfFile:path] scaledToSize:CGSizeMake(80, 60)]);
    
        [imageData writeToFile:writePath atomically:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
     NSLog(@"applicationDidEnterBackground");
    exit(0);
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
     NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //exit(0);
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/


//Explicitly write Core Data accessors
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: @"Ginza.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


-(NSMutableDictionary *) getPointOfInterestItems
{
    
    NSLog(@"POI start %@",[NSDate date]);
    NSMutableArray *dataArray = self.offerDataArray;
    filterString = [self getFilterString];
    NSMutableDictionary *mapDataDict = [[NSMutableDictionary alloc]init ];
    
    for (int index=0; index<[dataArray count]; index++) {
        Offer *offer =[dataArray objectAtIndex:index];
        
        ShopList *merchant = [self getStoreDataById:offer.store_id];
        Categories *cat =[self getCategoryDataById:merchant.sub_category];
        /*if ([mapDataDict valueForKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]]==nil) {
            NSMutableArray *offerdataArray =[[NSMutableArray alloc]init ];
            [offerdataArray addObject:offer];
            [mapDataDict setValue:offerdataArray forKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
        }else
        {
            NSMutableArray *offerdataArray =[mapDataDict objectForKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
            [offerdataArray addObject:offer];
            [mapDataDict setValue:offerdataArray forKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
        }*/

        if ([isFilterOn intValue]==1) {
            NSString *cretiria= [NSString stringWithFormat:@"%@-%@",cat.parent, cat.category_id ];
            if ([filterString rangeOfString:cretiria].location == NSNotFound) {
                
            }else
            {
                if ([mapDataDict valueForKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]]==nil) {
                    NSMutableArray *offerdataArrayLocal =[[NSMutableArray alloc]init ];
                    [offerdataArrayLocal addObject:offer];
                    [mapDataDict setValue:offerdataArrayLocal forKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
                }else
                {
                    NSMutableArray *offerdataArrayLocal =[mapDataDict objectForKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
                    [offerdataArrayLocal addObject:offer];
                    [mapDataDict setValue:offerdataArrayLocal forKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
                }

            }
        }
        else
        {
            NSLog(@"is filter off");
            if ([mapDataDict valueForKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]]==nil) {
                NSMutableArray *offerdataArrayLocal =[[NSMutableArray alloc]init ];
                [offerdataArrayLocal addObject:offer];
                [mapDataDict setValue:offerdataArrayLocal forKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
            }else
            {
                NSMutableArray *offerdataArrayLocal =[mapDataDict objectForKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
                [offerdataArrayLocal addObject:offer];
                [mapDataDict setValue:offerdataArrayLocal forKey:[NSString stringWithFormat:@"%.6f-%.6f", [merchant.latitude floatValue],[merchant.longitude floatValue]]];
            }

        }
    }
    self.poiDataDictionary = mapDataDict;
    NSLog(@"offer data count %d",[mapDataDict count]);
   // NSLog(@"%@",[mapDataDict valueForKey:[NSString stringWithFormat:@"%@-%@", merchant.latitude,merchant.longitude]]);
NSLog(@"POI end %@",[NSDate date]);
    return mapDataDict;
}

-(void)updateBookMarkCount:(Offer *)offer
{
    NSLog(@"bmark app deligate");
    
    
   
        NSError *error;
        AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        NSManagedObjectContext *context =[appDeligate managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Offer" inManagedObjectContext:context];
        [request setEntity:entity];
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"store_id > 1"];
        
        [request setPredicate:predicate];
        
        NSLog(@"%@",offer);
        if ([offer.isbookmark isEqualToString:@"1"]) {
            offer.isbookmark =@"0";
        }
        else {
            offer.isbookmark =@"1";

        }
        
        if (![managedObjectContext save:&error]) {
            NSLog(@"%@",error);
        }    
  

    
    int bookmarkDataCount = [[self getBookmarkOfferData ]count];
    if (bookmarkDataCount >0) {
        appDeligate.bookmarkviewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i", bookmarkDataCount];
    }else
    {
         appDeligate.bookmarkviewController.tabBarItem.badgeValue = nil;
    }
    
    
}


-(NSMutableDictionary *)getListViewData
{
    filterString = [self getFilterString];
    NSArray *dataArray = self.offerDataArray;
    NSMutableDictionary *dataDict =[[NSMutableDictionary alloc]init];
    int rowIndex=0;
    for (int index=0;index<[dataArray count];index++)
    {
        Offer *offer =[dataArray objectAtIndex:index];
        ShopList *shopData = [self getStoreDataById:offer.store_id];
        Categories *categoryData = (Categories *)[self getCategoryDataById:shopData.sub_category];

        if ([isFilterOn intValue]==1) {
            NSString *cretiria= [NSString stringWithFormat:@"%@-%@",categoryData.parent, categoryData.category_id ];
            if ([filterString rangeOfString:cretiria].location == NSNotFound) {
                
            }else
            {
                NSMutableDictionary  *tmpDict =[[NSMutableDictionary alloc]init ];
                Offer *offer =[dataArray objectAtIndex:index];
                ShopList *shopData = [self getStoreDataById:offer.store_id];
                Categories *categoryData = (Categories *)[self getCategoryDataById:shopData.sub_category];
                
                [tmpDict setValue:offer forKey:@"offer"];
                [tmpDict setValue:shopData forKey:@"shop"];
                [tmpDict setValue:categoryData forKey:@"cat"];
                [dataDict setValue:tmpDict forKey:[NSString stringWithFormat:@"%d", rowIndex++]];
                [tmpDict release];
            }
        }else
        {
            NSMutableDictionary  *tmpDict =[[NSMutableDictionary alloc]init ];
            Offer *offer =[dataArray objectAtIndex:index];
            ShopList *shopData = [self getStoreDataById:offer.store_id];
            Categories *categoryData = (Categories *)[self getCategoryDataById:shopData.sub_category];
            
            [tmpDict setValue:offer forKey:@"offer"];
            [tmpDict setValue:shopData forKey:@"shop"];
            [tmpDict setValue:categoryData forKey:@"cat"];
            [dataDict setValue:tmpDict forKey:[NSString stringWithFormat:@"%d", rowIndex++]];   
            [tmpDict release];
        }

        
        /*NSMutableDictionary  *tmpDict =[[NSMutableDictionary alloc]init ];
        Offer *offer =[dataArray objectAtIndex:index];
        ShopList *shopData = [self getStoreDataById:offer.store_id];
        Categories *categoryData = (Categories *)[self getCategoryDataById:shopData.sub_category];
        
        [tmpDict setValue:offer forKey:@"offer"];
        [tmpDict setValue:shopData forKey:@"shop"];
        [tmpDict setValue:categoryData forKey:@"cat"];
        [dataDict setValue:tmpDict forKey:[NSString stringWithFormat:@"%d", index]];*/
        
    }
    listViewDataArray = dataDict;
    NSLog(@"List view offer count = %d",[listViewDataArray count]);
    return dataDict;
}

-(UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
