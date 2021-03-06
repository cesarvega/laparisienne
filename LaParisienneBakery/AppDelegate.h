//
//  AppDelegate.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/4/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//kkhg

#import <UIKit/UIKit.h>
//comments
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
     AppDelegate *delegate;
}

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString* InvoiceIDGlobal;
@property(strong,nonatomic)NSString* LoginUserName;
@property(strong,nonatomic)NSString* LoginUserPassword;
@property(strong,nonatomic)NSString* SignedInvoiceName;
@property(strong,nonatomic)NSString* SignedInvoicefullPath;
@property(strong,nonatomic)NSString* SignedInvoiceFlag;
@property(strong,nonatomic)NSString* SignedInvoiceNumber;
@property(strong,nonatomic)NSString* SignedInvoiceEmails;
@property(strong,nonatomic)NSString* BusinessName;
@property(strong,nonatomic)NSString* custID;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
