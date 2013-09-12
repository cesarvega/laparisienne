//
//  PDFInvoicesViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 6/10/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "PDFInvoicesViewController.h"
#import "NICSignatureView.h"

@interface PDFInvoicesViewController ()

@end

@implementation PDFInvoicesViewController
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
     [_Loading startAnimating];
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   NSArray * results = [[NSArray alloc] init];
    results  =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSString *match = @"Invoice*pdf";
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
    
       // InvoiceFiltered =[self FindClientFromPdfInvoices:filteredTableData];
        return [filteredTableData count];
   
    }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
        cell.textLabel.text = [filteredTableData objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor brownColor];
        return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    indexPathForDeletion =indexPath;
    InvoiceID = [filteredTableData objectAtIndex:indexPath.row];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Would you like to Preview or  Sign the Invoice"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Preview Doc"
                                            otherButtonTitles:@"Sign Doc", nil];
        [message show];
    
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
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        NSString * ID = [filteredTableData objectAtIndex:indexPathForDeletion.row];
        NSString *str = ID;
        str = [str substringWithRange:NSMakeRange(10, 9)];
        NSPredicate *p =[NSPredicate predicateWithFormat:@"invoiceID = %@", str];
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
        
        error = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,[filteredTableData objectAtIndex:indexPathForDeletion.row] ];
        [[NSFileManager defaultManager] removeItemAtPath: fullPath error:&error];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PDFInvoices"];
        [self presentViewController:manageClientsViewController animated:YES completion:nil];
        
        paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
        fullPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,[directoryContents objectAtIndex:indexPathForDeletion.row] ];
        [[NSFileManager defaultManager] removeItemAtPath: fullPath error:&error];
        storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PDFInvoices"];
        [self presentViewController:manageClientsViewController animated:YES completion:nil];
        
    }
   

    if([title isEqualToString:@"Preview Doc"])
    {
        
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
    
    if([title isEqualToString:@"Sign Doc"])
    {

         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        GLKViewController * createsignatureInvoice = (GLKViewController *)[storyboard instantiateViewControllerWithIdentifier:@"GLKView"];
         delegate.InvoiceIDGlobal =[NSString stringWithFormat:@"%@", InvoiceID];
        NSString *str = [NSString stringWithFormat:@"%@", InvoiceID];;
        str = [str stringByReplacingOccurrencesOfString:@".pdf"withString:@""];
        str =[str stringByReplacingOccurrencesOfString:@"Invoice # "withString:@""];

        
        NSArray * Number = [self GetInvoicesByInvoiceID:str];
        for (NSArray *item in Number) {
            
            NSString *SignedNumber = [NSString stringWithFormat:@"%@",[item valueForKey:@"docDate"]];
            NSString *SignedDate = [NSString stringWithFormat:@"%@",[item valueForKey:@"docDate"]];

            NSString *custID = [NSString stringWithFormat:@"%@",[item valueForKey:@"custID"]];
            
            NSString * BusinessName =  [self ClientName:custID];
            delegate.SignedInvoiceName = SignedDate;
            delegate.SignedInvoiceNumber = BusinessName;
           
        }
       
        
        [self presentViewController:createsignatureInvoice animated:YES completion:nil];
    }
      
}

-(NSString*) ClientName :(NSString*)ClienId{
    NSString *businessNames;
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Customer" inManagedObjectContext:context];
    NSError *error;
    [fetchRequest setEntity:entity];
    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
    NSPredicate *p =[NSPredicate predicateWithFormat:@"custID = %@", ClienId];
    [fetchRequest setPredicate:p];
    
    NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    for (NSArray *item in items) {
        
        businessNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        
    }
    return businessNames;
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
    [self findInvoicesByDate:searchDate];
    [self.InvoicesTableView reloadData];
}

-(NSMutableArray*)FindClientFromPdfInvoices :(NSMutableArray*)invoicesFromDateArray{
    _Loading.alpha =1;
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
            str = [str substringWithRange:NSMakeRange(10, 9)];
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
       _Loading.alpha =0;
    return clientsToPrint;
}

- (NSMutableArray*)findInvoicesByDate: (NSString*)dateToBeFound{
    
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSArray * results = [[NSArray alloc] init];
    results  =  [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSString *match = @"Invoice #*pdf";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF like %@", match];
    directoryContents = [results filteredArrayUsingPredicate:predicate];
    
    filteredTableData = [[NSMutableArray alloc] init];
    for (NSString* pdf in directoryContents)
    {
        if ([pdf rangeOfString:dateToBeFound].location != NSNotFound) {
            [filteredTableData addObject:pdf];
        }
    }
    
    return filteredTableData;
    
}

-(NSArray*)GetInvoiceLines: (NSString*)InvoiceLine{
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice_Lines" inManagedObjectContext:delegate.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"parentInvoiceDocNum= %@",InvoiceLine]];
    NSArray *Invoice_Lines= [delegate.managedObjectContext executeFetchRequest:request error:&error];
    return Invoice_Lines;
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
