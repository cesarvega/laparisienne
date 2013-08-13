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
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray * results = [[NSArray alloc] init];
    results  =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSString *match = @"Invoice*pdf";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", match];
    directoryContents = [results filteredArrayUsingPredicate:predicate];
    
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
    cell.textLabel.textColor = [UIColor brownColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    ManageInvoicesDetailViewController * manageInvoicesDetailView = (ManageInvoicesDetailViewController*)
//    [storyboard instantiateViewControllerWithIdentifier:@"invoicesDetails"];
//    
//    manageInvoicesDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    if ([manageInvoicesDetailView view]) {
//        [manageInvoicesDetailView setCustID:custIDValue];
//        [manageInvoicesDetailView setInvoiceID: [InvoiceID objectAtIndex:indexPath.row]];
//    }
//    [self presentViewController:manageInvoicesDetailView animated:YES completion:nil];
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)initArrays{
    invoiceDocDates = [[NSMutableArray alloc]init];
    invoicesDocNums = [[NSMutableArray alloc]init];
    InvoiceID =[[NSMutableArray alloc]init];
}

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
        
        indexPathForDeletion = indexPath;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete this invoice?"
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
        
    }
//    NSError *error = nil;
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString * invoiceToDelete =  [NSString stringWithFormat:@"Invoice # :%@",[invoicesDocNums objectAtIndex:indexPathForDeletion.row]];
//    NSString* fullPath = [NSString stringWithFormat:@"%@/%@%@",documentsDirectory,invoiceToDelete,@".pdf" ];
//      if (invoicesDocNums.count >0) {
//        [[NSFileManager defaultManager] removeItemAtPath: fullPath error:&error];
//
//    }
//   
    
       UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ChooseCLientsFOrInvoice"];
        [self presentViewController:manageClientsViewController animated:YES completion:nil];
    
    
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