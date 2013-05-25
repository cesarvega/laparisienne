//
//  Customer.h
//  LaParisienneBakery
//
//  Created by cynthia besada on 5/9/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * addressOne;
@property (nonatomic, retain) NSString * addressTwo;
@property (nonatomic, retain) NSString * businessDescription;
@property (nonatomic, retain) NSString * businessName;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSNumber * custID;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSString * mobile;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * telefone;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * zipcode;

@end
