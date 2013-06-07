//
//  UserManagmentViewController.m
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/12/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "UserManagmentViewController.h"
#import "User.h"
#import "UserManagmentDetailViewController.h"

@interface UserManagmentViewController ()

@end

@implementation UserManagmentViewController
@synthesize userNames, passwords, usersTableView;
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
    [self FindUsers];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [usersArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =  [userNames objectAtIndex:indexPath.row];
    NSLog(@"user id: %@", [userNames objectAtIndex:indexPath.row]);
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    UserManagmentDetailViewController * userManagementDetailView = (UserManagmentDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"userManagementDetailView"];
    
    userManagementDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if ([userManagementDetailView view]) {
        [userManagementDetailView setUserName:[userNames objectAtIndex:indexPath.row]];
        [userManagementDetailView setPassword:[passwords objectAtIndex:indexPath.row]];
      
        
  
        
    }
    [self presentViewController:userManagementDetailView animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        // [self.dataArray removeObjectAtIndex:indexPath.row];
        indexPathForDeletion = indexPath;
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete this user?"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
        
        [message show];
        
    }
    
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Yes"])
    {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSString *val = [userNames  objectAtIndex:indexPathForDeletion.row];
        NSPredicate *p =[NSPredicate predicateWithFormat:@"userID = %@", val];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        
        
        for (User *product in items) {
            [delegate.managedObjectContext deleteObject:product];
            NSLog(@"object deleted");
        }
        if (![delegate.managedObjectContext save:&error]) {
            NSLog(@"Error deleting - error:%@",error);
        }
        
        [userNames removeObjectAtIndex:indexPathForDeletion.row];
        [passwords removeObjectAtIndex:indexPathForDeletion.row];
        
        //add logic to get custID and delete from table
        
        
    }
    [usersTableView reloadData];
    
}


-(void)FindUsers{
    
    [self  InitArraysToHoldData];
    NSManagedObjectContext *context = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"User" inManagedObjectContext:context];
    NSError *error;
    [fetchRequest setEntity:entity];
    NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSArray *item in innerStringdictionary) {
        
        NSString *usernames = [NSString stringWithFormat:@"%@",[item valueForKey:@"userName"]];
        NSString *password = [NSString stringWithFormat:@"%@",[item valueForKey:@"password"]];
      
        [userNames addObject:usernames];
        [passwords addObject:password];
       
    }
}

-(void)InitArraysToHoldData{
    passwords = [[NSMutableArray alloc] init];
    userNames = [[NSMutableArray alloc] init];

}

//function to delete all records
- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:delegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
    for (User *product in items) {
    	[delegate.managedObjectContext deleteObject:product];
    	NSLog(@"%@ object deleted",entityDescription);
    }
    if (![delegate.managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
     [usersTableView reloadData];
    
}


- (IBAction)createUser:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    UserManagmentDetailViewController *centerController = (UserManagmentDetailViewController *)[storyboard instantiateViewControllerWithIdentifier:@"userManagementDetailView"];
    
    [self presentViewController:centerController animated:YES completion:nil];
    
}
@end
