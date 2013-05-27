//
//  Invoice_Lines.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/9/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//mhghjg
//adding another comment

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Invoice_Lines : NSManagedObject

@property (nonatomic, retain) NSString * invoiceOrderID;
@property (nonatomic, retain) NSDecimalNumber * lineTotal;
@property (nonatomic, retain) NSString * parentInvoiceDocNum;
@property (nonatomic, retain) NSString * productID;
@property (nonatomic, retain) NSNumber * quantity;

@end
