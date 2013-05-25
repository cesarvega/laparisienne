//
//  ManageProductsDetailViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Product.h"
@interface ManageProductsDetailViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>{
    
    AppDelegate *delegate;
    NSManagedObjectContext *context;
    Product *product;
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSNumber * productID;
@property (nonatomic, retain) NSDecimalNumber * unitPrice;
@property (strong, nonatomic) IBOutlet UITextField *ProductNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *PorductDescriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *UnitPriceTextField;

- (IBAction)SaveProduct:(id)sender;
@end
