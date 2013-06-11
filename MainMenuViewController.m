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
@interface MainMenuViewController ()

@end

@implementation MainMenuViewController
@synthesize menuDataSource,titleOfSections,tableController,mapTableViewDisplay;
@synthesize containerController = _containerController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self populateProductsTable];
    //Initialize the array.
    firstSection = [[NSMutableArray alloc] init];
    secondSection = [[NSMutableArray alloc] init];
    thirdSection = [[NSMutableArray alloc] init];
    titleOfSections = [[NSMutableArray alloc] init];
    
    //Add items
    [titleOfSections addObject:@"Admin"];
    [titleOfSections addObject:@"Invoices"];
    //[titleOfSections addObject:@""];
    [firstSection addObject:@"Manage Clients"];
    [firstSection addObject:@"Manage Invoices"];;
    [firstSection addObject:@"Manage Products"];
    [firstSection addObject:@"Manage Users"];
    [firstSection addObject:@"Not Signed Invoices"];
   // [firstSection addObject:@"Signed Invoices"];

    
    NSDictionary *temporaryDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:firstSection,@"0",secondSection,@"1",thirdSection,@"2",nil];
    self.menuDataSource = temporaryDictionary;
    temporaryDictionary = nil;
    
    mapTableViewDisplay.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    mapTableViewDisplay.rowHeight = 50;
    mapTableViewDisplay.backgroundColor = [UIColor clearColor];
       //Set the title
    
}

- (void)viewDidUnload{
    firstSection =  nil;
    secondSection = nil;
    thirdSection = nil;
    titleOfSections = nil;
    menuDataSource = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [titleOfSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.menuDataSource objectForKey:[NSString stringWithFormat:@"%d",section]] count];
    
    
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
    NSArray *arrayForCurrentSection = [menuDataSource objectForKey:[NSString stringWithFormat:@"%d",indexPath.section]];
    
    cell.textLabel.text = [arrayForCurrentSection objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.backgroundColor= [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:40];
    
    return cell;
    
}



#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSString * newController=@"";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

    switch (indexPath.row) {
        case 0:
            newController=@"ManageClients";
            
            break;
            
        case 1:
            newController=@"ChooseCLientsFOrInvoice";
               
            break;
        case 2:
            newController=@"ManageProducts";
              
            break;
        case 3:
            newController=@"ManageUsers";
              
            break;
            
        case 4:
            newController=@"PDFInvoices";
            
            break;
        case 5:
            newController=@"ManageSignedInvoices";
            
            break;
    }
    
    UIViewController *manageClientsViewController = (UIViewController *)[storyboard instantiateViewControllerWithIdentifier:newController];
    
    [self presentViewController:manageClientsViewController animated:YES completion:nil];
    
      
}


-(void)populateProductsTable{
   
    if (![@"NO" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"myUserDefaultsKey"]]){
    
    NSArray *productNames = [[NSArray alloc]initWithObjects:@"Ciabatta Loaf",@"Sourdough Loaf", @"Paves", @"Country loaf 1250",@"Country loaf 2500",@"Country loaf 500",@"Miche Au levain",@"Walnut / raisins loaf",@"Olive loaf",@"Multi-grain loaf",@"Rye loaf",@"Brioche Pullman 2000",@"Brioche Pullman 1400",@"Brioche Pullman 1100",@"Brioche mousseline",@"Brioche cylindrical",@"Multi-grain Pullman 2500",@"Multi-grain Pullman 2000",@"Multi-grain Pullman 1500",@"Whole wheat Pullman 2000",@"Whole wheat Pullman 1500",@"Rye Pullman 2000",@"Pumpernickel Pullman 1100",@"Pumpernickel Pullman 1400",@"Sourdough Pullman 2000",@"Sourdough Pullman 1500",@"Pain de mie Pullman 2000",@"Pain de mie Pullman 1500",@"Rustic baguette",@"Classic baguette",@"Walnut / raisin baguette",@"Whole wheat baguette",@"Multi-grains baguette",@"Pumpernickel baguette",@"Epis baguette",@"Epis baguette flax",@"Ficelle",@"Whole wheat ficelle",@"Pumpernickel ficelle",@"Walnut raisin ficelle",@"Rustic ficelle",@"Multi-grain ficelle",@"Olive ficelle",@"Fennel seeds ficelle",@"Ciabatta  sandwich",@"Ciabatta sandwich square",@"Saucisson hoagies",@"Mini saucisson hoagies",@"Plain hoagies",@"Multi-grain sandwich",@"Whole wheat sandwich",@"Walnut / raisins sandwich",@"Sandwich Provençal",@"Steak sandwich",@"Baguette sandwich",@"Saucisson sandwich sesame",@"Brioche bun 90g sesame",@"Brioche bun 90g poppy",@"Brioche bun 90g plain",@"Mini brioche sesame",@"Mini brioche bun plain",@"Mini mini brioche bun",@"Classic burger bun",@"Classic mini burger bun",@"Multi-grain bun",@"Onion bun",@"White paves roll"@"Whole wheat paves roll",@"Mini square ciabatta",@"Foccacia stick",@"Multi-grain roll",@"Multi-grain paves roll",@"Onion roll",@"Olive roll",@"Olive paves roll",@"Walnut / raisin roll",@"Walnut / raisin paves roll",@"Pumpernickel stick",@"Beaujolais",@"Cypress roll",@"Baguette roll",@"Mini baguette",@"Foccacia sheet",@"Whole wheat multi-grain",@"Onion country loaf",@"Display bread" , nil];
    
    
    for(int i = 0; i < [productNames count]; i++) {
        
            Product *product = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Product"
                                inManagedObjectContext:delegate.managedObjectContext];
        
        product.name = [productNames objectAtIndex:i];
        product.productDescription =[NSString stringWithFormat:@"%@%@",[productNames objectAtIndex:i], @" description"];
        product.unitPrice = @"1.0";
        
        NSNumber *ID = [NSNumber numberWithInt:i];
        product.productID = ID;
        NSError *error;
        
        if(![delegate.managedObjectContext save:&error]) {
            
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        
       
    }
         
        NSUserDefaults*  defaultValues = [NSUserDefaults standardUserDefaults];
        [defaultValues setObject:@"NO"  forKey:@"myUserDefaultsKey"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    }

}
 
@end
