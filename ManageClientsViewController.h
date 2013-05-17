//
//  ManageClientsViewController.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/17/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ManageClientsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate   >
{
    AppDelegate *delegate;
}
@property (weak, nonatomic) IBOutlet UITableView *clientsTableView;
@property (weak, nonatomic) NSMutableArray *clientsArray;
@end
