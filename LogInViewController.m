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
    	// Do any additional setup after loading the view.
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
    
    MainMenuViewController *centerController = (MainMenuViewController *)[storyboard instantiateViewControllerWithIdentifier:@"mainMenu"];
    
    [self presentViewController:centerController animated:YES completion:nil];
    

    
}
@end
