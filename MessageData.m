//
//  MessageData.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-17.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessageData.h"
#import "MessagesViewController.h"
#import "JSONModelLib.h"
#import "MessageFeed.h"

@implementation MessageData

@synthesize JSONmessages;
@synthesize messages;

- (void)fetchFeed
{
    
    
    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //code executed in the background
        //2
        NSString *conversationid = @"55";
        NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_messages.php?conversation=%@", conversationid];
        NSData* messFeed = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString:callURL]
                            ];
        
        //3
        
        
        //4
        dispatch_async(dispatch_get_main_queue(), ^{
            //code executed on the main queue
            //5
            NSDictionary* json = nil;
            if (messFeed) {
                
                json = [NSJSONSerialization
                        JSONObjectWithData:messFeed
                        options:kNilOptions
                        error:nil];
                JSONmessages = json;
                [self updateUIWithDictionary:JSONmessages];
            }

            
        });
        
    });

   
    
}

-(void)updateUIWithDictionary:(NSDictionary*)json {
    
    
    
    @try {
        
        messages = [[NSMutableArray alloc] init];
       // [messages addObject:@"Added before the for loop."];
        [messages addObject:@"Added to MV before the for loop."];
        
        NSArray* keys = [[JSONmessages valueForKey:@"messagesinconversation"] allObjects];
        
        int count = [keys count] ;
        NSLog(@"Parse count is %i", count);
        for (int i=0; i < count; i++) {
            
            NSString *message = (NSString *)[[[JSONmessages objectForKey:@"messagesinconversation"] objectAtIndex:i] objectForKey:@"message"];
            [messages addObject:message];
           
        }
        
        //[messages addObject:@"Added after the for loop. Why?"];
        [messages addObject:@"Added to MV after the for loop. Why?"];
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Could not parse the JSON feed."
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles: nil] show];
        NSLog(@"Exception: %@", exception);
    }
    
    @finally {
       
        NSLog(@"Final: %@", messages);
           }


   
    
}


@end
