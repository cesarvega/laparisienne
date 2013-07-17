//
//  LogInViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/11/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "LogInViewController.h"
@interface LogInViewController ()

@end

@implementation LogInViewController

@synthesize Password,UserName,containerController,MainMenuViewControllerData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma-mark UITextField Delegade Methods

- (BOOL)textFieldShouldReturn:(UITextField*)aTextField{
    [aTextField resignFirstResponder];
     return YES;
}

#pragma-mark Buttons
- (IBAction)LoginButton:(id)sender {
//   
//    NSManagedObjectContext *context = [delegate managedObjectContext];
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription
//                                   entityForName:@"User" inManagedObjectContext:context];
//    NSError *error;
//    [fetchRequest setEntity:entity];
//    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
//    NSString *password;
//    NSString *userID;
//    NSString *userName ;
//    BOOL   isUser;
//     isUser = NO;
//    for (NSArray *item in innerStringdictionary) {
//              
//        password = [NSString stringWithFormat:@"%@",[item valueForKey:@"password"]];
//        userID = [NSString stringWithFormat:@"%@",[item valueForKey:@"userID"]];
//        userName = [NSString stringWithFormat:@"%@",[item valueForKey:@"userName"]];
//
//        if([UserName.text isEqual: userName ] && [Password.text isEqual:password]){
//            delegate.LoginUserName = UserName.text;
//            delegate.LoginUserPassword = Password.text;
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//            
//            MainMenuViewController *centerController = (MainMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
//            
//            [self presentViewController:centerController animated:YES completion:nil];
//            isUser = NO;
//            
//        }else { isUser = YES;   }
//    }
//    
//    if (isUser == YES) {
//        NSString *successMsg = [NSString stringWithFormat:@"Wrong User Name or Password"];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try Again"
//                                                        message:successMsg
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles: nil];
        //[alert show];
        

//    }
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

   MainMenuViewController *centerController = (MainMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    
    [self presentViewController:centerController animated:YES completion:nil];
    
}

@end
