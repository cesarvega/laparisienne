//
//  NICSignatureView.h
//  SignatureViewTest
//
//  Created by Jason Harwig on 11/5/12.
//  Copyright (c) 2012 Near Infinity Corporation.

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "AppDelegate.h"
#import "ReaderViewController.h"
#import "Product.h"
#import "Invoice.h"
#import "Invoice_Lines.h"
@interface NICSignatureView : GLKView{
    
    NSNumber* InvoiceID;
    Invoice_Lines * Invoice_Lines;
    NSMutableArray * InvoiceLines;
}

@property (assign, nonatomic) BOOL hasSignature;
@property (strong, nonatomic) UIImage *signatureImage;
@property (strong, nonatomic)    NSNumber* InvoiceID;

- (void)erase;
- (IBAction)StoreSignedInvoice:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *RecieversName;
- (IBAction)EraseSignature:(id)sender;
@end
