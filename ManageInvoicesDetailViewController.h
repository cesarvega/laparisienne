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

@interface ManageInvoicesDetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ReaderViewControllerDelegate>{
    AppDelegate *delegate;
    Invoice_Lines *invoicesLines;
    NSManagedObjectContext *contextForHeader;
    NSIndexPath *indexPathForDeletion;
}
@property (strong, nonatomic) NSMutableArray * InvoiceLines;
@property (weak, nonatomic) IBOutlet UILabel *PONumberTextField;
@property (strong, nonatomic) NSNumber * custID;
@property (weak, nonatomic) IBOutlet UILabel *customerPOLabel;
@property (strong, nonatomic) NSNumber * InvoiceID;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceNumberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceDepartmentTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *BusinessNameTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *InvoiceDateTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *ClientAddressTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *ClientNameTextLabel;

#pragma Mark Prototype variables
@property (nonatomic, retain) NSMutableArray * Productname;
@property (nonatomic, retain) NSMutableArray * productDescription;
@property (nonatomic, retain) NSMutableArray * productID;
@property (nonatomic, retain) NSMutableArray * unitPrice;
@property (nonatomic, retain) NSMutableArray * quantity;
@property (nonatomic, retain) NSMutableArray * lineTotal;
@property (nonatomic, retain) NSMutableArray *SelectedProductsIndexPaths;
@property (strong, nonatomic) IBOutlet UITableView *ProductsTableView;
@property (nonatomic, retain) NSNumber * ClientID;


- (IBAction)SaveInvoice:(id)sender;
- (IBAction)ReEditProductsSelected:(id)sender;
- (IBAction)PrintPdf:(id)sender;
@end

#pragma Mark Prototype cell labels & class
@interface ProductsReviewDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ProductNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductQuantity;
@end
