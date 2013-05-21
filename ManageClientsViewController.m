//
//  ManageClientsViewController.m
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/17/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageClientsViewController.h"
#import "Customer.h"
#import "ManageClientsDetailViewController.h"

@interface ManageClientsViewController ()

@end

@implementation ManageClientsViewController

@synthesize clientsTableView, clientsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
  delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    
	// Do any additional setup after loading the view.
}

#pragma  Mark TableViewDelegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [clientsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
 
    
    Customer * info = [clientsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = info.businessName;
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storybord" bundle:nil];
    ManageClientsDetailViewController * editClients = (ManageClientsDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"editClients"];
    
    editClients.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    //Make sure the view is ready to recieve information
    if ([editClients view]) {
      
        [editClients setContactName:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setBusinessName:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setBusinessDescription:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setAddressOne:[NSMutableArray arrayWithObject: [clientsArray objectAtIndex:indexPath.row]]];
        [editClients setAddressTwo:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setState:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setCity:[NSMutableArray arrayWithObject:[ clientsArray objectAtIndex:indexPath.row]]];
        [editClients setZipcode:[NSMutableArray arrayWithObject:[ clientsArray objectAtIndex:indexPath.row]]];
        [editClients setTelefone:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setMobile:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setFax:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];
        [editClients setWebsite:[NSMutableArray arrayWithObject: [clientsArray objectAtIndex:indexPath.row]]];
        [editClients setEmail:[NSMutableArray arrayWithObject:[clientsArray objectAtIndex:indexPath.row]]];

    }
    [self presentViewController:editClients animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
