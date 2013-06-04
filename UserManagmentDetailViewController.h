//
//  UserManagmentDetailViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserManagmentDetailViewController : UIViewController
{
    AppDelegate *delegate;
    NSNumber *userID;
}


@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * password;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTestField;
- (IBAction)SaveButton:(id)sender;

@end
