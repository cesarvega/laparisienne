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



-(void)SendEmail :(NSArray*)toRecipients{

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Invoice Subject"];
//        NSArray *toRecipients = [NSArray arrayWithObjects:@"piratacd2005@hotmail.com", @"cesarvega.col@gmail.com", nil];
//        [mailer setToRecipients:toRecipients];
        UIImage *myImage = [UIImage imageNamed:@"SocialLogo.png"];
        NSData *imageData = UIImagePNGRepresentation(myImage);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"emailLogo"];
        NSString *emailBody = @"Please tell us the bug you found";
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        
    }
    

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
