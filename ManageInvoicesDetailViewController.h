//
//  ManageInvoicesDetailViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"
#import "Invoice_Lines.h"
@interface ManageInvoicesDetailViewController : UIViewController

{
    Invoice_Lines *invoicesLines;
}
@property (nonatomic, retain) NSNumber * custID;
@property (nonatomic, retain) NSNumber * InvoiceID;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceNumberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceDepartmentTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *BusinessNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceDateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *ClientAddressTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *ClientNameTextLabel;

@end
