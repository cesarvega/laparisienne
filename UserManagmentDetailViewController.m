//
//  UserManagmentDetailViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "UserManagmentDetailViewController.h"
#import "User.h"
@interface UserManagmentDetailViewController ()

@end

@implementation UserManagmentDetailViewController
@synthesize userNameTextField, passwordTestField;
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
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveButton:(id)sender {
    
    if(userID == nil)
    {
        User *user = [NSEntityDescription
                            insertNewObjectForEntityForName:@"User"
                            inManagedObjectContext:delegate.managedObjectContext];
        user.userName = userNameTextField.text;
        user.password = passwordTestField.text;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:delegate.managedObjectContext];
        
        [request setEntity:entity];
        
        // Specify that the request should return dictionaries.
        
        [request setResultType:NSDictionaryResultType];
        
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"userID"];
        
        NSExpression *maxCustIDExpression = [NSExpression expressionForFunction:@"max:"
                                                                      arguments:[NSArray arrayWithObject:keyPathExpression]];
        
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        
        [expressionDescription setName:@"maxCustID"];
        
        [expressionDescription setExpression:maxCustIDExpression];
        
        [expressionDescription setExpressionResultType:NSDecimalAttributeType];
        
        [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
        NSError *error;
        NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:&error];
        NSString *prodID = @"";
        if (objects == nil) {
            
        }
        else {
            
            if ([objects count] > 0) {
                prodID = [[objects objectAtIndex:0] valueForKey:@"maxCustID"];
            }
        }
        
        int maxID = [prodID integerValue];
        maxID = maxID+1;
        NSString *finalString = [NSString stringWithFormat:@"%i", maxID];
        
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        
        user.userID = [f numberFromString:finalString];
        
        if (![delegate.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"  message:@"User successfully saved."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
    
     
    

}
@end
