//
//  ManageProductsDetailViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageProductsDetailViewController.h"
#import "Product.h"
@interface ManageProductsDetailViewController ()

@end

@implementation ManageProductsDetailViewController
@synthesize name,productDescription,productID,unitPrice, ProductNameTextField, UnitPriceTextField, PorductDescriptionTextField;
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
                    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{

    [UnitPriceTextField setText:[unitPrice stringValue]];
    [ProductNameTextField setText:name];
    [PorductDescriptionTextField setText:productDescription];

}

- (IBAction)SaveProduct:(id)sender {
    NSManagedObjectContext *context = [delegate managedObjectContext];
    Product *product = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Product"
                      inManagedObjectContext:context];

    product.name = ProductNameTextField.text;
    product.productDescription = PorductDescriptionTextField.text;
   // int unitPriceConvert = [UnitPriceTextField.text ];
  //  product.unitPrice =[NSDecimalNumber nu:unitPriceConvert];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
    
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
    NSString *custID = @"";
    if (objects == nil) {
        
    }
    else {
        
        if ([objects count] > 0) {
            custID = [[objects objectAtIndex:0] valueForKey:@"maxCustID"];
        }
    }
    
    NSInteger *maxID = [custID integerValue];
    maxID = maxID+1;
    NSString *finalString = [NSString stringWithFormat:@"%i", maxID];
    
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //productID is a string
    
    NSLog(@"My string %@"  ,finalString);
    product.productID = [f numberFromString:finalString];
        if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"  message:@"product successfully saved."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	if([title isEqualToString:@"OK"])
	{
		
        NSLog(@"Button OK was selected.");
        
	}
    
}

-(void)SetTextLabelsText{
    
    [ProductNameTextField setText:name];
    [PorductDescriptionTextField setText:productDescription];
    [UnitPriceTextField setText:[unitPrice stringValue]];
   }


@end
