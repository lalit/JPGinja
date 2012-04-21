//
//  SubMenuHomeController.m
//  Ginza
//
//  Created by administrator on 02/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SubMenuHomeController.h"
#import "GinzaEventsController.h"

@implementation SubMenuHomeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return  3;
    
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    static NSString *CellIdentifier = @"Cell";
    
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if (cell == nil) 
     {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] ;
     
     
         if (indexPath.row ==0) {
             cell.textLabel.text = @"入会お申し込み";
         }
         
         if (indexPath.row ==1) {
             cell.textLabel.text = @"このアプリについて";
         }
         
         if (indexPath.row ==2) {
             cell.textLabel.text = @"お問い合わせ";
         }
     }
       
    return cell;
    
    
    
    
}

-(IBAction)btnEventsTouched:(id)sender
{
    GinzaEventsController *events =[[GinzaEventsController alloc]init];
    events.modalTransitionStyle = UIModalPresentationPageSheet;
    [self presentModalViewController:events animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}
-(IBAction)btnCloseTouched:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];

}
@end
