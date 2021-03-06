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
    NSIndexPath * IndexTracing;
    AppDelegate *delegate;
    NSManagedObjectContext *contextForInvoiceLines;
      NSMutableArray* selectedIndexes;
}
@property (nonatomic, retain) NSMutableArray * TextColor;
@property (nonatomic, retain) NSMutableArray * ImageName;
@property (nonatomic, retain) NSMutableArray * Productname;
@property (nonatomic, retain) NSMutableArray * productDescription;
@property (nonatomic, retain) NSMutableArray * productID;
@property (nonatomic, retain) NSNumber * InvoiceID;
@property (nonatomic, retain) NSMutableArray * unitPrice;
@property (nonatomic, retain) NSMutableArray * quantity;
@property (nonatomic, retain) NSMutableArray *SelectedProductsIndexPaths;
@property (strong, nonatomic) IBOutlet UITableView *ProductsTableView;
@property (nonatomic, retain) NSNumber * ClientID;
- (IBAction)StoreInvocie:(id)sender;



@end
@interface ProductsDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ProductID;
@property (strong, nonatomic) IBOutlet UILabel *ProductNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ProductDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *ProductPriceLabel;
@property (strong, nonatomic) IBOutlet UITextField *ProductQuantity;
@property (strong, nonatomic) IBOutlet UIImageView *addImage;

@end
