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
#import "AppDelegate.h"
@interface NICSignatureView : GLKView<MFMailComposeViewControllerDelegate,UIViewControllerTransitioningDelegate>{
    AppDelegate *delegate;
    NSNumber* InvoiceID;
    Invoice_Lines * Invoice_Lines;
    NSMutableArray * InvoiceLines;
    NSManagedObjectContext *contextForHeader;
    NSIndexPath *indexPathForDeletion;
    NSString* totalOfTheWholeInvoice;
    NSString* InvoiceDate;
    NSString* InvoicePO;
    NSString *fullPath;
    NSString* documentName;
    

}

@property (strong, nonatomic) IBOutlet UITextField *recieversName;
@property (assign, nonatomic) BOOL hasSignature;
@property (strong, nonatomic) UIImage *signatureImage;
@property (strong, nonatomic) NSNumber* InvoiceID;

- (void)erase;
- (IBAction)StoreSignedInvoice:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *RecieversName;
- (IBAction)EraseSignature:(id)sender;
@end

@interface Control : UIViewController{UIViewController * DismissView;}

@property(strong, nonatomic)UIViewController * DismissView;

@end
