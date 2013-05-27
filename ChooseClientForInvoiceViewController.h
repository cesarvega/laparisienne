//
//  ChooseClientForInvoiceViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/27/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ChooseClientForInvoiceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
  AppDelegate *delegate;
}
@property (nonatomic, retain) NSMutableArray * businessName;
@property (nonatomic, retain) NSMutableArray * contactName;
@property (nonatomic, retain) NSMutableArray * custIDValue;
@end
