//
//  ManageClientsViewController.m
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/17/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//
//a comment
//another comment

#import "ManageClientsViewController.h"
#import "Customer.h"
#import "ManageClientsDetailViewController.h"

@interface ManageClientsViewController ()

@end

@implementation ManageClientsViewController
@synthesize addressOne, addressTwo, businessDescription, businessName;
@synthesize city, contactName, custIDValue, email, fax, mobile, telefone, website, zipcode, state, clientsTableView;

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
    cell.detailTextLabel.text = [businessDescription objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ManageClientsDetailViewController * editClients = (ManageClientsDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"editClients"];
    
    editClients.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    //Make sure the view is ready to recieve information
    if ([editClients view]) {
        
        [editClients setCustIDValue:[custIDValue objectAtIndex:indexPath.row]];
        [editClients setContactName:[contactName objectAtIndex:indexPath.row]];
        [editClients setBusinessName:[businessName objectAtIndex:indexPath.row]];
        [editClients setBusinessDescription:[businessDescription objectAtIndex:indexPath.row]];
        [editClients setAddressOne:[addressOne objectAtIndex:indexPath.row]];
        [editClients setAddressTwo:[addressTwo objectAtIndex:indexPath.row]];
        [editClients setState:[state objectAtIndex:indexPath.row]];
        [editClients setCity:[ city objectAtIndex:indexPath.row]];
        [editClients setZipcode:[ zipcode objectAtIndex:indexPath.row]];
        [editClients setTelefone:[telefone objectAtIndex:indexPath.row]];
        [editClients setMobile:[mobile objectAtIndex:indexPath.row]];
        [editClients setFax:[fax objectAtIndex:indexPath.row]];
        [editClients setWebsite:[website objectAtIndex:indexPath.row]];
        [editClients setEmail:[email objectAtIndex:indexPath.row]];
        
    }
    [self presentViewController:editClients animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        indexPathForDeletion = indexPath;
        
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete this client?"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
   
        [message show];
     
    
    
}
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        // [self.dataArray removeObjectAtIndex:indexPath.row];
        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSString *val = [custIDValue  objectAtIndex:indexPathForDeletion.row];
        NSPredicate *p =[NSPredicate predicateWithFormat:@"custID = %@", val];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        
        
        for (Customer *customer in items) {
            [delegate.managedObjectContext deleteObject:customer];
            }
        if (![delegate.managedObjectContext save:&error]) {
           
        }
        
        [businessName removeObjectAtIndex:indexPathForDeletion.row];
        [businessDescription removeObjectAtIndex:indexPathForDeletion.row];
        [addressOne removeObjectAtIndex:indexPathForDeletion.row];
        [addressTwo removeObjectAtIndex:indexPathForDeletion.row];
        // [businessDescription removeObjectAtIndex:indexPath.row];
        // [businessName removeObjectAtIndex:indexPath.row];
        [city removeObjectAtIndex:indexPathForDeletion.row];
        [contactName removeObjectAtIndex:indexPathForDeletion.row];
        [custIDValue removeObjectAtIndex:indexPathForDeletion.row];
        [email removeObjectAtIndex:indexPathForDeletion.row];
        [fax removeObjectAtIndex:indexPathForDeletion.row];
        [mobile removeObjectAtIndex:indexPathForDeletion.row];
        [state removeObjectAtIndex:indexPathForDeletion.row];
        [telefone removeObjectAtIndex:indexPathForDeletion.row];
        [website removeObjectAtIndex:indexPathForDeletion.row];
        [zipcode removeObjectAtIndex:indexPathForDeletion.row];
        //add logic to get custID and delete from table
        
        
    }
    [clientsTableView reloadData];
        
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)InitArraysToHoldData{
    
    //a comment
    
    addressOne = [[NSMutableArray alloc] init];
    addressTwo = [[NSMutableArray alloc] init];
    businessDescription = [[NSMutableArray alloc] init];
    businessName = [[NSMutableArray alloc] init];
    city = [[NSMutableArray alloc] init];
    contactName = [[NSMutableArray alloc] init];
    email = [[NSMutableArray alloc] init];
    fax = [[NSMutableArray alloc] init];
    mobile = [[NSMutableArray alloc] init];
    state = [[NSMutableArray alloc] init];
    telefone = [[NSMutableArray alloc] init];
    website =  [[NSMutableArray alloc] init];
    zipcode =  [[NSMutableArray alloc] init];
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
        
        
        NSString *addressOnes = [NSString stringWithFormat:@"%@",[item valueForKey:@"addressOne"]];
        NSString *addressTwos = [NSString stringWithFormat:@"%@",[item valueForKey:@"addressTwo"]];
        NSString *businessDescriptions = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessDescription"]];
        NSString *businessNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        NSString *citys = [NSString stringWithFormat:@"%@",[item valueForKey:@"city"]];
        NSString *contactNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"contactName"]];
        NSString *custIDValues = [NSString stringWithFormat:@"%@",[item valueForKey:@"custID"]];
        NSString *emails = [NSString stringWithFormat:@"%@",[item valueForKey:@"email"]];
        NSString *faxs = [NSString stringWithFormat:@"%@",[item valueForKey:@"fax"]];
        NSString *mobiles = [NSString stringWithFormat:@"%@",[item valueForKey:@"mobile"]];
        NSString *states = [NSString stringWithFormat:@"%@",[item valueForKey:@"state"]];
        NSString *telefones = [NSString stringWithFormat:@"%@",[item valueForKey:@"telefone"]];
        NSString *websites = [NSString stringWithFormat:@"%@",[item valueForKey:@"website"]];
        NSString *zipcodes = [NSString stringWithFormat:@"%@",[item valueForKey:@"zipcode"]];
        
        [addressOne addObject:addressOnes];
        [addressTwo addObject:addressTwos];
        [businessDescription addObject:businessDescriptions];
        [businessName addObject: businessNames];
        [city addObject: citys];
        [contactName addObject:contactNames];
        [custIDValue addObject:custIDValues];
        [email addObject:emails];
        [fax addObject: faxs];
        [mobile addObject:mobiles];
        [state addObject:states];
        [telefone addObject:telefones];
        [website addObject:websites];
        [zipcode addObject:zipcodes];
        
    }
}

@end
