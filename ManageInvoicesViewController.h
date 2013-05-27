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

@interface ManageInvoicesViewController : UIViewController{
    AppDelegate *delegate;
}
@property (strong, nonatomic)NSArray* CustomersPickerDataSrc ;
@property (strong, nonatomic)NSArray* ProductsPickerDataSrc ;

@property (nonatomic, retain) NSMutableArray * businessNames;
@property (nonatomic, retain) NSMutableArray * contactNames;
@property (nonatomic, retain) NSMutableArray * custIDValues;
@end
