//
//  ManageInvoicesViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Invoice_Lines.h"
#import "Invoice.h"

@interface ManageInvoicesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    AppDelegate *delegate;
    NSManagedObjectContext *context;
    NSIndexPath *indexPathForDeletion;
    NSArray * directoryContents;
}
@property (strong, nonatomic)NSArray* CustomersPickerDataSrc ;
@property (strong, nonatomic)NSArray* ProductsPickerDataSrc ;
@property (strong, nonatomic)NSMutableArray* invoicesDocNums;
@property (strong, nonatomic)NSMutableArray* invoiceDocDates;
@property (weak, nonatomic) IBOutlet UITableView *InvoicesTableView;
@property (strong, nonatomic)NSMutableArray* InvoiceID;
@property (strong, nonatomic) NSNumber * custIDValue;
@property (strong, nonatomic) NSString * BusinnesName;
- (IBAction)CreateANewInvoiceButton:(id)sender;

@end
