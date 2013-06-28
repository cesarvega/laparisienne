//
//  LogInViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/11/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"
#import "AppDelegate.h"
@interface LogInViewController : UIViewController<UITextFieldDelegate>{
    AppDelegate *delegate;
}

@property (strong,nonatomic)MainMenuViewController* MainMenuViewControllerData;
@property (retain, nonatomic) UIViewController *containerController;
@property (strong, nonatomic) IBOutlet UITextField *UserName;
@property (strong, nonatomic) IBOutlet UITextField *Password;



- (IBAction)LoginButton:(id)sender;
@end
