//
//  ChooseProductsForInvoiceViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/27/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ChooseProductsForInvoiceViewController.h"
#import "Invoice_Lines.h"
#import "ManageInvoicesDetailViewController.h"
@implementation ProductsDetailCell
@synthesize ProductPriceLabel,ProductDescriptionLabel,ProductNameLabel,ProductQuantity,ProductID,addImage;

@end
@interface ChooseProductsForInvoiceViewController ()

@end

@implementation ChooseProductsForInvoiceViewController
ProductsDetailCell *cell;
@synthesize Productname, productID, productDescription,unitPrice,SelectedProductsIndexPaths,ProductsTableView,ClientID,InvoiceID,quantity;
@synthesize TextColor,ImageName;
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
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[ProductsDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.ProductID.text=[productID objectAtIndex:indexPath.row];
    cell.ProductNameLabel.text =  [Productname objectAtIndex:indexPath.row];
    cell.ProductDescriptionLabel.text =[productDescription objectAtIndex:indexPath.row];
    cell.ProductPriceLabel.text =[unitPrice objectAtIndex:indexPath.row];
    cell.ProductQuantity.text = [quantity objectAtIndex:indexPath.row];
    cell.ProductQuantity.textColor =[TextColor objectAtIndex:indexPath.row];
    cell.ProductPriceLabel.textColor =[TextColor objectAtIndex:indexPath.row];
    [cell.addImage setImage:[UIImage imageNamed:[ImageName objectAtIndex:indexPath.row]]];
    if ([[ImageName objectAtIndex:indexPath.row] isEqual:@"add.png"]) {
        [cell.ProductQuantity setEnabled:YES];
        [cell.ProductPriceLabel setEnabled:YES];

    }else{
        [cell.ProductQuantity setEnabled:NO];
        [cell.ProductPriceLabel setEnabled:NO];
    }
      cell.textLabel.textColor = [UIColor brownColor];
       return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [SelectedProductsIndexPaths addObject:indexPath];
    IndexTracing=indexPath;
    cell = (ProductsDetailCell *) [ProductsTableView cellForRowAtIndexPath:indexPath];
    [unitPrice replaceObjectAtIndex:IndexTracing.row withObject:cell.ProductPriceLabel.text];
    [quantity replaceObjectAtIndex:IndexTracing.row withObject:cell.ProductQuantity.text];
    [productID replaceObjectAtIndex:IndexTracing.row withObject:cell.ProductID.text];
    UIColor * whiteColor = [UIColor greenColor];
    [cell.ProductQuantity setTextColor: whiteColor];
    [cell.ProductPriceLabel setTextColor:whiteColor];
    [TextColor replaceObjectAtIndex:IndexTracing.row withObject:whiteColor];
    [ImageName replaceObjectAtIndex:IndexTracing.row withObject:@"added.png"];
    [cell.ProductQuantity setEnabled:NO];
    [cell.ProductPriceLabel setEnabled:NO];
  }

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = (ProductsDetailCell *) [ProductsTableView cellForRowAtIndexPath:indexPath];
    [SelectedProductsIndexPaths removeObject:indexPath];
     UIColor * cyanColor = [UIColor whiteColor];
    [cell.ProductQuantity setTextColor: cyanColor];
    [cell.ProductPriceLabel setTextColor:cyanColor];
    [cell.ProductQuantity setEnabled:YES];
    [cell.ProductPriceLabel setEnabled:YES];
    [cell.ProductPriceLabel setTextColor:cyanColor];
    [TextColor replaceObjectAtIndex:IndexTracing.row withObject:cyanColor];
    [ImageName replaceObjectAtIndex:IndexTracing.row withObject:@"add.png"];
   
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
        [quantity addObject:@""];
        UIColor * cyanColor = [UIColor cyanColor];
        [TextColor addObject:cyanColor];
        [ImageName addObject:@"add.png"];

    }
}

-(void)InitArraysToHoldData{
    Productname = [[NSMutableArray alloc] init];
    productDescription = [[NSMutableArray alloc] init];
    productID = [[NSMutableArray alloc] init];
    unitPrice = [[NSMutableArray alloc] init];
    quantity = [[NSMutableArray alloc] init];
    TextColor = [[NSMutableArray alloc] init];
    ImageName = [[NSMutableArray alloc] init];
    
}

- (IBAction)StoreInvocie:(id)sender {
    
    NSMutableArray* InvoiceLinesArray = [[NSMutableArray alloc] init];
    bool invoiceincomplete = YES;
    if ([SelectedProductsIndexPaths count]>0){
        
        for (int i=0; i<[SelectedProductsIndexPaths count];i++) {
            
            cell = (ProductsDetailCell *) [ProductsTableView cellForRowAtIndexPath:[ SelectedProductsIndexPaths objectAtIndex:i] ];
            Invoice_Lines * CurrentInvoice_Lines =[NSEntityDescription  insertNewObjectForEntityForName:@"Invoice_Lines"
                                                                                 inManagedObjectContext:contextForInvoiceLines];
            NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
            [f setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSIndexPath* index = [ SelectedProductsIndexPaths objectAtIndex:i];
            NSNumber * myProductID = [f numberFromString:[productID objectAtIndex:index.row]];
            CurrentInvoice_Lines.productID = myProductID;
            CurrentInvoice_Lines.quantity = [quantity objectAtIndex:index.row];
            CurrentInvoice_Lines.unitPrice =  [unitPrice objectAtIndex:index.row];
            if ([CurrentInvoice_Lines.quantity isEqual:@""]||[CurrentInvoice_Lines.unitPrice isEqual:@""]) {
                invoiceincomplete =NO;
                NSString *errorMSG = [NSString stringWithFormat:@"%@ %@",@"Please Review the quantity field for ",cell.ProductNameLabel.text];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Type a Quantity"message:errorMSG delegate:nil
                                                      cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                break;
            }else{
                
                [InvoiceLinesArray addObject:CurrentInvoice_Lines];
            }
        }
        
    }else{
        invoiceincomplete =NO;
        NSString *successMsg = [NSString stringWithFormat:@"%@",@"Please select products for the invoice."];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Products Selected" message:successMsg
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    if (invoiceincomplete){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        ManageInvoicesDetailViewController * InvoiceDetailView = (ManageInvoicesDetailViewController*)
        [storyboard instantiateViewControllerWithIdentifier:@"invoicesDetails"];
        [InvoiceDetailView setInvoiceLines:InvoiceLinesArray];
        [InvoiceDetailView setCustID:ClientID];
        [InvoiceDetailView setInvoiceID:InvoiceID];
        InvoiceDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:InvoiceDetailView animated:YES completion:nil];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	BOOL isNumeric=FALSE;
	if ([string length] == 0)
	{
		isNumeric=TRUE;
	}
	else
	{
		
		if ( [string compare:[NSString stringWithFormat:@"%d",0]]==0 || [string compare:[NSString stringWithFormat:@"%d",1]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",2]]==0 || [string compare:[NSString stringWithFormat:@"%d",3]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",4]]==0 || [string compare:[NSString stringWithFormat:@"%d",5]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",6]]==0 || [string compare:[NSString stringWithFormat:@"%d",7]]==0
			|| [string compare:[NSString stringWithFormat:@"%d",8]]==0 || [string compare:[NSString stringWithFormat:@"%d",9]]==0)
		{
			isNumeric=TRUE;
		}
		else
		{
			unichar mychar=[string characterAtIndex:0];
			if (mychar==46)
			{
				int i;
				for (i=0; i<[textField.text length]; i++)
				{
                    
					unichar c = [textField.text characterAtIndex: i];
					if(c==46)
						return FALSE;
				}
				
                isNumeric=TRUE;
			}
		}
	}
    
	return isNumeric;
}
@end
