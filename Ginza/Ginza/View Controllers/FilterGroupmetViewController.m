//
//  FilterGroupmetViewController.m
//  Ginza
//
//  Created by Arul Karthik on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterGroupmetViewController.h"
#import "GinzaFilterViewController.h"
#import "Categories.h"

@interface FilterGroupmetViewController ()

@end

@implementation FilterGroupmetViewController
@synthesize tblFilterView;
@synthesize arrayOfList;
@synthesize selectedArrayListt;
@synthesize panGesture,categoryId;
@synthesize arrayOfImages;
@synthesize arrayOfTitles;
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
    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
    arrayOfList = [[deligate getSubCategories:categoryId]copy];

    NSLog(@"%@",arrayOfList);
    selectedArrayListt = [[NSMutableArray alloc]init];
    
   arrayOfImages = [[NSMutableArray alloc]initWithObjects:@"Icon1@2x.png",@"Icon2@2x.png",@"Icon3@2x.png", nil];
    
    arrayOfTitles = [[NSMutableArray alloc]initWithObjects:@"子供連れ可",@"ランチあり",@"個室あり", nil];
   
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
         return arrayOfList.count;
    }
    return 3;
}

// Customize the appearance of table view cells.


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
                
    }

    AppDelegate *deligate =(AppDelegate *)[[UIApplication sharedApplication]delegate];
   if(indexPath.section==0)
   {
       Categories *object = [arrayOfList objectAtIndex:indexPath.row];
       cell.textLabel.text =object.category_name;
       if([object.selected isEqualToString:@"1"])
       {
           
           [deligate.arraySelectedCategories addObject:object.category_id];
           [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
       } else {
           [cell setAccessoryType:UITableViewCellAccessoryNone];
       }
   }
   else if(indexPath.section==1) 
       
   {
       
   
       if (indexPath.row==0) {
           if([deligate.arraySelectedCategories containsObject:@"-1"])
           {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                  
           } else {
              
               [cell setAccessoryType:UITableViewCellAccessoryNone];
           }
           
           
       }
       if (indexPath.row==1) {
           if([deligate.arraySelectedCategories containsObject:@"-2"])
           {
               [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
               
           } else {
               
               [cell setAccessoryType:UITableViewCellAccessoryNone];
           }

       }
       if (indexPath.row==2) {
           if([deligate.arraySelectedCategories containsObject:@"-3"])
           {
               [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
               
           } else {
               
               [cell setAccessoryType:UITableViewCellAccessoryNone];
           }

       }
    
       UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[arrayOfImages objectAtIndex:indexPath.row]]];
        
        imgView.frame = CGRectMake(20,14, 24, 18);
        
        [cell addSubview:imgView];
       
       
       UILabel *lblTitle = [[UILabel alloc]init ];
       lblTitle.text =[arrayOfTitles objectAtIndex:indexPath.row];
       lblTitle.backgroundColor = [UIColor clearColor];
       lblTitle.frame = CGRectMake(55, 0, 100, 45);
       lblTitle.textColor = [UIColor blackColor];
       lblTitle.font = [UIFont systemFontOfSize:14];
       [cell addSubview:lblTitle];

    }

    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.selectedArrayListt containsObject:indexPath]){
		[self.selectedArrayListt removeObject:indexPath];
	} else {
		[self.selectedArrayListt addObject:indexPath];
	}
    AppDelegate  *appDeligate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (indexPath.section==0) {
        NSLog(@"dostuff");
        NSError *error;
        
        NSManagedObjectContext *context =[appDeligate managedObjectContext];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Categories" inManagedObjectContext:context];
        [request setEntity:entity];
        NSPredicate *predicate =
        [NSPredicate predicateWithFormat:@"parent == %@",categoryId];
        
        [request setPredicate:predicate];
        
        NSMutableArray *offers = (NSMutableArray *)[context executeFetchRequest:request error:&error];
        
        Categories *cat =[offers objectAtIndex:indexPath.row];
        NSLog(@"selected =%@",cat.selected);
        if ([cat.selected isEqualToString:@"1"]) {
            cat.selected =@"0";
            
        }
        else {
            cat.selected =@"1";
        }
        
        if (![context save:&error]) {
            NSLog(@"%@",error);
        }    

    }   
       
   
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            if([appDeligate.arraySelectedCategories containsObject:@"-1"])
            {
                [appDeligate.arraySelectedCategories removeObject:@"-1"];  
            } else {
                [appDeligate.arraySelectedCategories addObject:@"-1"];
            
            }
        }
            if (indexPath.row==1) {
                if([appDeligate.arraySelectedCategories containsObject:@"-2"])
                {
                    [appDeligate.arraySelectedCategories removeObject:@"-2"];  
                } else {
                    [appDeligate.arraySelectedCategories addObject:@"-2"];
                    
                }
            }
                if (indexPath.row==2) {
                    if([appDeligate.arraySelectedCategories containsObject:@"-3"])
                    {
                        [appDeligate.arraySelectedCategories removeObject:@"-3"];  
                    } else {
                        [appDeligate.arraySelectedCategories addObject:@"-3"];
                        
                    }
            
            
        }
    }
    
	[tableView reloadData];
}


-(IBAction)backAction:(id)sender
{
   //GinzaFilterViewController *filterViewController = [[GinzaFilterViewController alloc] initWithNibName:@"GinzaFilterViewController" bundle:nil];
   // [self.navigationController presentModalViewController:filterViewController animated:YES];
   // [self presentModalViewController:filterViewController animated:YES];

    
    [self dismissModalViewControllerAnimated:YES];
    
}


@end
