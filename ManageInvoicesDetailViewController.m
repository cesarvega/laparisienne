//
//  ManageInvoicesDetailViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageInvoicesDetailViewController.h"

@interface ManageInvoicesDetailViewController ()

@end

@implementation ManageInvoicesDetailViewController
@synthesize InvoiceDateTextLabel,InvoiceDepartmentTextLabel,InvoiceNumberTextLabel,InvoiceID;
@synthesize ClientAddressTextLabel,BusinessNameTextLabel,ClientNameTextLabel,InvoiceLines,custID;
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
    contextForHeader = [delegate managedObjectContext];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveInvoice:(id)sender {
    //CYNTHIA STUFF your code goes here to store the invoice
    // the array with the invoice_line objects is "InvoiceLines" and the customer is is custID
    
}

- (IBAction)ReEditProductsSelected:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self GetClientDataForHeader];
    // NSLog(@"%@",InvoiceLines);
}

-(void)GetClientDataForHeader{

    NSError *error = nil;
    //This is your NSManagedObject subclass
    //Set up to get the thing you want to update
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"custID = %@",custID]];
    
    //Ask for it
    NSArray *invoices= [contextForHeader executeFetchRequest:request error:&error];
    for (NSArray *item in invoices) {
        NSString *BusinessName = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        NSString *Department =@"Kitchen 1";
        NSString *BusinessAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                                     [item valueForKey:@"addressOne"], [item valueForKey:@"addressTwo"],
                                     [item valueForKey:@"city"],[item valueForKey:@"state"],[item valueForKey:@"zipcode"]];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
         [dateFormat setDateFormat:@"MM -dd - YYYY"];
        NSString *dateString = [dateFormat stringFromDate:date];
        NSString *Date =dateString;
        NSString *BusinessContactName = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        NSString *InvoiceNumber =@"12345678";
        [BusinessNameTextLabel setText:BusinessName];
        [InvoiceDepartmentTextLabel setText:Department];
        [ClientAddressTextLabel setText:BusinessAddress];
        [InvoiceDateTextLabel setText:Date];
        [ClientNameTextLabel setText:BusinessContactName];
        [InvoiceNumberTextLabel setText:InvoiceNumber];
        
        UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 300, 30)];
        
        [self.view addSubview:headingLabel];
       
        headingLabel.text = @"WELCOME";
  
    }

}

- (IBAction)PrintPdf:(id)sender {
    
    
    
    
}


@end
