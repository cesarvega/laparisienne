//
//  ChooseClientPDFViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 7/16/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ChooseClientPDFViewController.h"
@implementation ClientPDFDetailCell
@synthesize ClientName;
@end

@interface ChooseClientPDFViewController ()

@end

@implementation ChooseClientPDFViewController
ClientPDFDetailCell * cell;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ClientPDFDetailCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[ClientPDFDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.ClientName.text=@"";
    cell.InvocieDate.text =@"";
    cell.InvocieNumber.text =@"";
    [cell.checkedPrintItemImage setImage:[UIImage imageNamed:@""]];
    if ([@"" isEqual:@"add.png"]) {
               
    }else{
     
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [SelectedProductsIndexPaths addObject:indexPath];
    IndexTracing=indexPath;
    cell = (ClientPDFDetailCell *) [ProductsTableView cellForRowAtIndexPath:indexPath];
    [unitPrice replaceObjectAtIndex:IndexTracing.row withObject:cell.ProductPriceLabel.text];
    [quantity replaceObjectAtIndex:IndexTracing.row withObject:cell.ProductQuantity.text];
    [productID replaceObjectAtIndex:IndexTracing.row withObject:cell.ProductID.text];
    UIColor * whiteColor = [UIColor greenColor];
    [cell.ProductQuantity setTextColor: whiteColor];
    [cell.ProductPriceLabel setTextColor:whiteColor];
    [TextColor replaceObjectAtIndex:IndexTracing.row withObject:whiteColor];
    [@"" replaceObjectAtIndex:IndexTracing.row withObject:@"added.png"];
    [cell.ProductQuantity setEnabled:NO];
    [cell.ProductPriceLabel setEnabled:NO];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    cell = (ProductsDetailCell *) [ProductsTableView cellForRowAtIndexPath:indexPath];
    [SelectedProductsIndexPaths removeObject:indexPath];
    UIColor * cyanColor = [UIColor cyanColor];
    [cell.ProductQuantity setTextColor: cyanColor];
    [cell.ProductPriceLabel setTextColor:cyanColor];
    [cell.ProductQuantity setEnabled:YES];
    [cell.ProductPriceLabel setEnabled:YES];
    [cell.ProductPriceLabel setTextColor:cyanColor];
    [TextColor replaceObjectAtIndex:IndexTracing.row withObject:cyanColor];
    [ImageName replaceObjectAtIndex:IndexTracing.row withObject:@"add.png"];
    
}

@end
