//
//  AppDelegate.m
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/4/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "AppDelegate.h"
#import "Product.h"
#import "User.h"
@implementation AppDelegate{NSUserDefaults *userDefaults;}

@synthesize managedObjectContext = _managedObjectContext,InvoiceIDGlobal, LoginUserName,LoginUserPassword, BusinessName;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    delegate =(AppDelegate *) [[UIApplication sharedApplication] delegate];
    [self populateProductsTable];
    return YES;
    
}

-(void)populateProductsTable{
    
    if (![@"NO" isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"myUserDefaultsKey"]]){
        
      /*  NSArray *productNames = [[NSArray alloc]initWithObjects:@"Ciabatta Loaf",@"Sourdough Loaf", @"Paves", @"Country loaf 1250",@"Country loaf 2500",@"Country loaf 500",@"Miche Au levain",@"Walnut / raisins loaf",@"Olive loaf",@"Multi-grain loaf",@"Rye loaf",@"Brioche Pullman 2000",@"Brioche Pullman 1400",@"Brioche Pullman 1100",@"Brioche mousseline",@"Brioche cylindrical",@"Multi-grain Pullman 2500",@"Multi-grain Pullman 2000",@"Multi-grain Pullman 1500",@"Whole wheat Pullman 2000",@"Whole wheat Pullman 1500",@"Rye Pullman 2000",@"Pumpernickel Pullman 1100",@"Pumpernickel Pullman 1400",@"Sourdough Pullman 2000",@"Sourdough Pullman 1500",@"Pain de mie Pullman 2000",@"Pain de mie Pullman 1500",@"Rustic baguette",@"Classic baguette",@"Walnut / raisin baguette",@"Whole wheat baguette",@"Multi-grains baguette",@"Pumpernickel baguette",@"Epis baguette",@"Epis baguette flax",@"Ficelle",@"Whole wheat ficelle",@"Pumpernickel ficelle",@"Walnut raisin ficelle",@"Rustic ficelle",@"Multi-grain ficelle",@"Olive ficelle",@"Fennel seeds ficelle",@"Ciabatta  sandwich",@"Ciabatta sandwich square",@"Saucisson hoagies",@"Mini saucisson hoagies",@"Plain hoagies",@"Multi-grain sandwich",@"Whole wheat sandwich",@"Walnut / raisins sandwich",@"Sandwich Provençal",@"Steak sandwich",@"Baguette sandwich",@"Saucisson sandwich sesame",@"Brioche bun 90g sesame",@"Brioche bun 90g poppy",@"Brioche bun 90g plain",@"Mini brioche sesame",@"Mini brioche bun plain",@"Mini mini brioche bun",@"Classic burger bun",@"Classic mini burger bun",@"Multi-grain bun",@"Onion bun",@"White paves roll"@"Whole wheat paves roll",@"Mini square ciabatta",@"Foccacia stick",@"Multi-grain roll",@"Multi-grain paves roll",@"Onion roll",@"Olive roll",@"Olive paves roll",@"Walnut / raisin roll",@"Walnut / raisin paves roll",@"Pumpernickel stick",@"Beaujolais",@"Cypress roll",@"Baguette roll",@"Mini baguette",@"Foccacia sheet",@"Whole wheat multi-grain",@"Onion country loaf",@"Display bread" ,@"",@"",@"", nil];
        
        
        for(int i = 0; i < [productNames count]; i++) {
            
            Product *product = [NSEntityDescription
                                insertNewObjectForEntityForName:@"Product"
                                inManagedObjectContext:delegate.managedObjectContext];
            
            product.name = [productNames objectAtIndex:i];
            product.productDescription =[NSString stringWithFormat:@"%@%@",[productNames objectAtIndex:i], @" description"];
            product.unitPrice = @"1";
            
            NSNumber *ID = [NSNumber numberWithInt:i];
            product.productID = ID;
            NSError *error;
            
            if(![delegate.managedObjectContext save:&error]) {
                
            }
        }*/
        NSArray *Users = [[NSArray alloc]initWithObjects:@"Admin",@"Driver", nil];
        NSArray *Userspasword = [[NSArray alloc]initWithObjects:@"embarek",@"12345", nil];
        for(int i = 0; i < [Users count]; i++) {
            
            User *user = [NSEntityDescription
                          insertNewObjectForEntityForName:@"User"
                          inManagedObjectContext:delegate.managedObjectContext];
            
            user.userName = [Users objectAtIndex:i];
            user.password =[NSString stringWithFormat:@"%@",[Userspasword objectAtIndex:i]];
            NSNumber *ID = [NSNumber numberWithInt:i];
            user.userID = ID;
            NSError *error;
            
            if(![delegate.managedObjectContext save:&error]) {
                
            }
            
            NSUserDefaults*  defaultValues = [NSUserDefaults standardUserDefaults];
            [defaultValues setObject:@"NO"  forKey:@"myUserDefaultsKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application{
     userDefaults = [NSUserDefaults standardUserDefaults];}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];

}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults synchronize];
    [self saveContext];
}

- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"LaParisienneBakery" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"LaParisienneBakery.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
