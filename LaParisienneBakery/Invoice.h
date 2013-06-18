//
//  Invoice.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/9/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Invoice : NSManagedObject

@property (nonatomic, retain) NSNumber * custID;
@property (nonatomic, retain) NSString * department;
@property (nonatomic, retain) NSDate * docDate;
@property (nonatomic, retain) NSString * docNum;
@property (nonatomic, retain) NSString * docTotal;
@property (nonatomic, retain) NSNumber * invoiceID;
@property (nonatomic, retain) NSString * custPONum;

@end
