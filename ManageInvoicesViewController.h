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
}
@property (strong, nonatomic)NSArray* CustomersPickerDataSrc ;
@property (strong, nonatomic)NSArray* ProductsPickerDataSrc ;
@property (strong, nonatomic)NSMutableArray* invoicesDocNums;
@property (strong, nonatomic)NSMutableArray* invoiceDocDates;
@property (strong, nonatomic) NSNumber * custIDValue;
- (IBAction)CreateANewInvoiceButton:(id)sender;

@end
