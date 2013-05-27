//
//  ManageProductsViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
//added a comment
@interface ManageProductsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *delegate;
}

@property (nonatomic, retain) NSMutableArray * Productname;
@property (nonatomic, retain) NSMutableArray * productDescription;
@property (nonatomic, retain) NSMutableArray * productID;
@property (nonatomic, retain) NSMutableArray * unitPrice;
@end
