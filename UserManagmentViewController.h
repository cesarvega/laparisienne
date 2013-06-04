//
//  UserManagmentViewController.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/12/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserManagmentViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    NSMutableArray *usersArray;
     NSIndexPath *indexPathForDeletion;
    AppDelegate *delegate;
}
@property (nonatomic, retain) NSMutableArray * userNames;
@property (nonatomic, retain) NSMutableArray *passwords;
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
- (IBAction)createUser:(id)sender;

@end
