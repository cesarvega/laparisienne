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
            str = [str stringByReplacingOccurrencesOfString:@".pdf"withString:@""];
            str =[str stringByReplacingOccurrencesOfString:@"Invoice # "withString:@""];
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
//    [cell.checkedPrintItemImage setImage:[UIImage imageNamed:@"add.png"]];
//    if ([@"" isEqual:@"add.png"]) {
//               
//    }else{
//     
//    }
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

@end
