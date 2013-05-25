//
//  ManageClientsViewController.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/17/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface ManageClientsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate   >
{
    AppDelegate *delegate;
}
@property (nonatomic, retain) NSMutableArray * addressOne;
@property (nonatomic, retain) NSMutableArray * addressTwo;
@property (nonatomic, retain) NSMutableArray * businessDescription;
@property (nonatomic, retain) NSMutableArray * businessName;
@property (nonatomic, retain) NSMutableArray * city;
@property (nonatomic, retain) NSMutableArray * contactName;
@property (nonatomic, retain) NSMutableArray * custIDValue;
@property (nonatomic, retain) NSMutableArray * email;
@property (nonatomic, retain) NSMutableArray * fax;
@property (nonatomic, retain) NSMutableArray * mobile;
@property (nonatomic, retain) NSMutableArray * state;
@property (nonatomic, retain) NSMutableArray * telefone;
@property (nonatomic, retain) NSMutableArray * website;
@property (nonatomic, retain) NSMutableArray * zipcode;

@end
