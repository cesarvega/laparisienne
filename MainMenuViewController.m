//
//  MainMenuViewController.m
//  socialHangOut
//
//  Created by Cesar Vega on 10/9/12.
//  Copyright (c) 2012 Cesar Vega. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ManageClientsViewController.h"
#import "Customer.h"
#import "Product.h"
#import "User.h"
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize menuDataSource,titleOfSections,tableController,mapTableViewDisplay;
@synthesize containerController = _containerController;


- (id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
  
    //Initialize the array.
    firstSection = [[NSMutableArray alloc] init];
    secondSection = [[NSMutableArray alloc] init];
    titleOfSections = [[NSMutableArray alloc] init];
    
    //Add items
    if ([delegate.LoginUserName isEqual: @"Admin"] && [delegate.LoginUserPassword isEqual: @"embarek"] ) {
        
        [titleOfSections addObject:@"Admin"];
        [firstSection addObject:@"Print Pdf Invoices"];
        [firstSection addObject:@"Sign Pdf  Invoices"];
        [firstSection addObject:@"View Signed Invoices"];
        [firstSection addObject:@"Manage Invoices"];
        [firstSection addObject:@"Manage Clients"];
        [firstSection addObject:@"Manage Products"];
        [firstSection addObject:@"Manage Users"];
        [firstSection addObject:@"Delete All Invoices Data and pdfs"];
        [firstSection addObject:@"Delete Signed pdfs"];
        
      
    }else{
    
        [titleOfSections addObject:@"Invoices"];
        [firstSection addObject:@"Print Pdf Invoices"];
        [firstSection addObject:@"Sign Pdf  Invoices"];
        [firstSection addObject:@"View Signed Invoices"];
        
        /* for testing */
//        [titleOfSections addObject:@"Invoices"];
//        [firstSection addObject:@"Print Pdf Invoices"];
//        [firstSection addObject:@"Sign Pdf  Invoices"];
//        [firstSection addObject:@"View Signed Invoices"];
//        [firstSection addObject:@"Manage Invoices"];
//        [firstSection addObject:@"Manage Clients"];
//        [firstSection addObject:@"Manage Products"];
//        [firstSection addObject:@"Manage Users"];
//        [firstSection addObject:@"Delete All Invoices Data and pdfs"];
//        [firstSection addObject:@"Delete Signed pdfs"];

        }
    
   
    
    NSDictionary *temporaryDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:firstSection,@"0",secondSection,@"1",thirdSection,@"2",nil];
    self.menuDataSource = temporaryDictionary;
    temporaryDictionary = nil;
    
    mapTableViewDisplay.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mapTableViewDisplay.rowHeight = 50;
    mapTableViewDisplay.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload{
    firstSection =  nil;
    secondSection = nil;
    thirdSection = nil;
    titleOfSections = nil;
    menuDataSource = nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [titleOfSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.menuDataSource objectForKey:[NSString stringWithFormat:@"%ld",(long)section]] count];
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [titleOfSections objectAtIndex:section];
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    
    [headerView setBackgroundColor:[UIColor grayColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 3, tableView.bounds.size.width - 10, 18)];
    label.text = [titleOfSections objectAtIndex:section];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
   
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSArray *arrayForCurrentSection = [menuDataSource objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
    
    cell.textLabel.text = [arrayForCurrentSection objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor brownColor];
    cell.textLabel.backgroundColor= [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:30];
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * newController=@"";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    switch (indexPath.row) {
        case 0:
            newController=@"ChooseClientPDF";
            
            break;
        case 1:
            newController=@"PDFInvoices";
            
            break;
            
        case 2:
            newController=@"ViewSignedInvoices";
               
            break;
        case 3:
            newController=@"ChooseCLientsFOrInvoice";
            
            break;

        case 4:
            newController=@"ManageClients";
              
            break;
        case 5:
            newController=@"ManageProducts";
              
            break;
            
        case 6:
            newController=@"manageUsers";
            
            break;
            
        case 7:
            newController=@"DeleteAllData";
            
            break;
            
        case 8:
            newController=@"DeleteSignedPdf";
            
            break;

       
    }
    
    UIViewController *manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:newController];
    
    [self presentViewController:manageClientsViewController animated:YES completion:nil];
    
      
}


@end
