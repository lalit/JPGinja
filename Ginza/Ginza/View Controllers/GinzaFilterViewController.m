//
//  GinzaFilterViewController.m
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GinzaFilterViewController.h"
#import "ListViewController.h"
#import "FilterGroupmetViewController.h"
#import"AppDelegate.h"
#import"ShopList.h"
#import"Offer.h"
#import"Categories.h"
#import"AppDelegate.h"
@interface GinzaFilterViewController ()

@end

@implementation GinzaFilterViewController
@synthesize tblFilterView;
@synthesize arrayOfList;
@synthesize  sharedView;
@synthesize panGesture;
@synthesize listViewController;
@synthesize selectedCategorieList;

@synthesize currtentViewController;
@synthesize btnswitch;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    selectedCategorieList = [NSMutableArray array];
   
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) 
	{
		plistPath = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
	}
	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML mutabilityOption:NSPropertyListMutableContainersAndLeaves format:&format errorDescription:&errorDesc];
	if (!temp) 
	{
		NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
	}
	
    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    arrayOfList=[deligate getCategories];
    
    //45
    CGRect rec = self.tblFilterView.frame;
    rec.size.height = 45*[arrayOfList count]+10;
    self.tblFilterView.frame =rec;
    
    [btnswitch setOn:[deligate.isFilterOn intValue]];
}


-(IBAction)saveSettingsInfotoPlist:(id)sender
{
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsPath = [paths objectAtIndex:0];
	NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"Settings.plist"];
	
	/*
	
    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects: list, list2, nil] forKeys:[NSArray arrayWithObjects: @"list", @"list2", nil]];
	
	NSString *error = nil;
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
	
	if(plistData) 
	{
        [plistData writeToFile:plistPath atomically:YES];
    }
    else 
	{
        NSLog(@"Error in saveData: %@", error);
    }
    
    
     
     */
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayOfList.count;
}

// Customize the appearance of table view cells.


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    
    Categories *cat =[arrayOfList objectAtIndex:indexPath.row];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = indexPath.row;
    [button setFrame:CGRectMake(-10, 4.0f, 80.0f, 30.0f)];
     
        UIImageView *checkmarkbg = nil;
         if (indexPath.row>0) 
         {
        checkmarkbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Middlecorner@2x.png"]];
         checkmarkbg.frame = CGRectMake(9,0.0f, 42.0f, cell.frame.size.height); 
         }
        if (indexPath.row==0) {
             
             checkmarkbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Leftcorner@2x.png"]];
            checkmarkbg.frame = CGRectMake(9,0.0f, 42.0f, cell.frame.size.height+1); 
        }
        if (indexPath.row==[arrayOfList count]-1) {
           checkmarkbg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Rightcorner@2x.png"]];
            checkmarkbg.frame = CGRectMake(9,-1.0f, 42.0f, cell.frame.size.height+1); 
        }
                           
                                    
     //checkmarkbg.alpha = 0.5;                               
        
        
        
       
    //[button setTitle:@"Do Stuff" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doStuff:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
      
    NSLog(@"sel = %@",cat.selected);
    if ([cat.selected isEqualToString:@"1"]) {
        [button setImage:[UIImage imageNamed:@"Tickoff.png"] forState:UIControlStateNormal];
        
        

       // cell.imageView.image =[UIImage imageNamed:@"Filtercellselectedoff.png"];

        
        
        
    }else 
    
    {
        [button setImage:[UIImage imageNamed:@"Tickon.png"] forState:UIControlStateNormal];
      //  cell.imageView.image =[UIImage imageNamed:@"Filtercellselectedon.png"];


    }
    UILabel *lblCat =[[UILabel alloc]init];
     [lblCat setFrame:CGRectMake(100.0f, 5.0f, 300.0f, 30.0f)];
    lblCat.text = cat.category_name;
        [lblCat setBackgroundColor:[UIColor clearColor]];
        
        [cell addSubview:checkmarkbg];  
     [cell addSubview:lblCat];
    [cell addSubview:button];
        
        
        
        
        
        }

    
    return cell;
    
}

-(IBAction)doStuff:(id)sender
{
    UIButton *btn = sender;
    
    NSLog(@"dostuff");
    NSError *error;
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context =[appDeligate managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:context];
    [request setEntity:entity];
    NSPredicate *predicate =
    [NSPredicate predicateWithFormat:@"parent == 0"];
    
    [request setPredicate:predicate];
    
    NSMutableArray *offers = (NSMutableArray *)[context executeFetchRequest:request error:&error];
    
   Categories *cat =[offers objectAtIndex:btn.tag];
    NSLog(@"selected =%@",cat.selected);
    if ([cat.selected isEqualToString:@"1"]) {
        cat.selected =@"0";
         [btn setImage:[UIImage imageNamed:@"Arrow.png"] forState:UIControlStateNormal];
        [appDeligate.filterString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"&& category_id =%@ ",cat.category_id ] withString: @""];
    }
    else {
        cat.selected =@"1";
        [appDeligate.filterString stringByAppendingFormat:@"category_id =%@ &",cat.category_id ];
         [btn setImage:[UIImage imageNamed:@"Arrow@2x.png"] forState:UIControlStateNormal];
    }
    
    if (![context save:&error]) {
        NSLog(@"%@",error);
    }    

    [self.tblFilterView reloadData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.selectedCategorieList containsObject:indexPath]){
		[self.selectedCategorieList removeObject:indexPath];
	} else {
		[self.selectedCategorieList addObject:indexPath];
	}
	[tableView reloadData];

     
    
    
        self.listViewController = [[FilterGroupmetViewController alloc] initWithNibName:@"FilterGroupmetViewController" bundle:nil];
   
     Categories *cat =[arrayOfList objectAtIndex:indexPath.row];
    self.listViewController.categoryId=cat.category_id;
    
    [self presentModalViewController:listViewController animated:YES];
    
}



-(IBAction)swipeUPAction:(id)sender
{
    
    NSLog(@"swipe Up");
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationCurveEaseOut animations:^(void) {
        //CGRect frame = self.view.frame;
    }
                     completion:^(BOOL finished) {                         
                         [UIView animateWithDuration:0.2 delay:0 options:0 animations:^(void) {
                             CGRect rect1 = self.view.frame;
                             rect1.origin.y = -1*rect1.size.height-20;
                             self.view.frame =rect1;
                             
                         } completion:^(BOOL finished) {
                             currtentViewController.hidesBottomBarWhenPushed =NO;
                             [self.navigationController popViewControllerAnimated:NO];
                             //[self.view removeFromSuperview];
                         }];
                         
                     }];
    
}

-(void)fireMethod
{
    [self dismissModalViewControllerAnimated:NO]; 
}

-(IBAction)btnSwitchChanged:(id)sender
{
    UISwitch *switc = sender;
    NSError *error;
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
    
    //here add elements to data file and write data to file
    int value = switc.isOn;
    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    deligate.isFilterOn = [NSString stringWithFormat:@"%d",value];
    [data setObject:[NSNumber numberWithInt:value] forKey:@"filterall"];
    
    [data writeToFile: path atomically:YES];
    
}

@end
