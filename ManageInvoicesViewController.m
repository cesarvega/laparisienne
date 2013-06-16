//
//  ManageInvoicesViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageInvoicesViewController.h"
#import "ManageInvoicesDetailViewController.h"
#import "ChooseProductsForInvoiceViewController.h"
@interface ManageInvoicesViewController ()

@end

@implementation ManageInvoicesViewController
@synthesize CustomersPickerDataSrc,ProductsPickerDataSrc;
@synthesize custIDValue, invoiceDocDates, invoicesDocNums,InvoiceID, InvoicesTableView;
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
     context = [delegate managedObjectContext];
    [self initArrays];
    [self getinvoices];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [invoicesDocNums count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Invoice # :%@",[invoicesDocNums objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text =[invoiceDocDates objectAtIndex:indexPath.row];
    return cell;
}

//modify this to open a specific invoice depending on which row selected 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ManageInvoicesDetailViewController * manageInvoicesDetailView = (ManageInvoicesDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"invoicesDetails"];
    
    manageInvoicesDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if ([manageInvoicesDetailView view]) {
        [manageInvoicesDetailView setCustID:custIDValue];
        [manageInvoicesDetailView setInvoiceID: [InvoiceID objectAtIndex:indexPath.row]];    
    }
    [self presentViewController:manageInvoicesDetailView animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//this will query for all invoices with the view cust ID passed from 'choose client for invoice controller'

-(void)initArrays{
    invoiceDocDates = [[NSMutableArray alloc]init];
    invoicesDocNums = [[NSMutableArray alloc]init];
    InvoiceID =[[NSMutableArray alloc]init];
}

//get all invoices whose custID = this class custID
-(void)getinvoices{
    NSError *error = nil;
    //This is your NSManagedObject subclass
    //Set up to get the thing you want to update
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"custID = %@",custIDValue]];
    
    //Ask for it
    NSArray *invoices= [context executeFetchRequest:request error:&error];
    for (NSArray *item in invoices) {
        NSString *date = [NSString stringWithFormat:@"%@",[item valueForKey:@"docDate"]];
        NSNumber *InvoiceIDs = [item valueForKey:@"InvoiceID"];
        NSString *docNum = [NSString stringWithFormat:@"%@",[item valueForKey:@"docNum"]];
        [invoicesDocNums addObject:docNum];
        [invoiceDocDates addObject:date];
        [InvoiceID addObject:InvoiceIDs];
    }
 }

- (IBAction)CreateANewInvoiceButton:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ChooseProductsForInvoiceViewController * ChooseProducts = (ChooseProductsForInvoiceViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"SelectProductsForInvoice"];
    ChooseProducts.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [ChooseProducts setClientID:custIDValue];
    [self presentViewController:ChooseProducts animated:YES completion:nil];
    
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
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete this invoice?"
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
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSString *val = [InvoiceID objectAtIndex:indexPathForDeletion.row];
        NSPredicate *p =[NSPredicate predicateWithFormat:@"invoiceID = %@", val];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        
        
        for (Invoice *invoice in items) {
            [delegate.managedObjectContext deleteObject:invoice];
            
            
            NSMutableArray *invoiceLinesToBeDeleted = [[NSMutableArray alloc]initWithArray:
            [self GetInvoiceLines:invoice.docNum]];
            
            for(int i = 0; i < [invoiceLinesToBeDeleted count]; i++)
            {
                [delegate.managedObjectContext deleteObject:[invoiceLinesToBeDeleted objectAtIndex:i]];
            }
            
        }
        if (![delegate.managedObjectContext save:&error]) {
            NSLog(@"Error deleting - error:%@",error);
        }
        
        [InvoiceID removeObjectAtIndex:indexPathForDeletion.row];
        [invoiceDocDates removeObjectAtIndex:indexPathForDeletion.row];
        [invoicesDocNums removeAllObjects];
        
        
        //add logic to get custID and delete from table
        
        
    }
    [InvoicesTableView   reloadData];
    
}
-(NSArray*)GetInvoiceLines: (NSString*)InvoiceLine{
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice_Lines" inManagedObjectContext:delegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"parentInvoiceDocNum= %@",InvoiceLine]];
    NSArray *Invoice_Lines= [delegate.managedObjectContext executeFetchRequest:request error:&error];
    return Invoice_Lines;
}



@end
