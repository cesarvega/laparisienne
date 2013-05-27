//
//  ManageInvoicesDetailViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invoice.h"
#import "Invoice_Lines.h"
@interface ManageInvoicesDetailViewController : UIViewController

{

    Invoice_Lines *invoicesLines;

}
@property (nonatomic, retain) NSNumber * custID;

- (IBAction)ChooseAClient:(id)sender;

@end
