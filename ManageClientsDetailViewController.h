//
//  ManageClientsDetailViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/19/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ManageClientsDetailViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    AppDelegate *delegate;
    NSManagedObjectContext *context;
    
}
@property (strong, nonatomic) NSString * contactName;
@property (strong, nonatomic) NSString * addressOne;
@property (strong, nonatomic) NSString * addressTwo;
@property (strong, nonatomic) NSString * businessDescription;
@property (strong, nonatomic) NSString * businessName;
@property (strong, nonatomic) NSString * city;
@property (strong, nonatomic) NSNumber * custIDValue;
@property (strong, nonatomic) NSString * email;
@property (strong, nonatomic) NSString * fax;
@property (strong, nonatomic) NSString * mobile;
@property (strong, nonatomic) NSString * state;
@property (strong, nonatomic) NSString * telefone;
@property (strong, nonatomic) NSString * website;
@property (strong, nonatomic) NSString * zipcode;

@property (strong, nonatomic) IBOutlet UITextField *ContactNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *BusinessNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *BusinessDescriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *AddressOneTextField;
@property (strong, nonatomic) IBOutlet UITextField *AdressTwoTextField;
@property (strong, nonatomic) IBOutlet UITextField *CityTextField;
@property (strong, nonatomic) IBOutlet UITextField *StateTextField;
@property (strong, nonatomic) IBOutlet UITextField *ZipcodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *TelefoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *MobileTextField;
@property (strong, nonatomic) IBOutlet UITextField *FaxTextField;
@property (strong, nonatomic) IBOutlet UITextField *WebSiteTextField;
@property (strong, nonatomic) IBOutlet UITextField *EmailTextField;
- (IBAction)SaveClient:(id)sender;


@end
