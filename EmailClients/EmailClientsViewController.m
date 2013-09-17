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
	// Do any additional setup after loading the view.
}



-(void)SendEmail :(NSArray*)toRecipients DocumentPath:(NSString*)Path DocumetName:(NSString*)Name{

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Invoice Subject"];
        NSString *emailBody = @"Thank you for your business";
        NSData *fileData = [NSData dataWithContentsOfFile:Path];
       // NSArray *toRecipients = [NSArray arrayWithObjects:@"piratacd2005@hotmail.com", @"cesarvega.col@gmail.com", nil];
        // [mailer setToRecipients:toRecipients];
        //UIImage *myImage = [UIImage imageNamed:@"LogoDark.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"images/png" fileName:@"LogoDark"];
        //NSMutableData *pdfData = [NSMutableData data];
        [mailer addAttachmentData:fileData mimeType:@"application/pdf" fileName:Name];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
        
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
