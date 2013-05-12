//
//  MainMenuViewController.m
//  socialHangOut
//
//  Created by Cesar Vega on 10/9/12.
//  Copyright (c) 2012 Cesar Vega. All rights reserved.
//

#import "MainMenuViewController.h"

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
    
    //Initialize the array.
    firstSection = [[NSMutableArray alloc] init];
    secondSection = [[NSMutableArray alloc] init];
    thirdSection = [[NSMutableArray alloc] init];
    titleOfSections = [[NSMutableArray alloc] init];
    
    //Add items
    [titleOfSections addObject:@"Admin"];
    [titleOfSections addObject:@"Invoices"];
    //[titleOfSections addObject:@""];
    [firstSection addObject:@"ManageClients"];
    [firstSection addObject:@"ManageInvoices"];;
    [firstSection addObject:@"ManagePorducts"];
    [firstSection addObject:@"ManageUsers"];
    [secondSection addObject:@"Signed Invoices"];
//    [secondSection addObject:@"Hangout Request"];
//    [secondSection addObject:@"Message"];
    //[thirdSection addObject:@""];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [titleOfSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.menuDataSource objectForKey:[NSString stringWithFormat:@"%d",section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [titleOfSections objectAtIndex:section];
    
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
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
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

    switch (indexPath.row) {
        case 0:
            newController=@"profileView";
            break;
            
        case 1:
            newController=@"Friends";
            break;
        case 2:
            newController=@"Map";
            break;
        case 3:
            newController=@"Friend_Request";
            break;
            
        case 4:
            newController=@"Hangouts_History";
            break;
        case 5:
            newController=@"Massages";
            break;
        case 6:
            newController=@"Feature_Hangouts";
            break;
        default:
            break;
    }
    
    if ([newController isEqual: @"profileView"]) {
               
    }else if ([newController isEqual: @"Friends"]) {
    
    
    }else if ([newController isEqual:@"Map"]) {
        
       
        
    }



    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */





@end
