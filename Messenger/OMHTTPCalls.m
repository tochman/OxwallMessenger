//
//  OMHTTPCalls.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-10-19.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "OMHTTPCalls.h"
#import "Constants.h"
#import "DUViewController.h"

@implementation OMHTTPCalls
NSString *SITE;
NSString *BASE_URL;

+ (void) notifyLogin: (NSString* )userid {
    SITE = [Constants getSiteName];
    BASE_URL = [Constants getBaseUrl];
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:[NSString stringWithFormat:@"%@/om_notify_login.php", BASE_URL]]];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"userId=%@&timeStamp=%d",
                           userid,
                           timestamp];
    
    [request setValue:[NSString
                       stringWithFormat:@"%d", [postString length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postString
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    double delayInSeconds = 1.0;
    
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
    });
    //reload everything
    return;


}

+ (void) deleteConversation: (NSString* )userId conversation:(NSString*)conversationId{
    SITE = [Constants getSiteName];
    BASE_URL = [Constants getBaseUrl];
//    int timestamp = [[NSDate date] timeIntervalSince1970];
//    NSMutableURLRequest *request =
//    [[NSMutableURLRequest alloc] initWithURL:
//     [NSURL URLWithString:[NSString stringWithFormat:@"%@/delete_conversation.php", BASE_URL]]];
//    
//    [request setHTTPMethod:@"POST"];
//    NSString *postString =[NSString stringWithFormat:@"userId=%@&conversationId=%@",
//                           userId,
//                           conversationId];
//    
//    [request setValue:[NSString
//                       stringWithFormat:@"%d", [postString length]]
//   forHTTPHeaderField:@"Content-length"];
//    
//    [request setHTTPBody:[postString
//                          dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    
//    double delayInSeconds = 1.0;
//    
//    
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        
//    });
//    //reload everything
    NSLog(@"Passed userId: %@",userId);
    NSLog(@"Passed conversationId: %@",conversationId);
    return;


}




@end
