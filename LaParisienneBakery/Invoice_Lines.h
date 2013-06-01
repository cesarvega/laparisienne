//
//  Invoice_Lines.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/9/13.
//  Copyright (c) 2013 cynthia. All rights reserved.

//adding another comment

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Invoice_Lines : NSManagedObject

@property (nonatomic, retain) NSString * invoiceOrderID;
@property (nonatomic, retain) NSString * lineTotal;
@property (nonatomic, retain) NSString * parentInvoiceDocNum;
@property (nonatomic, retain) NSNumber * productID;
@property (nonatomic, retain) NSString * quantity;

@end
