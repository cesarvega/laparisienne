//
//  ManageInvoicesDetailViewController.m
//  LaParisienneBakery
//
//  Created by Cesar Vega on 5/20/13.
//  Copyright (c) 2013 cynthia. All rights reserved.
//

#import "ManageInvoicesDetailViewController.h"
#import "Product.h"
#import "Invoice.h"
#import "Invoice_Lines.h"
#define kPadding 20
@implementation ProductsReviewDetailCell
@synthesize ProductPriceLabel,ProductDescriptionLabel,ProductNameLabel,ProductQuantity;
@end
@interface ManageInvoicesDetailViewController ()
{CGSize _pageSize;}
@end

@implementation ManageInvoicesDetailViewController
 ProductsReviewDetailCell *cell;
@synthesize InvoiceDateTextLabel,InvoiceDepartmentTextLabel,InvoiceNumberTextLabel,InvoiceID;
@synthesize ClientAddressTextLabel,BusinessNameTextLabel,ClientNameTextLabel,InvoiceLines,custID;
@synthesize Productname, productID, productDescription,unitPrice,SelectedProductsIndexPaths,ProductsTableView,ClientID,quantity,lineTotal;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    contextForHeader = [delegate managedObjectContext];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SaveInvoice:(id)sender {
    //CYNTHIA STUFF your code goes here to store the invoice
    // the array with the invoice_line objects is "InvoiceLines" and the customer is is custID
    
    //name of invoice lines array is InvoiceLines
    //name of customer id variable is custID
    NSNumber *nextLineID;
    NSNumber *nextParentInvDocNum = [self getGetNextNumericValueForFieldName:@"docNum" withEntityName:@"Invoice"];
 
    NSString *docTotal = @"0";
    
    //invoice lines array has productID and quantity
    for(int i = 0; i < [InvoiceLines count] ; i++)
    {
        Invoice_Lines *currentLine = (Invoice_Lines*)[InvoiceLines objectAtIndex:i];
       nextLineID = [self getGetNextNumericValueForFieldName: @"invoiceOrderID" withEntityName:@"Invoice_Lines"];
        
        currentLine.invoiceOrderID = [nextLineID stringValue];
        currentLine.parentInvoiceDocNum = [nextParentInvDocNum stringValue];
          NSLog(@"parent inv docnum: %@", currentLine.parentInvoiceDocNum);
        
        //use product ID to get product info
        //fetch product using ID
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSLog(@"Curent lines product ID: %@",currentLine.productID);
        NSPredicate *p =[NSPredicate predicateWithFormat:@"productID = %@", currentLine.productID];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSString*docTotal = @"0";
        
        if([items count] == 1)
        {
            NSArray *result = [items objectAtIndex:0];
            NSString*unitPrice =  [result valueForKey:@"unitPrice"];
            NSLog(@"unit price: %@", unitPrice);
            currentLine.lineTotal =@"100";// [self multiplyNumber:currentLine.quantity byNumber:unitPrice];
            
            NSLog(@"quantity: %@", currentLine.quantity);
             NSLog(@"Linetotal: %@", currentLine.lineTotal);
           
            NSString *newDocTotal =[self addNumber: currentLine.lineTotal withNumber:docTotal];
           
            
            docTotal = newDocTotal;
            
           
            
        }
        else if([items count] >1){
            NSLog(@"Error: There are more than 1 product in the database with the same ID.");
        }
        else{
            NSLog(@"Error: Fetch returned no results.");
        }
        
        if (![delegate.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        else{
            NSLog(@"Invoice line saved. LineID %@", currentLine.invoiceOrderID);
            
        }
        
        
        
        
    }
    
   Invoice *invoice = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Invoice"
                      inManagedObjectContext:delegate.managedObjectContext];
    invoice.docTotal = docTotal;
    NSLog(@"Doctotal: %@", docTotal);
          
    invoice.docNum  = [nextParentInvDocNum stringValue];
    
    NSLog(@"DocNum: %@", invoice.docNum);
    invoice.department = InvoiceDepartmentTextLabel.text;
    NSLog(@"Department: %@", invoice.department);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:InvoiceDateTextLabel.text];
    invoice.docDate = dateFromString;
    invoice.invoiceID = [self getGetNextNumericValueForFieldName:@"invoiceID" withEntityName:@"Invoice"];
    
      NSLog(@"InvoiceID: %@", invoice.invoiceID);
    invoice.custID = custID;
    
      NSLog(@"custID: %@", invoice.custID);
    NSError *error;
    
    
    if (![delegate.managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"  message:@"Invoice successfully saved."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
    
    
    
    [self createPDF];
    
}

- (NSString*)addNumber: (NSString*)firstNumber withNumber: (NSString*) secondNumber {
    NSDecimalNumber *number = [NSDecimalNumber zero];
    
    
    NSDecimalNumber *fNum = [NSDecimalNumber decimalNumberWithString:firstNumber];
    NSDecimalNumber *sNum = [NSDecimalNumber decimalNumberWithString:secondNumber];
    
    number = [number decimalNumberByAdding:fNum];
    number = [number decimalNumberByAdding:sNum];
    NSLog(@"firstnum: %@", fNum);
    NSLog(@"secondNum: %@",sNum);
    NSLog(@"number: %@", number);
    
    NSString*result = [number stringValue];
    return result;
}

-(NSString*) multiplyNumber: (NSString*)firstNumber byNumber: (NSString*) secondNumber{
    

          
    NSDecimalNumber *number = [NSDecimalNumber one];
    NSDecimalNumber *fNum = [NSDecimalNumber decimalNumberWithString:firstNumber];
    NSDecimalNumber *sNum = [NSDecimalNumber decimalNumberWithString:secondNumber];
    
    number = [number decimalNumberByMultiplyingBy:fNum];
    number = [number decimalNumberByMultiplyingBy:sNum];
    
    NSLog(@"firstnum: %@", fNum);
    NSLog(@"secondNum: %@",sNum);
    NSLog(@"number: %@", number);
   NSString *result= [number stringValue  ];
    
    return result;
}

-(NSNumber*)getGetNextNumericValueForFieldName: (NSString*) fieldName withEntityName: (NSString*) entityName{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:delegate.managedObjectContext];
    
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    
    [request setResultType:NSDictionaryResultType];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:fieldName];
    
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:"
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    [expressionDescription setName:@"maxID"];
    
    [expressionDescription setExpression:maxExpression];
    
    [expressionDescription setExpressionResultType:NSDecimalAttributeType];
    
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    NSError *error;
    NSArray *objects = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    NSString *ID = @"";
    if (objects == nil || [objects count] == 0) {
        if([fieldName isEqualToString:@"docNum"])
        {
            return 00000000;
        }
        else if([fieldName isEqualToString:@"invoiceOrderID"])
        {
            return 0;
        }
    }
    else {
        
        if ([objects count] > 0) {
            ID = [[objects objectAtIndex:0] valueForKey:@"maxID"];
        }
    }
    
    int maxID = [ID integerValue];
    maxID = maxID+1;
    NSString *finalString = [NSString stringWithFormat:@"%i", maxID];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    //ID is a string
    return [f numberFromString:finalString];
       
}

- (IBAction)ReEditProductsSelected:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self GetClientDataForHeader];
}

-(void)GetClientDataForHeader{
    [self InitArraysToHoldData];
    NSError *error = nil;
    //This is your NSManagedObject subclass
    //Set up to get the thing you want to update
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"custID = %@",custID]];
    
    //Ask for it
    NSArray *invoices= [contextForHeader executeFetchRequest:request error:&error];
    for (NSArray *item in invoices) {
        NSString *BusinessName = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        //NSString *Department =@"Kitchen 1";
        NSString *BusinessAddress = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                                     [item valueForKey:@"addressOne"], [item valueForKey:@"addressTwo"],
                                     [item valueForKey:@"city"],[item valueForKey:@"state"],[item valueForKey:@"zipcode"]];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
         [dateFormat setDateFormat:@"MM -dd - YYYY"];
        NSString *dateString = [dateFormat stringFromDate:date];
        NSString *Date =dateString;
        NSString *BusinessContactName = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        NSString *InvoiceNumber =@"12345678";
        if (InvoiceID!=nil) {
            request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:contextForHeader]];
            [request setPredicate:[NSPredicate predicateWithFormat:@"invoiceID = %@",InvoiceID]];
            
   
            NSArray *invoices= [contextForHeader executeFetchRequest:request error:&error];
            
            for (NSArray *item in invoices) {
                NSString *InvoiceLinesID = [NSString stringWithFormat:@"%@",[item valueForKey:@"docNum"]];
                request = [[NSFetchRequest alloc] init];
                [request setEntity:[NSEntityDescription entityForName:@"Invoice_Lines" inManagedObjectContext:contextForHeader]];
                [request setPredicate:[NSPredicate predicateWithFormat:@"invoiceOrderID = %@",InvoiceLinesID]];
                NSArray *invoices_lines= [contextForHeader executeFetchRequest:request error:&error];
          
                for(NSArray *item in invoices_lines){
                  
                 
                    NSString *lineTotals = [NSString stringWithFormat:@"%@",[item valueForKey:@"lineTotal"]];
                    NSString *productIDs = [NSString stringWithFormat:@"%@",[item valueForKey:@"productID"]];
                  
                    NSString *quantitys = [NSString stringWithFormat:@"%@",[item valueForKey:@"quantity"]];
                   
                    [lineTotal addObject:lineTotals];
                    [productID addObject:productIDs];                  
                    [quantity addObject:quantitys];
                    
                    request = [[NSFetchRequest alloc] init];
                    [request setEntity:[NSEntityDescription entityForName:@"Product" inManagedObjectContext:contextForHeader]];
                    [request setPredicate:[NSPredicate predicateWithFormat:@"productID = %@",[productID objectAtIndex:0]]];
                    NSArray *products= [contextForHeader executeFetchRequest:request error:&error];
                    
                    for(NSArray *item in products){
                      
                        NSString *Productnames = [NSString stringWithFormat:@"%@",[item valueForKey:@"name"]];
                        NSString *productDescriptions = [NSString stringWithFormat:@"%@",[item valueForKey:@"productDescription"]];
                        NSString *unitPrices = [NSString stringWithFormat:@"%@",[item valueForKey:@"unitPrice"]];
                        
                        [unitPrice addObject:unitPrices];
                        [Productname addObject:Productnames];
                        [productDescription addObject:productDescriptions];

                    }
                }
            }
        }

         [ProductsTableView reloadData];
        [BusinessNameTextLabel setText:BusinessName];
        //[InvoiceDepartmentTextLabel setText:Department];
        
        [ClientAddressTextLabel setText:BusinessAddress];
        [InvoiceDateTextLabel setText:Date]; 
        [ClientNameTextLabel setText:BusinessContactName];
        [InvoiceNumberTextLabel setText:InvoiceNumber];
        
               
        
        //This is your NSManagedObject subclass
        //Set up to get the thing you want to update
        
                
    }

}

- (void)createPDF{
    
    [self setupPDFDocumentNamed:@"NewPDF" Width:850 Height:1100];
    
    [self beginPDFPage];
    
    [self addText:@"1909 NE154th Street\nNortl1Miami Beach,Florida 33162\nTel:305.948.9979 . Fax: 305.948.9970\nwww.laparisiennebakery.com"
                          withFrame:CGRectMake(400, 120, 450, 250) fontSize:18.0f];
    
    [self addText:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@",@"Invoice Number :", @"#####     ",@"Department :", @"#####\n",@"Name :", @"#####     ",@"Date :", @"#####\n",@"Address :", @"#####     ",@"Contact :", @"#####"]
        withFrame:CGRectMake(20, 248, 150, 150) fontSize:18.0f];
    
    UIImage *anImage = [UIImage imageNamed:@"LogoInv.png"];
    CGRect imageRect = [self addImage:anImage
                              atPoint:CGPointMake(20, 60)];
    
        [self addLineWithFrame:CGRectMake(kPadding, imageRect.origin.y + imageRect.size.height + kPadding, _pageSize.width - kPadding*2, 4)
                 withColor:[UIColor blackColor] Orientation:@""];
    
    //drawing table grid
    int Rows = 340;
    for (int i = 1; i <= 12; i++)
    {
            [self addLineWithFrame:CGRectMake(kPadding, Rows, _pageSize.width - kPadding*2, 4)
                     withColor:[UIColor darkGrayColor] Orientation:@""];
            Rows = Rows+60;
    
    }
    int Colums = 20;
    for (int i = 1; i <= 2; i++)
    {
        [self addLineWithFrame:CGRectMake(Colums,340 , 660, 4)
                     withColor:[UIColor darkGrayColor] Orientation:@"Vertical"];
        Colums = Colums+810;
      
    }
    
    Colums = 120;
    for (int i = 1; i <= 2; i++)
    {
        [self addLineWithFrame:CGRectMake(Colums,340 , 660, 4)
                     withColor:[UIColor darkGrayColor] Orientation:@"Vertical"];
        Colums = Colums+610;
        
    }
    
    Colums = 435;
    for (int i = 1; i <= 2; i++)
    {
        [self addLineWithFrame:CGRectMake(Colums,340 , 660, 4)
                     withColor:[UIColor darkGrayColor] Orientation:@"Vertical"];
        Colums = Colums-100;
        
    }
    
    Colums = 435;
    for (int i = 1; i <= 2; i++)
    {
        [self addLineWithFrame:CGRectMake(Colums,340 , 660, 4)
                     withColor:[UIColor darkGrayColor] Orientation:@"Vertical"];
        Colums = Colums+100;
        
    }
    
    int textPosititon = 360;
    for (int i = 1; i <= 1; i++){
    [self addText:[NSString stringWithFormat:@"%@%@%@%@%@%@",@"Quantity                  ", @"Product                      ",@"Total          ", @"Quantity                ", @"Product                   ",@"Total        "]
        withFrame:CGRectMake(30, textPosititon, 150, 150) fontSize:18.0f];
        textPosititon =textPosititon+60;
    }
    [self finishPDF];
    
}

- (CGRect)addText:(NSString*)text withFrame:(CGRect)frame fontSize:(float)fontSize  {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    
	CGSize stringSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(_pageSize.width - 2*20-2*20, _pageSize.height - 2*20 - 2*20) lineBreakMode:NSLineBreakByWordWrapping];
    
	float textWidth = frame.size.width;
    
    if (textWidth < stringSize.width)
        textWidth = stringSize.width;
    if (textWidth > _pageSize.width)
        textWidth = _pageSize.width - frame.origin.x;
    
    CGRect renderingRect = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    [text drawInRect:renderingRect
            withFont:font
       lineBreakMode:NSLineBreakByWordWrapping
           alignment:NSTextAlignmentLeft];
    
    frame = CGRectMake(frame.origin.x, frame.origin.y, textWidth, stringSize.height);
    
    return frame;
}

- (CGRect)addLineWithFrame:(CGRect)frame withColor:(UIColor*)color Orientation:(NSString*)orientation{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(currentContext, color.CGColor);
    
    // this is the thickness of the line
    CGContextSetLineWidth(currentContext, frame.size.height/3);
    
    CGPoint startPoint = frame.origin;
    CGPoint endPoint;
    if ([orientation isEqualToString: @"Vertical"]) {
        endPoint = CGPointMake(frame.origin.x,frame.origin.y + frame.size.width);
    }else{endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y);}
    
    
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
    
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
    
    return frame;
}

- (CGRect)addImage:(UIImage*)image atPoint:(CGPoint)point {
    CGRect imageFrame = CGRectMake(point.x, point.y, image.size.width/4, image.size.height/4);
    [image drawInRect:imageFrame];
    
    return imageFrame;
}

- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
    _pageSize = CGSizeMake(width, height);
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@.pdf", name];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:newPDFName];
    
    UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil);
}

- (void)beginPDFPage {
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, _pageSize.width, _pageSize.height), nil);
}

- (void)finishPDF {
    UIGraphicsEndPDFContext();
    [self didClickOpenPDF];
}

//NOTE to look the pdf created go to finder and choose go to folder the type /Library/Application Support/iPhone Simulator/
- (void)didClickOpenPDF {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:@"NewPDF.pdf"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pdfPath]) {
        
        ReaderDocument *document = [ReaderDocument withDocumentFilePath:pdfPath password:nil];
        
        if (document != nil)
        {
            ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
            readerViewController.delegate = self;
            
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:readerViewController animated:YES completion:nil];
        }
    }
}

-(void)OpenInvoice{



}

#pragma mark custom tableview delgate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Productname count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ProducReviewDetailsCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ProductsReviewDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.ProductNameLabel.text =  [Productname objectAtIndex:indexPath.row];
    cell.ProductDescriptionLabel.text =[productDescription objectAtIndex:indexPath.row];
    cell.ProductPriceLabel.text =[unitPrice objectAtIndex:indexPath.row];
    cell.ProductQuantity.text=[quantity objectAtIndex:indexPath.row];
    return cell;

}

-(void)InitArraysToHoldData{
    Productname = [[NSMutableArray alloc] init];
    productDescription = [[NSMutableArray alloc] init];
    productID = [[NSMutableArray alloc] init];
    unitPrice = [[NSMutableArray alloc] init];
    quantity= [[NSMutableArray alloc] init];
    lineTotal =[[NSMutableArray alloc] init];
}

@end
