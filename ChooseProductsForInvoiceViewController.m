//
//  ChooseProductsForInvoiceViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/27/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ChooseProductsForInvoiceViewController.h"
#import "Invoice_Lines.h"
@implementation ProductsDetailCell
@synthesize ProductPriceLabel,ProductDescriptionLabel,ProductNameLabel,ProductQuantity,ProductID;
@end
@interface ChooseProductsForInvoiceViewController ()

@end

@implementation ChooseProductsForInvoiceViewController
 ProductsDetailCell *cell;
@synthesize Productname, productID, productDescription,unitPrice,SelectedProductsIndexPaths,ProductsTableView,ClientID;

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
    
     contextForInvoiceLines = [delegate managedObjectContext];
    [self FindProducts];
	// Do any additional setup after loading the view.
    SelectedProductsIndexPaths = [[NSMutableArray alloc] init];
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
    cell.ProductPriceLabel.text =[unitPrice objectAtIndex:indexPath.row];
    cell.ProductID.text=[productID objectAtIndex:indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
     [SelectedProductsIndexPaths addObject:indexPath];
    cell = (ProductsDetailCell *) [ProductsTableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell = (ProductsDetailCell *) [ProductsTableView cellForRowAtIndexPath:indexPath];
    [SelectedProductsIndexPaths removeObject:indexPath];
    
}

-(void)FindProducts{
    
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
    
    NSMutableArray* InvoiceLinesArray = [[NSMutableArray alloc] init];

    if ([SelectedProductsIndexPaths count]>0){
    
        for (int i=0; i<[SelectedProductsIndexPaths count];i++) {
            
       
            
            cell = (ProductsDetailCell *) [ProductsTableView cellForRowAtIndexPath:[ SelectedProductsIndexPaths objectAtIndex:i] ];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber * Quantity = [f numberFromString:cell.ProductQuantity.text];
            Invoice_Lines * CurrentInvoice_Lines =[NSEntityDescription
                                                   insertNewObjectForEntityForName:@"Invoice_Lines"
                                                   inManagedObjectContext:contextForInvoiceLines];
            CurrentInvoice_Lines.productID = cell.ProductID.text;
            CurrentInvoice_Lines.quantity =Quantity ;
            
            if (Quantity==nil) {
                NSString *errorMSG = [NSString stringWithFormat:@"%@ %@",@"Please Review the quantity field for ",cell.ProductNameLabel.text];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Type a Quantity"
                                                                message:errorMSG
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
                [alert show];
                break;
            }
            
            [InvoiceLinesArray addObject:CurrentInvoice_Lines];
            
          }
      
        // after done call Cynthias Mehtod the client id is in the varable "ClientID"
        // like [self CynthiasMetodName:InvoiceLinesArray];
        
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


@end
