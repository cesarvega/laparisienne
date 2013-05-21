//
//  ManageClientsDetailViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/19/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageClientsDetailViewController.h"
#import "Customer.h"

@interface ManageClientsDetailViewController ()

@end

@implementation ManageClientsDetailViewController
@synthesize addressOne, addressTwo, businessDescription, businessName;
@synthesize city, contactName, custID, email, fax, mobile, telefone, website, zipcode, state;
@synthesize ContactNameTextField, BusinessNameTextField , BusinessDescriptionTextField, AddressOneTextField;
@synthesize AdressTwoTextField, CityTextField, ZipcodeTextField, StateTextField, TelefoneTextField, FaxTextField;
@synthesize MobileTextField, WebSiteTextField, EmailTextField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [ContactNameTextField setText:contactName];
    [BusinessNameTextField setText:businessName];
    [BusinessDescriptionTextField setText:businessDescription];
    [AddressOneTextField setText:addressOne];
    [AdressTwoTextField setText:addressTwo];
    [CityTextField setText:city];
    [ZipcodeTextField setText:zipcode];
    [StateTextField setText:state];
    [TelefoneTextField setText:telefone];
    [FaxTextField setText:fax];
    [MobileTextField setText:mobile];
    [WebSiteTextField setText:website];
    [EmailTextField setText:email];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma-mark UITextField Delegade Methods

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self animateTextField: textField up: YES];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled=NO;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
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
        const int movementDistance = 140; // tweak as needed
        const float movementDuration = 0.5f; // tweak as needed
        
        int movement = (up ? -movementDistance : movementDistance);
        
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.view.frame = CGRectOffset(self.view.frame, 0, movement);
        [UIView commitAnimations];
    }
}

#pragma Mark Form Methods


- (IBAction)SaveClient:(id)sender {
    
    NSManagedObjectContext *context = [delegate managedObjectContext];
   Customer *user = [NSEntityDescription
                            insertNewObjectForEntityForName:@"Customer"
                           inManagedObjectContext:context];
    
    user.addressOne = AddressOneTextField.text;
    
    user.addressTwo = AdressTwoTextField    .text;
    user.businessDescription = BusinessDescriptionTextField.text;
    user.businessName = BusinessNameTextField.text;
    user.city = CityTextField.text;
    user.contactName = ContactNameTextField.text;
    user.email = EmailTextField.text;
    user.fax = FaxTextField.text;
    user.mobile = MobileTextField.text;
    user.state = StateTextField.text;
    user.telefone = TelefoneTextField.text;
    user.website = WebSiteTextField.text;
    user.zipcode = ZipcodeTextField.text;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:context];
    
    [request setEntity:entity];
    
    
    
    // Specify that the request should return dictionaries.
    
    [request setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"custID"];
    
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
        
        // Handle the error.
        
    }
    
    else {
        
        if ([objects count] > 0) {
            
            NSLog(@"Max custID: %@", [[objects objectAtIndex:0] valueForKey:@"maxCustID"]);
            
            custID = [[objects objectAtIndex:0] valueForKey:@"maxCustID"];
            
                      
            if(custID == nil)
            {
                custID = @"0";
            }
            NSLog(custID);
        }
       
        
    }
    
    NSInteger *maxID = [custID integerValue];
    
    maxID = maxID+1;
    NSString *finalString = [NSString stringWithFormat:@"%d", maxID];
    
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //custID is a string
    user.custID = [f numberFromString:custID];
    
    
    

  
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"                                                        message:@"Client successfully saved."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
       
    }
    
    
    

    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
	if([title isEqualToString:@"OK"])
	{
		
        NSLog(@"Button OK was selected.");
        
        
        
	}
    
}
@end
