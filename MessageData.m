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
@interface MessageData () {
    MessageFeed* _feed;
    MessagesViewController* _messviev;
}

@end

@implementation MessageData

@synthesize JSONmessages;
@synthesize messages;

- (void)fetchFeed
{
    
//    
//    //One way to get the feed - this one is using the JSONModel
//    NSString *conversationid = @"55";
//    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_messages.php?conversation=%@", conversationid];
//    _feed = [[MessageFeed alloc] initFromURLWithString:callURL
//                                                 completion:^(JSONModel *model, JSONModelError *err) {
//                                                     
//                                                     
//                                                     
//                                                     //json fetched
//                                                     
//                                                     NSLog(@"Loaded %@", _feed.messagesinconversation);
//                                                     //This is simply wrong
//                                                     JSONmessages = _feed.messagesinconversation;
//                                                     
//                                                 }];

    // Another way of getting the feed. This works better but will still not update he self.messages in MessageViewController

    //1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //code executed in the background
        //2
        NSString *conversationid = @"55";
        messages = [[NSMutableArray alloc] init];
        [messages addObject:[NSString stringWithFormat:@"Conversation id %@", conversationid]];
        [messages addObject:@"Added before the call."];
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

               // [self updateUIWithDictionary:json];
            }

            
        });
        
    });

   
    
}

-(void)updateUIWithDictionary:(NSDictionary*)json {
    
   
    
    @try {
        
        
         NSLog(@"test hmmm %@", messages);
//        
//        NSArray* keys = [[JSONmessages valueForKey:@"messagesinconversation"] allObjects];
//        
//        int count = [keys count] ;
//        NSLog(@"Parse count is %i", count);
//        for (int i=0; i < count; i++) {
//            
//            NSString *message = (NSString *)JSONmessages[@"messagesinconversation"][i][@"message"];
//            [messages addObject:message];
//           
//        }
//        
//        [messages addObject:@"Added after the for loop. Why?"];
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
      //  NSString* key =@"messagecreated";
      //  [messages addObjectsFromArray:[[JSONmessages objectForKey:@"messagesinconversation"]valueForKey:[key stringByReplacingOccurrencesOfString:@"\n" withString:@""]]];
        
        [messages addObject:@"Added after the call."];
        
        NSLog(@"Final: %@", messages);
           }


   
    
}



@end
