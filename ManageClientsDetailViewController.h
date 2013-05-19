//
//  ManageClientsDetailViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/19/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageClientsDetailViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic, retain) NSString * addressOne;
@property (nonatomic, retain) NSString * addressTwo;
@property (nonatomic, retain) NSString * businessDescription;
@property (nonatomic, retain) NSString * businessName;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSNumber * custID;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * telefone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * zipcode;

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
@property (strong, nonatomic) IBOutlet UIView *EmailTextField;
- (IBAction)SaveClient:(id)sender;


@end
