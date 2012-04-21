//
//  AppDelegate.h
//  Ginza
//
//  Created by Arul Karthik on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ShopList.h"
#import "Offer.h"
#import "Categories.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSString *isFilterOn;
}
@property(nonatomic,retain)UIViewController *bookmarkviewController;
@property (nonatomic,retain) NSMutableArray *arrayStoreIds;
@property (nonatomic, retain) NSString *isFilterOn;
@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic,retain)NSString *filterString;
@property(nonatomic,retain)NSMutableArray *arraySelectedCategories;
@property(nonatomic,retain)NSMutableArray *arraySelectedSubCategories;
@property(nonatomic,retain)NSString *lastmerchantsynceddate;
@property(nonatomic,retain)NSString *offerType;
@property(nonatomic,retain)NSMutableArray *ginzaEvents;

@property(nonatomic,retain)NSMutableArray *offerDataArray;
@property(nonatomic,retain)NSMutableDictionary *poiDataDictionary;
@property(nonatomic,retain)NSMutableDictionary *listViewDataArray;
- (NSString *)applicationDocumentsDirectory;
-(NSMutableArray *)getOfferData;
-(ShopList *)getStoreDataById:(NSString *)storeid;
-(Offer *)getOfferDataById:(NSString *)offer_id;
-(Categories *)getCategoryDataById:(NSString *)category_id;
-(NSMutableArray *)getCategories;
-(NSMutableArray *)getSubCategories;
-(NSMutableArray *)getSubCategories:(NSString *)parent;
-(NSMutableArray *)getSubCategories;
-(void)resizeTableViewImages:(NSString *)category_image_name;
-(void)storeMerchantData:(NSString *)store_id;
-(NSMutableArray *)getGinzaEvents;
-(NSMutableArray *)getServices;
-(NSMutableDictionary *) getPointOfInterestItems;
-(NSMutableArray *)getListViewData;
-(void)updateBookMarkCount:(Offer *)offer;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;
//-(void)fetchOfferData:(NSData *)responseData;
-(void)fetchCategoryData;
-(void)fetchOfferData:(NSString *)lastSyncedDate;
-(void)fetchMerchantData:(NSData *)data;
-(NSMutableArray *)getBookmarkOfferData;
@end
