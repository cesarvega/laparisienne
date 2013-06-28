//
//  NICSignatureView.m
//  SignatureViewTest
//
//  Created by Jason Harwig on 11/5/12.
//  Copyright (c) 2012 Near Infinity Corporation.
//

#import "NICSignatureView.h"

#define kPadding 20
#define             STROKE_WIDTH_MIN 0.002 // Stroke width determined by touch velocity
#define             STROKE_WIDTH_MAX 0.010
#define       STROKE_WIDTH_SMOOTHING 0.5   // Low pass filter alpha

#define           VELOCITY_CLAMP_MIN 20
#define           VELOCITY_CLAMP_MAX 5000

#define QUADRATIC_DISTANCE_TOLERANCE 3.0   // Minimum distance to make a curve

#define             MAXIMUM_VERTECES 100000


static GLKVector3 StrokeColor = { 0, 0, 0 };

// Vertex structure containing 3D point and color
struct NICSignaturePoint
{
	GLKVector3		vertex;
	GLKVector3		color;
};
typedef struct NICSignaturePoint NICSignaturePoint;


// Maximum verteces in signature
static const int maxLength = MAXIMUM_VERTECES;


// Append vertex to array buffer
static inline void addVertex(NSUInteger *length, NICSignaturePoint v) {
    if ((*length) >= maxLength) {
        return;
    }
    
    GLvoid *data = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
    memcpy(data + sizeof(NICSignaturePoint) * (*length), &v, sizeof(NICSignaturePoint));
    glUnmapBufferOES(GL_ARRAY_BUFFER);
    
    (*length)++;
}

static inline CGPoint QuadraticPointInCurve(CGPoint start, CGPoint end, CGPoint controlPoint, float percent) {
    double a = pow((1.0 - percent), 2.0);
    double b = 2.0 * percent * (1.0 - percent);
    double c = pow(percent, 2.0);
    
    return (CGPoint) {
        a * start.x + b * controlPoint.x + c * end.x,
        a * start.y + b * controlPoint.y + c * end.y
    };
}

static float generateRandom(float from, float to) { return random() % 10000 / 10000.0 * (to - from) + from; }
static float clamp(min, max, value) { return fmaxf(min, fminf(max, value)); }


// Find perpendicular vector from two other vectors to compute triangle strip around line
static GLKVector3 perpendicular(NICSignaturePoint p1, NICSignaturePoint p2) {
    GLKVector3 ret;
    ret.x = p2.vertex.y - p1.vertex.y;
    ret.y = -1 * (p2.vertex.x - p1.vertex.x);
    ret.z = 0;
    return ret;
}

static NICSignaturePoint ViewPointToGL(CGPoint viewPoint, CGRect bounds, GLKVector3 color) {

    return (NICSignaturePoint) {
        {
            (viewPoint.x / bounds.size.width * 2.0 - 1),
            ((viewPoint.y / bounds.size.height) * 2.0 - 1) * -1,
            0
        },
        color
    };
}


@interface Control()

@end
@interface NICSignatureView () {
    // OpenGL state
    EAGLContext *context;
    GLKBaseEffect *effect;
    
    GLuint vertexArray;
    GLuint vertexBuffer;
    GLuint dotsArray;
    GLuint dotsBuffer;
    
    CGSize _pageSize;
    // Array of verteces, with current length
    NICSignaturePoint SignatureVertexData[maxLength];
    NSUInteger length;
    
    NICSignaturePoint SignatureDotsData[maxLength];
    NSUInteger dotsLength;
    
    
    // Width of line at current and previous vertex
    float penThickness;
    float previousThickness;
    
    
    // Previous points for quadratic bezier computations
    CGPoint previousPoint;
    CGPoint previousMidPoint;
    NICSignaturePoint previousVertex;
    NICSignaturePoint currentVelocity;
}

@end
@implementation Control
@synthesize DismissView;
@end

@implementation NICSignatureView
@synthesize InvoiceID,recieversName;

- (void)commonInit {
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
      delegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
      contextForHeader = [delegate managedObjectContext];
      

    if (context) {
        time(NULL);
        
        self.context = context;
        self.drawableDepthFormat = GLKViewDrawableDepthFormat24;
		self.enableSetNeedsDisplay = YES;
        
        // Turn on antialiasing
        self.drawableMultisample = GLKViewDrawableMultisample4X;
        
        [self setupGL];
        
        // Capture touches
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
        [self addGestureRecognizer:pan];
        
        // For dotting your i's
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
        
        // Erase with long press
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];

    } else [NSException raise:@"NSOpenGLES2ContextException" format:@"Failed to create OpenGL ES2 context"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) [self commonInit];
    return self;
}

- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)ctx{
    if (self = [super initWithFrame:frame context:ctx]) [self commonInit];
    return self;
}

- (void)dealloc{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
	context = nil;
}

- (void)drawRect:(CGRect)rect{
    glClearColor(1, 1, 1, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    [effect prepareToDraw];
    
    // Drawing of signature lines
    if (length > 2) {
        glBindVertexArrayOES(vertexArray);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, length);
    }

    if (dotsLength > 0) {
        glBindVertexArrayOES(dotsArray);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, dotsLength);
    }

}

- (void)erase {
    length = 0;
    dotsLength = 0;
    self.hasSignature = NO;
	
	[self setNeedsDisplay];
}

- (UIImage *)signatureImage{
	if (!self.hasSignature)
		return nil;
    
    return [self snapshot];
}

#pragma mark - Gesture Recognizers

- (void)tap:(UITapGestureRecognizer *)t {
    CGPoint l = [t locationInView:self];
    
    if (t.state == UIGestureRecognizerStateRecognized) {
        glBindBuffer(GL_ARRAY_BUFFER, dotsBuffer);
        
        NICSignaturePoint touchPoint = ViewPointToGL(l, self.bounds, (GLKVector3){1, 1, 1});
        addVertex(&dotsLength, touchPoint);
        
        NICSignaturePoint centerPoint = touchPoint;
        centerPoint.color = StrokeColor;
        addVertex(&dotsLength, centerPoint);

        static int segments = 20;
        GLKVector2 radius = (GLKVector2){ penThickness * 2.0 * generateRandom(0.5, 1.5), penThickness * 2.0 * generateRandom(0.5, 1.5) };
        GLKVector2 velocityRadius = radius;//GLKVector2Multiply(radius, GLKVector2MultiplyScalar(GLKVector2Normalize((GLKVector2){currentVelocity.vertex.y, currentVelocity.vertex.x}), 1.0));
        float angle = 0;
        
        for (int i = 0; i <= segments; i++) {
            
            NICSignaturePoint p = centerPoint;
            p.vertex.x += velocityRadius.x * cosf(angle);
            p.vertex.y += velocityRadius.y * sinf(angle);
            
            addVertex(&dotsLength, p);
            addVertex(&dotsLength, centerPoint);
            
            angle += M_PI * 2.0 / segments;
        }
               
        addVertex(&dotsLength, touchPoint);
        
        glBindBuffer(GL_ARRAY_BUFFER, 0);
    }
    
    [self setNeedsDisplay];
}

- (void)longPress:(UILongPressGestureRecognizer *)lp {
    [self erase];
}

- (void)pan:(UIPanGestureRecognizer *)p {
    
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    
    CGPoint v = [p velocityInView:self];
    CGPoint l = [p locationInView:self];
    
    currentVelocity = ViewPointToGL(v, self.bounds, (GLKVector3){0,0,0});
    float distance = 0.;
    if (previousPoint.x > 0) {
        distance = sqrtf((l.x - previousPoint.x) * (l.x - previousPoint.x) + (l.y - previousPoint.y) * (l.y - previousPoint.y));
    }    

    float velocityMagnitude = sqrtf(v.x*v.x + v.y*v.y);
    float clampedVelocityMagnitude = clamp(VELOCITY_CLAMP_MIN, VELOCITY_CLAMP_MAX, velocityMagnitude);
    float normalizedVelocity = (clampedVelocityMagnitude - VELOCITY_CLAMP_MIN) / (VELOCITY_CLAMP_MAX - VELOCITY_CLAMP_MIN);
    
    float lowPassFilterAlpha = STROKE_WIDTH_SMOOTHING;
    float newThickness = (STROKE_WIDTH_MAX - STROKE_WIDTH_MIN) * normalizedVelocity + STROKE_WIDTH_MIN;
    penThickness = penThickness * lowPassFilterAlpha + newThickness * (1 - lowPassFilterAlpha);
    
    if ([p state] == UIGestureRecognizerStateBegan) {
        
        previousPoint = l;
        previousMidPoint = l;
        
        NICSignaturePoint startPoint = ViewPointToGL(l, self.bounds, (GLKVector3){1, 1, 1});
        previousVertex = startPoint;
        previousThickness = penThickness;
        
        addVertex(&length, startPoint);
        addVertex(&length, previousVertex);
		
		self.hasSignature = YES;
        
    } else if ([p state] == UIGestureRecognizerStateChanged) {
        
        CGPoint mid = CGPointMake((l.x + previousPoint.x) / 2.0, (l.y + previousPoint.y) / 2.0);
        
        if (distance > QUADRATIC_DISTANCE_TOLERANCE) {
            // Plot quadratic bezier instead of line
            unsigned int i;
            
            int segments = (int) distance / 1.5;
            
            float startPenThickness = previousThickness;
            float endPenThickness = penThickness;
            previousThickness = penThickness;
            
            for (i = 0; i < segments; i++)
            {
                penThickness = startPenThickness + ((endPenThickness - startPenThickness) / segments) * i;
                
                CGPoint quadPoint = QuadraticPointInCurve(previousMidPoint, mid, previousPoint, (float)i / (float)(segments));
                
                NICSignaturePoint v = ViewPointToGL(quadPoint, self.bounds, StrokeColor);
                [self addTriangleStripPointsForPrevious:previousVertex next:v];
                
                previousVertex = v;
            }
        } else if (distance > 1.0) {
            
            NICSignaturePoint v = ViewPointToGL(l, self.bounds, StrokeColor);
            [self addTriangleStripPointsForPrevious:previousVertex next:v];
            
            previousVertex = v;            
            previousThickness = penThickness;
        }
        
        previousPoint = l;
        previousMidPoint = mid;

    } else if (p.state == UIGestureRecognizerStateEnded | p.state == UIGestureRecognizerStateCancelled) {
        
        NICSignaturePoint v = ViewPointToGL(l, self.bounds, (GLKVector3){1, 1, 1});
        addVertex(&length, v);
        
        previousVertex = v;
        addVertex(&length, previousVertex);
    }
    
	[self setNeedsDisplay];
}

#pragma mark - Private

- (void)bindShaderAttributes {
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(NICSignaturePoint), 0);
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE,  6 * sizeof(GLfloat), (char *)12);
}

- (void)setupGL{
    [EAGLContext setCurrentContext:context];
    
    effect = [[GLKBaseEffect alloc] init];
    
    glDisable(GL_DEPTH_TEST);
    
    // Signature Lines
    glGenVertexArraysOES(1, &vertexArray);
    glBindVertexArrayOES(vertexArray);
    
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SignatureVertexData), SignatureVertexData, GL_DYNAMIC_DRAW);
    [self bindShaderAttributes];
    
    
    // Signature Dots
    glGenVertexArraysOES(1, &dotsArray);
    glBindVertexArrayOES(dotsArray);
    
    glGenBuffers(1, &dotsBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, dotsBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(SignatureDotsData), SignatureDotsData, GL_DYNAMIC_DRAW);
    [self bindShaderAttributes];
    
    
    glBindVertexArrayOES(0);


    // Perspective
    GLKMatrix4 ortho = GLKMatrix4MakeOrtho(-1, 1, -1, 1, 0.1f, 2.0f);
    effect.transform.projectionMatrix = ortho;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -1.0f);
    effect.transform.modelviewMatrix = modelViewMatrix;
    
    length = 0;
    penThickness = 0.003;
    previousPoint = CGPointMake(-100, -100);
}

- (void)addTriangleStripPointsForPrevious:(NICSignaturePoint)previous next:(NICSignaturePoint)next {
    float toTravel = penThickness / 2.0;
    
    for (int i = 0; i < 2; i++) {
        GLKVector3 p = perpendicular(previous, next);
        GLKVector3 p1 = next.vertex;
        GLKVector3 ref = GLKVector3Add(p1, p);
        
        float distance = GLKVector3Distance(p1, ref);
        float difX = p1.x - ref.x;
        float difY = p1.y - ref.y;
        float ratio = -1.0 * (toTravel / distance);
        
        difX = difX * ratio;
        difY = difY * ratio;
                
        NICSignaturePoint stripPoint = {
            { p1.x + difX, p1.y + difY, 0.0 },
            StrokeColor
        };
        addVertex(&length, stripPoint);
        
        toTravel *= -1;
    }
}

- (void)tearDownGL{
    [EAGLContext setCurrentContext:context];
    
    glDeleteBuffers(1, &vertexBuffer);
    glDeleteVertexArraysOES(1, &vertexArray);
    
    effect = nil;
}

- (IBAction)StoreSignedInvoice:(id)sender {
     [self createPDF];
}

- (IBAction)EraseSignature:(id)sender {
    
    [self erase];
    
}


#pragma Mark PDF Methods

- (void)createPDF{
    
    [self setupPDFDocumentNamed:[InvoiceID stringValue] Width:850 Height:1100];

    [self beginPDFPage];
    
    [self  DrawTheInvoiceProductsContent];
    
    [self finishPDF];
}

-(void)DrawTheInvoiceProductsContent{
    
    NSString *str = delegate.InvoiceIDGlobal;
    NSNumber * CustomerID;
    str = [str stringByReplacingOccurrencesOfString:@".pdf"withString:@""];
    str =[str stringByReplacingOccurrencesOfString:@"Invoice # "withString:@""];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:str];
    InvoiceID = myNumber;
    NSArray *invoices= [self GetInvoicesByInvoiceID];
    NSArray *invoices_lines2;
    for (NSArray *item in invoices) {
        
        NSString *InvoiceLinesID = [NSString stringWithFormat:@"%@",[item valueForKey:@"docNum"]];
        invoices_lines2= [self GetInvoiceLines:InvoiceLinesID];
        CustomerID = [item valueForKey:@"custID"];
        InvoiceDate = [NSString stringWithFormat:@"%@",[item valueForKey:@"docDate"]];
        InvoicePO = [NSString stringWithFormat:@"%@",[item valueForKey:@"custPONum"]];
    }
    
    UIImage *anImage = [UIImage imageNamed:@"InvoiceTemplate.png"];
    [self addImage:anImage  atPoint:CGPointMake(100, 60)];
    totalOfTheWholeInvoice=@"0";
    int textPosititonAX=180;
    int textPosititonBX=360;
    int textPosititonCX=463;
    int textPosititonDX=607;
    int textPosititonY = 456;
    int productCounter =0;
    for (NSArray *invoices_lines in invoices_lines2){
        
        NSString *productIDs = [NSString stringWithFormat:@"%@",[invoices_lines valueForKey:@"productID"]];
        
        NSArray *products= [self Getproducts:productIDs];
        
        for(NSArray *item in products){
            
            NSString *Productnames = [NSString stringWithFormat:@"%@",[item valueForKey:@"name"]];
            [self addText: Productnames  withFrame:CGRectMake(textPosititonAX, textPosititonY, 150, 150) fontSize:13.0f];}
        
        NSString *quantitys = [NSString stringWithFormat:@"%@",[invoices_lines valueForKey:@"quantity"]];
        [self addText: quantitys  withFrame:CGRectMake(textPosititonBX, textPosititonY, 150, 150) fontSize:13.0f];
        
        NSString *unitPrices = [NSString stringWithFormat:@"%@",[invoices_lines valueForKey:@"unitPrice"]];
        NSString * totalPerProduct = [self multiplyNumber:quantitys  byNumber:unitPrices ];
        
        totalOfTheWholeInvoice =[self addNumber:totalOfTheWholeInvoice withNumber:totalPerProduct];
        
        [self addText: unitPrices withFrame:CGRectMake(textPosititonCX, textPosititonY, 150, 150) fontSize:13.0f];
        
        [self addText: [NSString stringWithFormat:@"%@",totalPerProduct ] withFrame:CGRectMake(textPosititonDX, textPosititonY, 150, 150) fontSize:13.0f];
        
        textPosititonY =textPosititonY+22;
        productCounter=productCounter+1;
        
    }
    
    [self addText: totalOfTheWholeInvoice withFrame:CGRectMake(561, 800, 150, 150) fontSize:13.0f];
    UIImage * signature = [self signatureImage];
    CGImageRef imgRef = CGImageCreateWithImageInRect([signature CGImage], CGRectMake(100, 300, 800, 260));
	UIImage* cropedImg =[UIImage imageWithCGImage:imgRef];
    [self addImage:cropedImg  atPoint:CGPointMake(460, 850)];
   
    
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"custID = %@",CustomerID]];
    NSArray *Customers= [contextForHeader executeFetchRequest:request error:&error];

    for (NSArray *Cos in Customers) {
    
        NSString * businessName= [NSString stringWithFormat:@"%@",[Cos valueForKey:@"businessName"]];
        NSString * addressOne= [NSString stringWithFormat:@"%@",[Cos valueForKey:@"addressOne"]];
        NSString * city= [NSString stringWithFormat:@"%@",[Cos valueForKey:@"city"]];
        NSString * state= [NSString stringWithFormat:@"%@",[Cos valueForKey:@"state"]];
        NSString * telefone= [NSString stringWithFormat:@"%@",[Cos valueForKey:@"telefone"]];
        NSString * zipcode= [NSString stringWithFormat:@"%@",[Cos valueForKey:@"zipcode"]];
        NSString * fullAddress= [NSString stringWithFormat:@"%@ %@ %@",city , state,zipcode];

    [self addText:[NSString stringWithFormat:@"%@\n%@\n%@\n%@", businessName,addressOne, fullAddress,telefone]
        withFrame:CGRectMake(130, 328, 150, 150) fontSize:15.0f];
    
    [self addText:[NSString stringWithFormat:@"%@\n%@\n\n%@",InvoiceDate, myNumber, InvoicePO]
        withFrame:CGRectMake(630, 227, 150, 150) fontSize:13.0f];
        
         [self addText:[NSString stringWithFormat:@"%@" ,recieversName.text] withFrame:CGRectMake(530, 920, 150, 150) fontSize:15.0f];
    }
}

-(NSArray*)GetCustomerByCustID{
    
    NSError *error = nil;
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Customer" inManagedObjectContext:contextForHeader]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"custID = %@",1]];
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
    NSArray *Invoice_Lines1= [contextForHeader executeFetchRequest:request error:&error];
    return Invoice_Lines1;
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

-(NSNumber*)getGetNextNumericValueForFieldName: (NSString*) fieldName withEntityName: (NSString*) entityName {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMddhhmmss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    int dateDocNum = [dateString intValue];
    NSNumber * DocumentNUmber = [NSNumber numberWithInt:dateDocNum];
    return DocumentNUmber;
    
}

- (void)setupPDFDocumentNamed:(NSString*)name Width:(float)width Height:(float)height {
  
    _pageSize = CGSizeMake(width, height);
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMddhhmmss"];
    NSString *dateString = [dateFormat stringFromDate:date];
    NSString *newPDFName = [NSString stringWithFormat:@"%@ %@.%@",@"Invoice Signed #",dateString,@"pdf"];
    
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

}

CGPDFDocumentRef MyGetPDFDocumentRef (const char *filename)
{
    CFStringRef path;
    CFURLRef url;
    CGPDFDocumentRef document;
    size_t count;
    
    path = CFStringCreateWithCString (NULL, filename,
                                      kCFStringEncodingUTF8);
    url = CFURLCreateWithFileSystemPath (NULL, path, // 1
                                         kCFURLPOSIXPathStyle, 0);
    CFRelease (path);
    document = CGPDFDocumentCreateWithURL (url);// 2
    CFRelease(url);
    count = CGPDFDocumentGetNumberOfPages (document);// 3
    if (count == 0) {
        printf("`%s' needs at least one page!", filename);
        return NULL;
    }
    return document;
}
@end
