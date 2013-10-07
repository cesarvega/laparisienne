//
//  ViewSignedInvoicesViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 7/23/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ViewSignedInvoicesViewController.h"
#import "NICSignatureView.h"
@interface ViewSignedInvoicesViewController ()

@end

@implementation ViewSignedInvoicesViewController
@synthesize InvoicesTableView,InvoiceID,searchBar, isFiltered,filteredTableData,allTableData,currentDate,InvoiceDatePicker;

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
    NSString *match = @"Signed #*pdf";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", match];
    directoryContents = [results filteredArrayUsingPredicate:predicate];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    contextForHeader = [delegate managedObjectContext];
    searchBar.delegate = (id)self;
    isFiltered = @"FALSE";
    [InvoiceDatePicker  addTarget:self action:@selector(changeValues:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMdd"];
    NSString *dateString = [dateFormat stringFromDate:[InvoiceDatePicker date]];
    searchDate =dateString;
    [self changeValues:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([isFiltered isEqual:@"TRUE"])
        return [filteredTableData count];
    else
        return [filteredTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if([isFiltered isEqual:@"TRUE"])
        cell.textLabel.text = [filteredTableData objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [filteredTableData objectAtIndex:indexPath.row];
//        cell.detailTextLabel.text =[InvoiceDate objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor brownColor];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    indexPathForDeletion =indexPath;
    InvoiceID = [directoryContents objectAtIndex:indexPath.row];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory    , NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[ filteredTableData objectAtIndex:indexPathForDeletion.row]]];
    if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
        
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:readerViewController animated:YES completion:nil];
        }
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        indexPathForDeletion =indexPath;
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
        NSError *error = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,[directoryContents objectAtIndex:indexPathForDeletion.row] ];
        [[NSFileManager defaultManager] removeItemAtPath: fullPath error:&error];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ViewSignedInvoices"];
        [self presentViewController:manageClientsViewController animated:YES completion:nil];
    }
    
    if([title isEqualToString:@"Preview Doc"])
        
    {        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory    , NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[ directoryContents objectAtIndex:indexPathForDeletion.row]]];
        if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
            
            ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
            
            if (document != nil)
            {
                ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
                readerViewController.delegate = self;
                readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:readerViewController animated:YES completion:nil];
            }
        }
        
        
    }
    
    if([title isEqualToString:@"Sign Doc"])
    {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        GLKViewController * createsignatureInvoice = (GLKViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GLKView"];
        delegate.InvoiceIDGlobal =[NSString stringWithFormat:@"%@", InvoiceID];
        [self presentViewController:createsignatureInvoice animated:YES completion:nil];
    }
    
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text{
    if(text.length == 0)
    {
        isFiltered = @"FALSE";
    }
    else
    {
        
        filteredTableData = [[NSMutableArray alloc] init];
        for (NSString* pdf in directoryContents)
        {
            if ([pdf rangeOfString:text].location != NSNotFound) {
                [filteredTableData addObject:pdf];
                isFiltered = @"TRUE";
            }else{ }
        }
    }
    
    [self.InvoicesTableView reloadData];
}

-(void)changeValues:(id)sender{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMdd"];
    NSString *dateString = [dateFormat stringFromDate:[InvoiceDatePicker date]];
    int dateDocNum = [dateString intValue];
    searchDate =[NSString stringWithFormat:@"%d",dateDocNum];
    NSMutableArray* invoicesFromDateArray = [self findInvoicesByDate:searchDate];
    [self FindClientFromPdfInvoices:invoicesFromDateArray];
    [self.InvoicesTableView reloadData];
    
}

-(NSMutableArray*)FindClientFromPdfInvoices :(NSMutableArray*)invoicesFromDateArray{
    clientsToPrint = [[NSMutableArray alloc] init];
    InvoiceDate = [[NSMutableArray alloc] init];
    InvoiceNumbers = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Customer" inManagedObjectContext:context];
    NSError *error;
    [fetchRequest setEntity:entity];
    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSArray *item in innerStringdictionary) {
        
        NSString *businessNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        NSString *clientId = [NSString stringWithFormat:@"%@",[item valueForKey:@"custID"]];
        for(NSString *existingItem in invoicesFromDateArray){
            
            NSString *str = existingItem;
            str = [str substringWithRange:NSMakeRange(10, 10)];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * InvoiceNumber = [f numberFromString:str];
            NSArray *invoices= [self GetInvoicesByInvoiceID:InvoiceNumber];
            NSString *invoiceClientName;
            for(NSString *invoice in invoices){
                
                invoiceClientName = [NSString stringWithFormat:@"%@",[invoice valueForKey:@"custID"]];
                NSString* invoiceDates = [NSString stringWithFormat:@"%@",[invoice valueForKey:@"docDate"]];
                NSString* invoiceNumbers = [NSString stringWithFormat:@"%@",[invoice valueForKey:@"docNum"]];
                if ([clientId isEqual:invoiceClientName] ) {
                    [clientsToPrint addObject:businessNames];
                    [InvoiceDate addObject:invoiceDates];
                    NSString *newPDFName = [NSString stringWithFormat:@"%@ %@.%@",@"Invoice #",invoiceNumbers,@"pdf"];
                    [InvoiceNumbers addObject:newPDFName];
                }
                
            }
            
        }
        
    }
    
    return clientsToPrint;
}

- (NSMutableArray*)findInvoicesByDate: (NSString*)dateToBeFound{
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray * results = [[NSArray alloc] init];
    results  =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSString *match = @"Signed #*pdf";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", match];
    directoryContents = [results filteredArrayUsingPredicate:predicate];
    
    filteredTableData = [[NSMutableArray alloc] init];
    for (NSString* pdf in directoryContents)
    {
        if ([pdf rangeOfString:searchDate].location != NSNotFound) {
            [filteredTableData addObject:pdf];
        }
    }
    
    return filteredTableData;
    
}

-(NSArray*)GetInvoicesByInvoiceID : (NSNumber*)InvoiceIDs{
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"invoiceID = %@",InvoiceIDs]];
    NSArray *invoices= [contextForHeader executeFetchRequest:request error:&error];
    return invoices;
}

#pragma-mark UITextField Delegade Methods

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField{
    [aTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [self animateTextField: textField up: YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled=NO;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up{
    if (textField.tag==1) {
        
    }else if(textField.tag==2){
        //  WARNING : develop a switch for diferen heighs of the textfields
        const int movementDistance = 90; // tweak as needed
        const float movementDuration = 0.5f; // tweak as needed
        
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }else{
        
        //  WARNING : develop a switch for diferen heighs of the textfields
        //        const int movementDistance = 140; // tweak as needed
        //        const float movementDuration = 0.5f; // tweak as needed
        //
        //        int movement = (up ? -movementDistance : movementDistance);
        //
        //        [UIView beginAnimations: @"anim" context: nil];
        //        [UIView setAnimationBeginsFromCurrentState: YES];
        //        [UIView setAnimationDuration: movementDuration];
        //        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        //        [UIView commitAnimations];
    }
}
@end
