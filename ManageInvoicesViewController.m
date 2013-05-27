//
//  ManageInvoicesViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageInvoicesViewController.h"
#import "ManageInvoicesDetailViewController.h"
@interface ManageInvoicesViewController ()

@end

@implementation ManageInvoicesViewController
@synthesize CustomersPickerDataSrc,ProductsPickerDataSrc;
@synthesize contactNames, businessNames, custIDValues;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self initArrays];
    [self getClients];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [businessNames count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =  [businessNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text =[contactNames objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ManageInvoicesDetailViewController * manageInvoicesDetailView = (ManageInvoicesDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"ManageInvoices"];
    
    manageInvoicesDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if ([manageInvoicesDetailView view]) {
        [manageInvoicesDetailView setCustID:[custIDValues objectAtIndex:indexPath.row]];
    
    }
    [self presentViewController:manageInvoicesDetailView animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)getClients{


NSManagedObjectContext *context = [delegate managedObjectContext];
NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
NSEntityDescription *entity = [NSEntityDescription
                               entityForName:@"Customer" inManagedObjectContext:context];
NSError *error;
        [fetchRequest setEntity:entity];
NSArray * innerStringdictionary = [context executeFetchRequest:fetchRequest error:&error];


for (NSArray *item in innerStringdictionary) {
    
    NSString *businessName = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
    NSString *contactName = [NSString stringWithFormat:@"%@",[item valueForKey:@"contactName"]];
    NSString *custIDValue = [NSString stringWithFormat:@"%@",[item valueForKey:@"custID"]];
    [businessNames addObject: businessName];
    [contactNames addObject:contactName];
    [custIDValues addObject:custIDValue];

    
}
    


}
-(void)initArrays{
    businessNames = [[NSMutableArray alloc]init];
    contactNames = [[NSMutableArray alloc]init];
    custIDValues = [[NSMutableArray alloc]init];
}



@end
