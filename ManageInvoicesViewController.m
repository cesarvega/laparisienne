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
@synthesize custIDValue, invoiceDocDates, invoicesDocNums,InvoiceID;
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






@end
