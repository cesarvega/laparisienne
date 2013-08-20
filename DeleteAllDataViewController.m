//
//  DeleteAllDataViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 8/13/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "DeleteAllDataViewController.h"

@interface DeleteAllDataViewController ()

@end

@implementation DeleteAllDataViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated{
     [self findInvoices];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    context = [delegate managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [directoryContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [directoryContents objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor brownColor];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (IBAction)DeleteAllData:(id)sender {
   
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:context]];
    NSArray *invoices= [context executeFetchRequest:request error:&error];

    for (Invoice *invoice in invoices) {
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
    
    // delete PDF
    for (NSString* pdf in directoryContents)
        {
            NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,pdf];
            [[NSFileManager defaultManager] removeItemAtPath: fullPath error:&error];

        }
    
    
                NSString *successMsg = [NSString stringWithFormat:@"%@",@"All your data have been deleted"];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Deleted"
                                                                    message:successMsg
                                                                   delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
                                    [alert show];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UIViewController *manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    
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

- (NSArray*)findInvoices{
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray * results = [[NSArray alloc] init];
    results  =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSString *match = @"Invoice #*.pdf";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", match];
    directoryContents = [results filteredArrayUsingPredicate:predicate];
   
    return directoryContents;
    
}

@end
