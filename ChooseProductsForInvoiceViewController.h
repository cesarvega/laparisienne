//
//  ChooseProductsForInvoiceViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/27/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ChooseProductsForInvoiceViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    AppDelegate *delegate;
}
@property (nonatomic, retain) NSMutableArray * Productname;
@property (nonatomic, retain) NSMutableArray * productDescription;
@property (nonatomic, retain) NSMutableArray * productID;
@property (nonatomic, retain) NSMutableArray * unitPrice;
@property (nonatomic, retain) NSMutableArray *SelectedProductsIdArray;
- (IBAction)StoreInvocie:(id)sender;



@end
@interface ProductsDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ProductNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductQuantity;

@end
