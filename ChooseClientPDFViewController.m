//
//  ChooseClientPDFViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 7/16/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ChooseClientPDFViewController.h"
@implementation ClientPDFDetailCell
@synthesize ClientName;
@end

@interface ChooseClientPDFViewController ()

@end

@implementation ChooseClientPDFViewController
@synthesize InvoiceDatePicker,ClientPDFTableView,SelectedClientsIndexPaths;
ClientPDFDetailCell * cell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self initArrays];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    contextForHeader = [delegate managedObjectContext];
    [InvoiceDatePicker  addTarget:self action:@selector(changeValues:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMdd"];
    NSString *dateString = [dateFormat stringFromDate:[InvoiceDatePicker date]];
     searchDate =dateString;
    [self changeValues:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma search invoices by date methods

-(void)changeValues:(id)sender{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMdd"];
    NSString *dateString = [dateFormat stringFromDate:[InvoiceDatePicker date]];
     int dateDocNum = [dateString intValue];
    searchDate =[NSString stringWithFormat:@"%d",dateDocNum];
    NSMutableArray* invoicesFromDateArray = [self findInvoicesByDate:searchDate];
    [self FindClientFromPdfInvoices:invoicesFromDateArray];
    [self.ClientPDFTableView reloadData];
    
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
                    NSString *newPDFName = [NSString stringWithFormat:@"%@ %@ %@.%@",@"Invoice #",invoiceNumbers,businessNames,@"pdf"];
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
    NSString *match = @"Invoice #*pdf";
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

-(NSArray*)GetInvoicesByInvoiceID : (NSNumber*)InvoiceID{
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"invoiceID = %@",InvoiceID]];
    NSArray *invoices= [contextForHeader executeFetchRequest:request error:&error];
    return invoices;
}

#pragma table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [clientsToPrint count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ClientPDFDetailCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[ClientPDFDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.ClientName.text=[clientsToPrint objectAtIndex:indexPath.row];
    cell.InvocieDate.text =[InvoiceDate objectAtIndex:indexPath.row];
    cell.InvocieNumber.text =[InvoiceNumbers objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor brownColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [SelectedClientsIndexPaths addObject:indexPath];
    IndexTracing=indexPath;
    cell = (ClientPDFDetailCell *) [ClientPDFTableView cellForRowAtIndexPath:indexPath];
    [DocumentsToPrint addObject:cell.InvocieNumber.text];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    IndexTracing=indexPath;
    cell = (ClientPDFDetailCell *) [ClientPDFTableView cellForRowAtIndexPath:indexPath];
    [SelectedClientsIndexPaths removeObject:indexPath];
    [DocumentsToPrint removeObject:cell.InvocieNumber.text];

}

-(void)initArrays{

    DocumentsToPrint = [[NSMutableArray alloc]init];
}

- (IBAction)PrintInvoices:(id)sender {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSMutableArray * pathss = [[NSMutableArray alloc]init];
    for (int i =0; i<[DocumentsToPrint count]; i++) {
        NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:    [DocumentsToPrint objectAtIndex:i]];
        NSData *pdfData = [NSData dataWithContentsOfFile:pdfPath];
        [pathss addObject:pdfData];
    }
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:    [DocumentsToPrint objectAtIndex:0]];
    NSData *pdfData = [NSData dataWithContentsOfFile:pdfPath];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    if  (pic && [UIPrintInteractionController canPrintData:pdfData] ) {
        [pic.delegate self ];
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName =  [DocumentsToPrint objectAtIndex:0];
        printInfo.duplex = UIPrintInfoDuplexNone;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItems = pathss;
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
        ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error)
                NSLog(@"FAILED! due to error in domain %@ with error code %ld",
                      error.domain, (long)error.code);
        };
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            //[pic presentFromBarButtonItem:self.printButton animated:YES
                   //     completionHandler:completionHandler];
          }
         else {
        [pic presentAnimated:YES completionHandler:completionHandler];
         }
    }
}
- (BOOL)presentFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion{return false;}

- (BOOL)presentFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated completionHandler:(UIPrintInteractionCompletionHandler)completion{

        return false;
}
@end
