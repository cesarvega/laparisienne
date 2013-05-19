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
    
    Customer * Info ;
    
    Info.contactName = ContactNameTextField .text;
    Info.businessName = BusinessDescriptionTextField.text;
    Info.businessDescription = BusinessDescriptionTextField.text;
    Info.addressOne = AddressOneTextField.text;
    
//    [BusinessDescriptionTextField setText:businessDescription];
//    [AddressOneTextField setText:addressOne];
//    [AdressTwoTextField setText:addressTwo];
//    [CityTextField setText:city];
//    [ZipcodeTextField setText:zipcode];
//    [StateTextField setText:state];
//    [TelefoneTextField setText:telefone];
//    [FaxTextField setText:fax];
//    [MobileTextField setText:mobile];
//    [WebSiteTextField setText:website];
//    [EmailTextField setText:email];

    
    
}
@end
