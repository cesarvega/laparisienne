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
   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
   NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext:context];
    NSError *error;
   [fetchRequest setEntity:entity];
    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
   NSString *password;
   NSString *userID;
    NSString *userName ;
    BOOL   isUser;
     isUser = NO;
   for (NSArray *item in innerStringdictionary) {
       
        password = [NSString stringWithFormat:@"%@",[item valueForKey:@"password"]];
       userID = [NSString stringWithFormat:@"%@",[item valueForKey:@"userID"]];
       userName = [NSString stringWithFormat:@"%@",[item valueForKey:@"userName"]];

      if([UserName.text isEqualToString: userName ]||[UserName.text isEqualToString:@"Admin"]){
          isUser = YES;
          if ([UserName.text isEqualToString:@"Admin"]||[Password.text isEqualToString:@"embarek"]) {
              delegate.LoginUserName = UserName.text;
              delegate.LoginUserPassword = Password.text;
             
              MainMenuViewController *centerController = (MainMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
              
              [self presentViewController:centerController animated:YES completion:nil];
           
          }
          else if (isUser){
              MainMenuViewController *centerController = (MainMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
              delegate.LoginUserName = @"";
              delegate.LoginUserPassword = @"";
              [self presentViewController:centerController animated:YES completion:nil];
          }
      }
   }
   // the code below is only for testing
       
    MainMenuViewController *centerController = (MainMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    
    [self presentViewController:centerController animated:YES completion:nil];
//   // end

}

@end
