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
@synthesize InvoicesTableView,InvoiceID,searchBar, isFiltered,filteredTableData,allTableData;

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
    searchBar.delegate = (id)self;
    isFiltered = @"FALSE";
    
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
        return [directoryContents count];
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
        cell.textLabel.text = [directoryContents objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    indexPathForDeletion =indexPath;
    InvoiceID = [directoryContents objectAtIndex:indexPath.row];
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
         NSError *error = nil;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* fullPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,[directoryContents objectAtIndex:indexPathForDeletion.row] ];
        [[NSFileManager defaultManager] removeItemAtPath: fullPath error:&error];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PDFInvoices"];
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

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
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
                NSLog(@"string does not contain bla");
                [filteredTableData addObject:pdf];
                isFiltered = @"TRUE";
            }else{ }
        }
    }
    
    [self.InvoicesTableView reloadData];
}
@end
