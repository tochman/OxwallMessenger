

#import <Foundation/Foundation.h>

@protocol WebServiceConnectorDelegate
@required
-(void)didReceiveResponse:(id)response connection_tag:(int)tagvalue_idnt;
@end
@interface Model : NSObject <NSURLConnectionDataDelegate>

{

    NSURLConnection *theConnection_Obj_One;
    NSDictionary *resilt_to_be_sent;
    id delegate;
    int identi_lcl;
    NSData *datappp;
    NSString *cookieestr;


}
@property(strong,nonatomic) NSMutableData  *captured_MutableDataInfo;
@property(strong,nonatomic) id delegate;
-(void)loadUrl:(NSString *)urlString_param connec_identific :(int)identific;

@end
