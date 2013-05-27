//
//  ManageInvoicesViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageInvoicesViewController.h"

@interface ManageInvoicesViewController ()

@end

@implementation ManageInvoicesViewController
@synthesize CustomersPickerDataSrc,ProductsPickerDataSrc;
@synthesize contactsNames, businessName;
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
    return [businessName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =  [Productname objectAtIndex:indexPath.row];
    cell.detailTextLabel.text =[productDescription objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ManageProductsDetailViewController * manageProductsDetailView = (ManageProductsDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"ManageProductsDetail"];
    
    manageProductsDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if ([manageProductsDetailView view]) {
        [manageProductsDetailView setName:[Productname objectAtIndex:indexPath.row]];
        [manageProductsDetailView setProductID:[productID objectAtIndex:indexPath.row]];
        [manageProductsDetailView setProductDescription:[productDescription objectAtIndex:indexPath.row]];
    }
    [self presentViewController:manageProductsDetailView animated:YES completion:nil];
    
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
    
    
    NSString *addressOnes = [NSString stringWithFormat:@"%@",[item valueForKey:@"addressOne"]];
    NSString *addressTwos = [NSString stringWithFormat:@"%@",[item valueForKey:@"addressTwo"]];
    NSString *businessDescriptions = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessDescription"]];
    NSString *businessNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
    NSString *citys = [NSString stringWithFormat:@"%@",[item valueForKey:@"city"]];
    NSString *contactNames = [NSString stringWithFormat:@"%@",[item valueForKey:@"contactName"]];
    NSString *custIDValues = [NSString stringWithFormat:@"%@",[item valueForKey:@"custID"]];
    NSString *emails = [NSString stringWithFormat:@"%@",[item valueForKey:@"email"]];
    NSString *faxs = [NSString stringWithFormat:@"%@",[item valueForKey:@"fax"]];
    NSString *mobiles = [NSString stringWithFormat:@"%@",[item valueForKey:@"mobile"]];
    NSString *states = [NSString stringWithFormat:@"%@",[item valueForKey:@"state"]];
    NSString *telefones = [NSString stringWithFormat:@"%@",[item valueForKey:@"telefone"]];
    NSString *websites = [NSString stringWithFormat:@"%@",[item valueForKey:@"website"]];
    NSString *zipcodes = [NSString stringWithFormat:@"%@",[item valueForKey:@"zipcode"]];
    
    [addressOne addObject:addressOnes];
    [addressTwo addObject:addressTwos];
    [businessDescription addObject:businessDescriptions];
    [businessName addObject: businessNames];
    [city addObject: citys];
    [contactName addObject:contactNames];
    [custIDValue addObject:custIDValues];
    [email addObject:emails];
    [fax addObject: faxs];
    [mobile addObject:mobiles];
    [state addObject:states];
    [telefone addObject:telefones];
    [website addObject:websites];
    [zipcode addObject:zipcodes];
    
}

}



@end
