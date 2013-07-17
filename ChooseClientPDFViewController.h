//
//  ChooseClientPDFViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 7/16/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ChooseClientPDFViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>{
    
    NSIndexPath * IndexTracing;
    AppDelegate *delegate;
    NSManagedObjectContext *contextForInvoiceLines;
    NSMutableArray* selectedIndexes;

}
@end
@interface ClientPDFDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *ClientName;
@property (strong, nonatomic) IBOutlet UILabel *InvocieDate;
@property (strong, nonatomic) IBOutlet UILabel *InvocieNumber;
@property (strong, nonatomic) IBOutlet UIImageView *checkedPrintItemImage;
@end

