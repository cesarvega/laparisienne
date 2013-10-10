//
//  EmailClientsViewController.h
//  LaParisienneBakery
//
//  Created by Cesar Vega on 9/15/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface EmailClientsViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
     AppDelegate *delegate;
    NSMutableArray *emails;
}

@property (nonatomic, retain) NSMutableArray *emails;
-(void)SendEmail :(NSArray*)toRecipients DocumentPath:(NSString*)Path DocumetName:(NSString*)Name;
@end
