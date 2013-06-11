//
//  PDFInvoicesViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 6/10/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ReaderViewController.h"
@interface PDFInvoicesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,ReaderViewControllerDelegate>{
    NSArray * directoryContents;
    NSIndexPath *indexPathForDeletion;
}

@property (strong, nonatomic) IBOutlet UITableView *InvoicesTableView;

@end