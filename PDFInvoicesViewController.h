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
#import "AppDelegate.h"
@interface PDFInvoicesViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,ReaderViewControllerDelegate>{
    AppDelegate *delegate;

    NSArray * directoryContents;
    NSIndexPath *indexPathForDeletion;
    NSString* isFiltered;
    NSString* currentDate;
}
@property (strong, nonatomic)    NSNumber* InvoiceID;
@property (strong, nonatomic) IBOutlet UITableView *InvoicesTableView;
@property (nonatomic, strong) UIPopoverController *popController;
@property (strong, nonatomic) NSMutableArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (strong, nonatomic)  NSString* isFiltered;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString* currentDate;

@end
