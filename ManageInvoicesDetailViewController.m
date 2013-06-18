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
@synthesize ClientAddressTextLabel,BusinessNameTextLabel,ClientNameTextLabel,InvoiceLines,custID,customerPOLabel;
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
    
    NSNumber *nextLineID;
    NSNumber *nextParentInvDocNum = [self getGetNextNumericValueForFieldName:@"docNum" withEntityName:@"Invoice"];
    InvoiceID = nextParentInvDocNum;
    NSString *docTotal = @"0";
    
    //invoice lines array has productID and quantity
    for(int i = 0; i < [InvoiceLines count] ; i++)
    {
        Invoice_Lines *currentLine = (Invoice_Lines*)[InvoiceLines objectAtIndex:i];
       nextLineID = [self getGetNextNumericValueForFieldName: @"invoiceOrderID" withEntityName:@"Invoice_Lines"];

        currentLine.invoiceOrderID = [nextLineID stringValue];
        currentLine.parentInvoiceDocNum = [nextParentInvDocNum stringValue];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:delegate.managedObjectContext];
        [fetchRequest setEntity:entity];
        
       
        NSPredicate *p =[NSPredicate predicateWithFormat:@"productID = %@", currentLine.productID];
        [fetchRequest setPredicate:p];
        
        NSError *error;
        NSArray *items = [delegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        NSString*docTotal = @"0";
        
        if([items count] == 1)
        {
                    currentLine.lineTotal =[self multiplyNumber:currentLine.quantity byNumber:currentLine.unitPrice];
        
                     
            NSString *newDocTotal =[self addNumber: currentLine.lineTotal withNumber:docTotal];
           
            
            docTotal = newDocTotal;
           
        }
        else if([items count] >1){
           
        }
        else{
           
        }
        
        if (![delegate.managedObjectContext save:&error]) {
            
        }
        else{
          
            
        }
        
        
        
        
    }
    
   Invoice *invoice = [NSEntityDescription
                      insertNewObjectForEntityForName:@"Invoice"
                      inManagedObjectContext:delegate.managedObjectContext];
    invoice.docTotal = docTotal;
    
          
    invoice.docNum  = [nextParentInvDocNum stringValue];
    
    invoice.department = InvoiceDepartmentTextLabel.text;
    
    //invoice.custPONum = @"12345";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:InvoiceDateTextLabel.text];
    invoice.docDate = dateFromString;
    invoice.invoiceID = [self getGetNextNumericValueForFieldName:@"invoiceID" withEntityName:@"Invoice"];
   
    invoice.custID = custID;  
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
    NSString*result = [number stringValue];
    return result;
}

-(NSString*) multiplyNumber: (NSString*)firstNumber byNumber: (NSString*) secondNumber{
    

          
    NSDecimalNumber *number = [NSDecimalNumber one];
    NSDecimalNumber *fNum = [NSDecimalNumber decimalNumberWithString:firstNumber];
    NSDecimalNumber *sNum = [NSDecimalNumber decimalNumberWithString:secondNumber];
    
    number = [number decimalNumberByMultiplyingBy:fNum];
    number = [number decimalNumberByMultiplyingBy:sNum];
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

#pragma Mark Invoice Preview

-(void)GetClientDataForHeader{
    
    [self InitArraysToHoldData];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"custID = %@",custID]];
    
    NSArray *Customer= [self GetCustomerByCustID];
    
    for (NSArray *item in Customer) {
        NSString *BusinessName = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        //NSString *Department =@"Kitchen 1";
        NSString *BusinessAddress = [NSString stringWithFormat:@"%@\n %@ %@ %@ %@",
                                     [item valueForKey:@"addressOne"], [item valueForKey:@"addressTwo"],
                                     [item valueForKey:@"city"],[item valueForKey:@"state"],[item valueForKey:@"zipcode"]];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
         [dateFormat setDateFormat:@"MM -dd - YYYY"];
        NSString *dateString = [dateFormat stringFromDate:date];
        NSString *Date =dateString;
       // NSString *BusinessContactName = [NSString stringWithFormat:@"%@",[item valueForKey:@"businessName"]];
        NSString *telefono = [NSString stringWithFormat:@"%@",[item valueForKey:@"telefone"]];
        NSString *InvoiceNumber =@"12345678";
     
        if (InvoiceID!=nil) {
         
            NSArray *invoices= [self GetInvoicesByInvoiceID];
            
            for (NSArray *item in invoices) {
                
                NSString *InvoiceLinesID = [NSString stringWithFormat:@"%@",[item valueForKey:@"docNum"]];
                NSArray *invoices_lines= [self GetInvoiceLines:InvoiceLinesID];
               
                for(NSArray *item in invoices_lines){
                    NSString *lineTotals = [NSString stringWithFormat:@"%@",[item valueForKey:@"lineTotal"]];
                    NSString *productIDs = [NSString stringWithFormat:@"%@",[item valueForKey:@"productID"]];
                    NSString *quantitys = [NSString stringWithFormat:@"%@",[item valueForKey:@"quantity"]];
                   
                    [lineTotal addObject:lineTotals];
                    [productID addObject:productIDs];
                    [quantity addObject:quantitys];
                    
                    NSArray *products= [self Getproducts:[productID objectAtIndex:0]];
                    
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
        }else{
        
           for (Invoice_Lines *invoices_lines in InvoiceLines){
               
               NSArray *products= [self Getproducts:[invoices_lines.productID stringValue]];
                    
                    for(NSArray *item in products){
                        
                        NSString *Productnames = [NSString stringWithFormat:@"%@",[item valueForKey:@"name"]];
                        NSString *productDescriptions = [NSString stringWithFormat:@"%@",[item valueForKey:@"productDescription"]];
                        NSString *unitPrices = invoices_lines.unitPrice;
                        
                        [unitPrice addObject:unitPrices];
                        [Productname addObject:Productnames];
                        [productDescription addObject:productDescriptions];
                        [quantity addObject:invoices_lines.quantity];
                    
               }
           }
        }

        [ProductsTableView reloadData];
        [BusinessNameTextLabel setText:BusinessName];
        [InvoiceDepartmentTextLabel setText:@"Kitchen 1"];
        [ClientAddressTextLabel setText:BusinessAddress];
        [InvoiceDateTextLabel setText:Date]; 
        [ClientNameTextLabel setText:telefono];
        [InvoiceNumberTextLabel setText:InvoiceNumber];
        
    }

}

-(NSArray*)GetCustomerByCustID{
    
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"custID = %@",custID]];
    NSArray *Customers= [contextForHeader executeFetchRequest:request error:&error];
    return Customers;
}

-(NSArray*)GetInvoicesByInvoiceID{
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"invoiceID = %@",InvoiceID]];
    NSArray *invoices= [contextForHeader executeFetchRequest:request error:&error];
    return invoices;
}

-(NSArray*)GetInvoiceLines: (NSString*)InvoiceLine{
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Invoice_Lines" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"parentInvoiceDocNum= %@",InvoiceLine]];
    NSArray *Invoice_Lines= [contextForHeader executeFetchRequest:request error:&error];
    return Invoice_Lines;
}

-(NSArray*)Getproducts: (NSString*)product_ID{
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Product" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"productID = %@",product_ID]];
    NSArray *products= [contextForHeader executeFetchRequest:request error:&error];
    return products;
}

#pragma Mark PDF Methods

- (void)createPDF{
    
    [self setupPDFDocumentNamed:[InvoiceID stringValue] Width:850 Height:1100];
   
    [self beginPDFPage];
    
    [self DrawTheInvoiceLayout];
    
    [self  DrawTheInvoiceProductsContent];
    
    [self finishPDF];
}

-(void)DrawTheInvoiceProductsContent{

    int totalOfTheWholeInvoice =0;
    int textPosititonAX=180;
    int textPosititonBX=360;
    int textPosititonCX=463;
     int textPosititonDX=607;
    int textPosititonY = 456;
    int productCounter =0;
    for (Invoice_Lines *invoices_lines in InvoiceLines){
      
        
        NSArray *products= [self Getproducts:[invoices_lines.productID stringValue]];
        
           for(NSArray *item in products){
            
               NSString *Productnames = [NSString stringWithFormat:@"%@",[item valueForKey:@"name"]];
               [self addText: Productnames  withFrame:CGRectMake(textPosititonAX, textPosititonY, 150, 150) fontSize:13.0f];

            NSString *quantitys =invoices_lines.quantity;
            [self addText: quantitys  withFrame:CGRectMake(textPosititonBX, textPosititonY, 150, 150) fontSize:13.0f];
                       
                     NSString *unitPrices =invoices_lines.unitPrice;
            int totalPerProduct =[quantitys intValue]*[unitPrices intValue];
            totalOfTheWholeInvoice =totalOfTheWholeInvoice+totalPerProduct;
            [self addText: [NSString stringWithFormat:@"%@",unitPrices] withFrame:CGRectMake(textPosititonCX, textPosititonY, 150, 150) fontSize:13.0f];
               
                 [self addText: [NSString stringWithFormat:@"%d",totalPerProduct] withFrame:CGRectMake(textPosititonDX, textPosititonY, 150, 150) fontSize:13.0f];
          
                textPosititonY =textPosititonY+22;
               productCounter=productCounter+1;
            
           }
            

        }
   
    [self addText: [NSString stringWithFormat:@"%d",totalOfTheWholeInvoice] withFrame:CGRectMake(561, 800, 150, 150) fontSize:13.0f];
    
}

-(void)DrawTheInvoiceLayout{
  
    UIImage *anImage = [UIImage imageNamed:@"InvoiceTemplate.png"];
    [self addImage:anImage  atPoint:CGPointMake(100, 60)];
    
//    [self addText:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@",@"     Department :", InvoiceDepartmentTextLabel.text,@"     Name :", BusinessNameTextLabel.text,@"     Date :", InvoiceDateTextLabel.text,@"     Contact :", ClientNameTextLabel.text,@"     Address :", ClientAddressTextLabel.text]
//        withFrame:CGRectMake(110, 348, 150, 150) fontSize:15.0f];
    
    [self addText:[NSString stringWithFormat:@"%@\n%@\n%@", BusinessNameTextLabel.text, ClientAddressTextLabel.text,ClientNameTextLabel.text]
        withFrame:CGRectMake(130, 328, 150, 150) fontSize:15.0f];

    [self addText:[NSString stringWithFormat:@"%@",customerPOLabel.text]
      withFrame:CGRectMake(630, 270, 150, 150) fontSize:15.0f];
    
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
    CGFloat dashes[] = {1,5};
    CGContextSetLineDash(currentContext, 0.0, dashes, 2);
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
    CGContextStrokePath(currentContext);
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
    
    NSString *newPDFName = [NSString stringWithFormat:@"%@ %@.%@",@"Invoice #",name,@"pdf"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory    , NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@ %@.%@",@"Invoice #",[InvoiceID stringValue],@"pdf"]];
    
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

#pragma mark custom Prototype delgate methods
 
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
