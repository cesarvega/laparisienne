//
//  Product.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/9/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Product : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSNumber * productID;
@property (nonatomic, retain) NSDecimalNumber * unitPrice;

@end
