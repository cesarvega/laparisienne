//
//  DeleteSignedPdfViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 8/19/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface DeleteSignedPdfViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>{
    AppDelegate *delegate;
    NSString * searchDate;
    NSArray * directoryContents;
    NSArray *InvoicesPdfToBeDeleted;
}

- (IBAction)DeleteAllData:(id)sender;
@end
