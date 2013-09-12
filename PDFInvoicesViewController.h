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
@interface PDFInvoicesViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate,ReaderViewControllerDelegate>{
    AppDelegate *delegate;
    NSString * searchDate;
    NSArray * directoryContents;
    NSIndexPath *indexPathForDeletion;
    NSString* isFiltered;
    NSString* currentDate;
    NSMutableArray* clientsToPrint;
    NSManagedObjectContext *contextForHeader;
    UIPrintInteractionController *printInteraction;
    NSMutableArray* InvoiceDate;
    NSMutableArray* InvoiceNumbers;
    NSMutableArray* InvoiceFiltered;
}

@property (strong, nonatomic)    NSNumber* InvoiceID;
@property (strong, nonatomic) IBOutlet UITableView *InvoicesTableView;
@property (nonatomic, strong) UIPopoverController *popController;
@property (strong, nonatomic) NSMutableArray* allTableData;
@property (strong, nonatomic) NSMutableArray* filteredTableData;
@property (strong, nonatomic)  NSString* isFiltered;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString* currentDate;
@property (strong, nonatomic) IBOutlet UIDatePicker *InvoiceDatePicker;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *Loading;

@end
