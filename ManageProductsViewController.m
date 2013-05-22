//
//  ManageProductsViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageProductsViewController.h"
#import "ManageProductsDetailViewController.h"

@interface ManageProductsViewController ()

@end

@implementation ManageProductsViewController
@synthesize productsArray;

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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [productsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    cell.textLabel.text =  [productsArray objectAtIndex:indexPath.row];
   
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    ManageProductsDetailViewController * manageProductsDetailView = (ManageProductsDetailViewController*)
    [storyboard instantiateViewControllerWithIdentifier:@"editClients"];
    
    manageProductsDetailView.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
  
    [self presentViewController:manageProductsDetailView animated:YES completion:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
