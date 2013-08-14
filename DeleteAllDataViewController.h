//
//  DeleteAllDataViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 8/13/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Invoice_Lines.h"
#import "Invoice.h"
@interface DeleteAllDataViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    AppDelegate *delegate;
    NSString * searchDate;
    NSArray * directoryContents;
    NSArray *InvoicesPdfToBeDeleted;
    NSManagedObjectContext *context;
}
- (IBAction)DeleteAllData:(id)sender;

@end
