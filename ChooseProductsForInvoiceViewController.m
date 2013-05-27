//
//  ChooseProductsForInvoiceViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/27/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ChooseProductsForInvoiceViewController.h"
#import "Invoice_Lines.h"
#import "Product.h"
#import "Invoice.h"
@implementation ProductsDetailCell
@synthesize ProductPriceLabel,ProductDescriptionLabel,ProductNameLabel,ProductQuantity;
@end
@interface ChooseProductsForInvoiceViewController ()

@end

@implementation ChooseProductsForInvoiceViewController
 ProductsDetailCell *cell;
@synthesize Productname, productID, productDescription,unitPrice,SelectedProductsIdArray;

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
    [self FindProdcuts];
	// Do any additional setup after loading the view.
    SelectedProductsIdArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Productname count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ProducDetailsCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProductsDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.ProductNameLabel.text =  [Productname objectAtIndex:indexPath.row];
    cell.ProductDescriptionLabel.text =[productDescription objectAtIndex:indexPath.row];
    cell.ProductPriceLabel.text =[productDescription objectAtIndex:indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    Invoice_Lines * CurrentInvoice_Lines;
    CurrentInvoice_Lines.productID =[productID objectAtIndex:indexPath.row];
     ProductsDetailCell *cell = (ProductsDetailCell *) [tableView cellForRowAtIndexPath:indexPath];
    cell.ProductQuantity.text =@"200";
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"How many Products would you like"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Continue", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Continue"])
    {
        UITextField *mystring = [alertView textFieldAtIndex:0];
        NSLog(@"quanyityt : %@",mystring.text);
    }
}


- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;

    NSNumber *CurrentproductID = [productID objectAtIndex:indexPath.row];
    [SelectedProductsIdArray removeObject:CurrentproductID];
    
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return(YES);
}

-(void)FindProdcuts{
    
    [self  InitArraysToHoldData];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Product" inManagedObjectContext:context];
    NSError *error;
    [fetchRequest setEntity:entity];
    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSArray *item in innerStringdictionary) {
        
        NSString *Productnames = [NSString stringWithFormat:@"%@",[item valueForKey:@"name"]];
        NSString *productDescriptions = [NSString stringWithFormat:@"%@",[item valueForKey:@"productDescription"]];
        NSString *productIDs = [NSString stringWithFormat:@"%@",[item valueForKey:@"productID"]];
        NSString *unitPrices = [NSString stringWithFormat:@"%@",[item valueForKey:@"unitPrice"]];
        [Productname addObject:Productnames];
        [productDescription addObject:productDescriptions];
        [productID addObject:productIDs];
        [unitPrice addObject:unitPrices];
    }
}

-(void)InitArraysToHoldData{
    Productname = [[NSMutableArray alloc] init];
    productDescription = [[NSMutableArray alloc] init];
    productID = [[NSMutableArray alloc] init];
    unitPrice = [[NSMutableArray alloc] init];
}

- (IBAction)StoreInvocie:(id)sender {
    
    if ([SelectedProductsIdArray count]>0){
    
    
    
    
    }else{
                    NSString *successMsg = [NSString stringWithFormat:@"%@",@"Please select products for the invoice."];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Products Selected"
                                                                    message:successMsg
                                                                   delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
                                    [alert show];

        }
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

-(void)createInvoiceDocumentWithLines: (NSMutableArray*)invoiceLines andCustomerID: (NSNumber*) customerID{
    
    NSNumber *newInvoiceLineID = [self getNextNumericValueOfField:@"invoiceOrderID" fromEntity:@"Invoice_Lines"];
    
    NSNumber *newInvoiceDocNum = [self getNextNumericValueOfField: @"parentInvoiceDocNum" fromEntity:@"Invoice_Lines"];
    Invoice_Lines *currentLine;
    
    for(int i = 0; i < [invoiceLines count]; i++)
    {
        //query for product using invoice line product ID
        currentLine = [invoiceLines objectAtIndex:i];
        
        //set invoiceOrderID
       // currentLine.invoiceOrderID = newInvoiceLineID;
        
        //set parentinvoice document number
       // currentLine.parentInvoiceDocNum = newInvoiceDocNum;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSString *val = [currentLine productID];
        
        NSPredicate *p =[NSPredicate predicateWithFormat:@"productID = %@", val];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if([items count] == 1)
        {
            Product *lineProduct = (Product*)[items objectAtIndex:0];
           
            NSString *unitPrice = [lineProduct.unitPrice stringValue];
            NSString *quantity = [currentLine.quantity stringValue];
            NSDecimalNumber *decimalQuantity = [NSDecimalNumber decimalNumberWithString:quantity];
            
            decimalQuantity = [decimalQuantity decimalNumberByMultiplyingBy:lineProduct.unitPrice];
            currentLine.lineTotal = decimalQuantity;
            
            
            
        }
        
        //
        
           
    }
    
    
    //at this point, all lines are set in the table. i now have to create the invoice header document that these lines pertain to.
    /**
    Invoice *invoiceHeader = [NSEntityDescription
                        insertNewObjectForEntityForName:@"Invoice"
                        inManagedObjectContext:delegate.managedObjectContext];
    invoiceHeader.name = ProductNameTextField.text;
    invoiceHeader.productDescription = PorductDescriptionTextField.text;
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:UnitPriceTextField.text];
    invoiceHeader.unitPrice = decimal;
    // int unitPriceConvert = [UnitPriceTextField.text ];
    //  product.unitPrice =[NSDecimalNumber nu:unitPriceConvert];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:delegate.managedObjectContext];
    
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    
    [request setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"productID"];
    
    NSExpression *maxCustIDExpression = [NSExpression expressionForFunction:@"max:"
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    [expressionDescription setName:@"maxCustID"];
    
    [expressionDescription setExpression:maxCustIDExpression];
    
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSString *prodID = @"";
    if (objects == nil) {
        
    }
    else {
        
        if ([objects count] > 0) {
            prodID = [[objects objectAtIndex:0] valueForKey:@"maxCustID"];
        }
    }
    
    int maxID = [prodID integerValue];
    maxID = maxID+1;
    NSString *finalString = [NSString stringWithFormat:@"%i", maxID];
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    product.productID = [f numberFromString:finalString];
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"  message:@"Product successfully saved."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }

    **/
    
}
//this will return
-(NSNumber*)getNextNumericValueOfField: (NSString*)fieldName fromEntity: (NSString*) entityName{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:delegate.managedObjectContext];
    
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    
    [request setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:fieldName];
    
    NSExpression *maxCustIDExpression = [NSExpression expressionForFunction:@"max:"
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    [expressionDescription setName:@"maxID"];
    
    [expressionDescription setExpression:maxCustIDExpression];
    
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error;
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    NSString *mID = @"";
    if (objects == nil) {
        
        if([fieldName isEqualToString:@"parentInvoiceDocNum"])
        {
            NSNumber *firstDocNum = 00000000;
            return firstDocNum;
        }
        else if([fieldName isEqualToString:@"invoiceOrderID"])
        {
            NSNumber *firstInvoiceLineID = 0;
            return firstInvoiceLineID;
        }
        
    }
    else {
        
        if ([objects count] > 0) {
            mID = [[objects objectAtIndex:0] valueForKey:@"maxID"];
        }
    }
    
    int maxID = [mID integerValue];
    maxID = maxID+1;
    NSString *finalString = [NSString stringWithFormat:@"%i", maxID];
    
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //custID is a string
    
    NSLog(@"My string %@"  ,[f numberFromString:finalString]);
    return [f numberFromString:finalString];
     

}

@end
