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
    //productID is a string
    
    NSLog(@"My string %@"  ,finalString);
    product.productID = [f numberFromString:finalString];
        if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"  message:@"product successfully saved."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSString *titles = [alertView buttonTitleAtIndex:buttonIndex];
	if([titles isEqualToString:@"OK"])
	{
		
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
        UIViewController *manageProdcutsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:@"ManageProducts"];
        
        [self presentViewController:manageProdcutsViewController animated:YES completion:nil];
	}
    
}

-(void)SetTextLabelsText{
    
    [ProductNameTextField setText:name];
    [PorductDescriptionTextField setText:productDescription];
    [UnitPriceTextField setText:[unitPrice stringValue]];
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
