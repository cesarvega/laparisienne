//
//  MainMenuViewController.h
//  
//
//  Created by Cesar Vega on 10/9/12.
//  Copyright (c) 2012 Cesar Vega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface MainMenuViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *firstSection;
    NSMutableArray *secondSection;
    NSMutableArray *thirdSection;
    NSMutableArray *titleOfSections;
    NSDictionary * menuDataSource;
    AppDelegate *delegate;
}
@property (strong, nonatomic) IBOutlet UITableView *mapTableViewDisplay;
@property (strong,nonatomic) NSDictionary * menuDataSource;
@property (strong,nonatomic) NSArray * titleOfSections;
@property (strong, nonatomic) UIViewController *containerController;
@property (strong, nonatomic) UITableViewController* tableController;

@end
