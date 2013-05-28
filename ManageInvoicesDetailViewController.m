//
//  ManageInvoicesDetailViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageInvoicesDetailViewController.h"
#import "Product.h"
#import "Invoice.h"
#import "Invoice_Lines.h"

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveInvoice:(id)sender {
    //CYNTHIA STUFF
    // the array with the invoice_line objects is "InvoiceLines" and the customer is is custID
    
    //name of invoice lines array is InvoiceLines
    //name of customer id variable is custID
    NSNumber *nextLineID;
    NSNumber *nextParentInvDocNum = [self getGetNextNumericValueForFieldName:@"docNum" withEntityName:@"Invoice"];
    NSDecimalNumber *unitPr;
    
    NSDecimalNumber *docTotal;
    
    //invoice lines array has productID and quantity
    for(int i = 0; i < [InvoiceLines count] ; i++)
    {
        Invoice_Lines *currentLine = (Invoice_Lines*)[InvoiceLines objectAtIndex:i];
       nextLineID = [self getGetNextNumericValueForFieldName: @"invoiceOrderID" withEntityName:@"Invoice_Lines"];
        
        currentLine.invoiceOrderID = [nextLineID stringValue];
        currentLine.parentInvoiceDocNum = [nextParentInvDocNum stringValue];
        

        
        //use product ID to get product info
        //fetch product using ID
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
     
        NSPredicate *p =[NSPredicate predicateWithFormat:@"productID = %@", currentLine.productID];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if([items count] == 1)
        {
            
            
            NSArray *result = [items objectAtIndex:0];
            NSDecimalNumber *unitPrice =[result valueForKey:@"unitPrice"];
            currentLine.lineTotal = unitPrice;
            currentLine.lineTotal = [currentLine.lineTotal decimalNumberByMultiplyingBy:currentLine.quantity];
            NSLog(@"Linetotal: %@", currentLine.lineTotal);
            
        
            
            
            
        }
        else{
            NSLog(@"Error: There are more than two products in the database with the same ID.");
        }
        
        
        

        
        
        
    }
    
    
    
}

-(NSNumber*)getGetNextNumericValueForFieldName: (NSString*) fieldName withEntityName: (NSString*) entityName{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:delegate.managedObjectContext];
    
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    
    [request setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:fieldName];
    
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:"
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    [expressionDescription setName:@"maxID"];
    
    [expressionDescription setExpression:maxExpression];
    
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error;
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    NSString *ID = @"";
    if (objects == nil || [objects count] == 0) {
        if([fieldName isEqualToString:@"docNum"])
        {
            return 00000000;
        }
        else if([fieldName isEqualToString:@"invoiceOrderID"])
        {
            return 0;
        }
    }
    else {
        
        if ([objects count] > 0) {
            ID = [[objects objectAtIndex:0] valueForKey:@"maxID"];
        }
    }
    
    int maxID = [ID integerValue];
    maxID = maxID+1;
    NSString *finalString = [NSString stringWithFormat:@"%i", maxID];
    
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //ID is a string
    
    return [f numberFromString:finalString];
    
    
    
    
    
}

- (IBAction)ReEditProductsSelected:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    
    // NSLog(@"%@",InvoiceLines);
}


@end
