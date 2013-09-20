

#import "Model.h"
#import "JSON.h"


@implementation Model
@synthesize captured_MutableDataInfo;
@synthesize delegate;
- (id)init
{
    self = [super init];
    if (self)
    {
        //singleObj = [[SingletonClass alloc]init];
    }
    return self;
}


-(void)loadUrl:(NSString *)urlString_param connec_identific :(int)identific;
{
    identi_lcl = identific;
   
    NSMutableString *tempStr = [NSMutableString stringWithString:urlString_param];
    [tempStr replaceOccurrencesOfString:@" " withString:@"+" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempStr length])];
    NSURL *url = [NSURL URLWithString:tempStr];

    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
   //[theRequest setHTTPMethod: @"GET"];
    
   if (identi_lcl == 10000) {
        
    }
    else{
  
    }
        
    theConnection_Obj_One = [[NSURLConnection alloc]initWithRequest:theRequest delegate:self startImmediately:YES];
    if (theConnection_Obj_One)
    {
        self.captured_MutableDataInfo = [[NSMutableData alloc]init];
       
        //[self showHud];
        
        [theConnection_Obj_One start];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"No data found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
    
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
     NSLog(@"connection sucessfullly established...");
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"the status code obtained is %d", code);
    
    if (code == 200) {
        if (theConnection_Obj_One)
        {
           NSLog(@"the status code is %i", code);
            
            
            if (identi_lcl == 10000) {
                NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
                NSDictionary *fields = [HTTPResponse allHeaderFields];
                NSString *cookie = [fields valueForKey:@"Set-Cookie"]; // It is your cookie
                NSLog(@"cooo  :%@", cookie);
                NSArray *cookieArray =  [cookie componentsSeparatedByString:@";"];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setValue:[cookieArray objectAtIndex:0]  forKey:@"cookiekey"];
                
            }
            else
            {
                
                NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            }
            [self.captured_MutableDataInfo setLength:0];
            
        }
    } 
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)dataP
{
    [self.captured_MutableDataInfo appendData:dataP];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *jsonStringData = [[NSString alloc]initWithData:self.captured_MutableDataInfo encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@", jsonStringData);
    
    if (jsonStringData.length != 0)
    {
        NSDictionary *jsonResult_dicResult = [jsonStringData JSONValue];
        resilt_to_be_sent = jsonResult_dicResult;
        [delegate didReceiveResponse:resilt_to_be_sent connection_tag:identi_lcl]; 
    }
    
}


@end
