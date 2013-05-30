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
#import "AppDelegate.h"
#import "ReaderViewController.h"

@interface ManageInvoicesDetailViewController : UIViewController<ReaderViewControllerDelegate>{
    AppDelegate *delegate;
    Invoice_Lines *invoicesLines;
    NSManagedObjectContext *contextForHeader;
}
@property (nonatomic, retain) NSMutableArray * InvoiceLines;
@property (nonatomic, retain) NSNumber * custID;
@property (nonatomic, retain) NSNumber * InvoiceID;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceNumberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceDepartmentTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *BusinessNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceDateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *ClientAddressTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *ClientNameTextLabel;
- (IBAction)SaveInvoice:(id)sender;
- (IBAction)ReEditProductsSelected:(id)sender;

- (IBAction)PrintPdf:(id)sender;
@end
