//
//  ManageProductsViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageProductsViewController.h"
#import "ManageProductsDetailViewController.h"

@interface ManageProductsViewController ()

@end

@implementation ManageProductsViewController
@synthesize Productname, productID, productDescription,unitPrice, productsTableView;

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
        [self FindProdcuts];
   //[self deleteAllObjects:@"blah"];
	
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Productname count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =  [Productname objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [productDescription objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ManageProductsDetailViewController * manageProductsDetailView = (ManageProductsDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"ManageProductsDetail"];
    
    manageProductsDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if ([manageProductsDetailView view]) {
        [manageProductsDetailView setName:[Productname objectAtIndex:indexPath.row]];
        [manageProductsDetailView setProductID:[productID objectAtIndex:indexPath.row]];
        [manageProductsDetailView setProductDescription:[productDescription objectAtIndex:indexPath.row]];
       
        [manageProductsDetailView setUnitPrice:[unitPrice objectAtIndex:indexPath.row]];
        
    }
    [self presentViewController:manageProductsDetailView animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        // [self.dataArray removeObjectAtIndex:indexPath.row];
        indexPathForDeletion = indexPath;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete this product?"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
        
        [message show];
        
    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSString *val = [productID  objectAtIndex:indexPathForDeletion.row];
        NSPredicate *p =[NSPredicate predicateWithFormat:@"productID = %@", val];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        
        
        for (Product *product in items) {
            [delegate.managedObjectContext deleteObject:product];
            NSLog(@"object deleted");
        }
        if (![delegate.managedObjectContext save:&error]) {
            NSLog(@"Error deleting - error:%@",error);
        }
        
        [Productname removeObjectAtIndex:indexPathForDeletion.row];
        [productDescription removeObjectAtIndex:indexPathForDeletion.row];
        
        //add logic to get custID and delete from table
        
        
    }
    [productsTableView   reloadData];
        
    }


-(void)FindProdcuts{
    
    [self  InitArraysToHoldData];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Product" inManagedObjectContext:context];
    NSError *error;
    [fetchRequest setEntity:entity];
    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSArray *item in innerStringdictionary) {
        
        NSString *Productnames = [NSString stringWithFormat:@"%@",[item valueForKey:@"name"]];
        NSString *productDescriptions = [NSString stringWithFormat:@"%@",[item valueForKey:@"productDescription"]];
        NSString *productIDs = [NSString stringWithFormat:@"%@",[item valueForKey:@"productID"]];
        NSDecimalNumber *unitPrices = [item valueForKey:@"unitPrice"];
        [Productname addObject:Productnames];
        [productDescription addObject:productDescriptions];
        [productID addObject:productIDs];
        [unitPrice addObject:unitPrices];
    }
}

-(void)InitArraysToHoldData{
    Productname = [[NSMutableArray alloc] init];
    productDescription = [[NSMutableArray alloc] init];
    productID = [[NSMutableArray alloc] init];
    unitPrice = [[NSMutableArray alloc] init];
    }

//function to delete all records
- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
    for (Product *product in items) {
    	[delegate.managedObjectContext deleteObject:product];
    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![delegate.managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}
@end
