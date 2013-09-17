//
//  MessageData.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-17.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessageData.h"
#import "JSONModelLib.h"
#import "MessageFeed.h"

@implementation MessageData
@synthesize JSONmessages;
@synthesize messages;
@synthesize gMesseges;

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
            }
            //NSLog(@"json: %@", json);
            [self updateUIWithDictionary: json];
        });
        
    });

   
    
}

-(void)updateUIWithDictionary:(NSDictionary*)json {
    
    messages = [[NSMutableArray alloc] initWithObjects:
                     @"Testing some messages here.",
                     @"Options for avatars: none, circles, or squares",
                     @"This is a complete re-write and refactoring.",
                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!",
                     nil];
    
    [messages addObject:@"Test"];
    
    @try {
        
        
        NSArray* keys = [[json valueForKey:@"messagesinconversation"] allObjects];
        
        int count = [keys count] ;
        //NSLog(@"Parse count is %i", count);
        for (int i=0; i < count; i++) {
            NSString *message = (NSString *)[[[json objectForKey:@"messagesinconversation"] objectAtIndex:i] objectForKey:@"message"];
            [messages addObject:message];
           
        }
       
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Could not parse the JSON feed."
                                   delegate:nil
                          cancelButtonTitle:@"Close"
                          otherButtonTitles: nil] show];
        NSLog(@"Exception: %@", exception);
    }

   // NSLog(@"Parsed: %@", messages);
   // NSLog(@"Parsed count: %i", messages.count);
   //[self sendArray:messages];
    
}

-(void)sendArray:(NSMutableArray*)array {
    //gMesseges = [[NSMutableArray alloc] initWithObjects:messages, nil];
    NSLog(@"gMesseges: %@", messages);
}

@end
