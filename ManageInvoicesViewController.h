//
//  ManageInvoicesViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageInvoicesViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>{
    UIButton *printButton;
    UIPrintInteractionController *printController;
}
@property (strong, nonatomic)NSArray* CustomersPickerDataSrc ;
@property (strong, nonatomic)NSArray* ProductsPickerDataSrc ;
@end
