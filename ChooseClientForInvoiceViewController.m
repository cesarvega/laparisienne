//
//  ChooseClientForInvoiceViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/27/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ChooseClientForInvoiceViewController.h"
#import "Customer.h"
#import "ManageInvoicesViewController.h"
@interface ChooseClientForInvoiceViewController ()

@end

@implementation ChooseClientForInvoiceViewController
@synthesize businessName,contactName,custIDValue;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    [self FindClients];
    
    
	// Do any additional setup after loading the view.
}

#pragma  Mark TableViewDelegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [contactName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text =  [businessName objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [contactName objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ManageInvoicesViewController * manageInvoices = (ManageInvoicesViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"ManageInvoices"];
    
    manageInvoices.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    //Make sure the view is ready to recieve information
  
        
        //this sets the cust id value for the next view
        
        NSString *val = [custIDValue objectAtIndex:indexPath.row];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * numberVal = [f numberFromString:val];
   
        [manageInvoices setCustIDValue:numberVal];
        [self presentViewController:manageInvoices animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return(YES);
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)InitArraysToHoldData{
    
    //a comment
    
    businessName = [[NSMutableArray alloc] init];
    contactName = [[NSMutableArray alloc] init];
    custIDValue = [[NSMutableArray alloc]init];
    
}

-(void)FindClients{
    
    [self  InitArraysToHoldData];
    //** this array  "innerStringdictionary" is the fetch data from the data base just get an array of data
    // this will handle the rest of the logic to populate the cells
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Customer" inManagedObjectContext:context];
    NSError *error;
    [fetchRequest setEntity:entity];
    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSArray *item in innerStringdictionary) {
        
        
        NSString *businessNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        NSString *contactNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"contactName"]];
        NSString *custIDValues = [NSString stringWithFormat:@"%@",[item valueForKey:@"custID"]];
        [businessName addObject: businessNames];
        [contactName addObject:contactNames];
        [custIDValue addObject:custIDValues];
          }
}


@end
