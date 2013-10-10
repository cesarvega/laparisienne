//
//  EmailClientsViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 9/15/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "EmailClientsViewController.h"

@interface EmailClientsViewController ()

@end

@implementation EmailClientsViewController
@synthesize emails;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        NSArray *email = [delegate.SignedInvoiceEmails componentsSeparatedByString:@", "];
	    [self  SendEmail:email DocumentPath:delegate.SignedInvoicefullPath DocumetName: delegate.SignedInvoiceName];}



-(void)SendEmail :(NSArray*)toRecipients DocumentPath:(NSString*)Path DocumetName:(NSString*)Name{

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        NSString *emailBody = @"Thank you for your business";
        NSData *fileData = [NSData dataWithContentsOfFile:Path];
        [mailer setSubject:@"Invoice Subject"];
        [mailer setToRecipients:toRecipients];
        [mailer addAttachmentData:fileData mimeType:@"application/pdf" fileName:Name];
        [mailer setMessageBody:emailBody isHTML:NO];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:mailer
                                                                                                 animated:YES
                                                                                               completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the email sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    

}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
