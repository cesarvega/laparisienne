//
//  AppDelegate.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/4/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//kkhg

#import <UIKit/UIKit.h>
//comments
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
