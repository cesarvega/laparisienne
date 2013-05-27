//
//  ManageInvoicesViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ManageInvoicesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UIButton *printButton;
    UIPrintInteractionController *printController;
    
    AppDelegate *delegate;
    
}
@property (strong, nonatomic)NSArray* CustomersPickerDataSrc ;
@property (strong, nonatomic)NSArray* ProductsPickerDataSrc ;

@property (nonatomic, retain) NSMutableArray * businessName;
@property (nonatomic, retain) NSMutableArray * contactsNames;
@end
