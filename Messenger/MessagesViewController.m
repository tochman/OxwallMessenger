//
//  MessagesViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessagesViewController.h"

#import "JSONModelLib.h"
#import "MessageFeed.h"
#import "HUD.h"

@interface MessagesViewController ()
{
    
    MessageFeed* _feed;
    NSMutableArray *messeges;
    
}

@end

@implementation MessagesViewController
@synthesize JSONmessages;
@synthesize messages;

#pragma mark - View lifecycle

- (void)awakeFromNib

{
    [self performSelector: @selector(fetchFeed:) withObject:self afterDelay: 0.0];
    //[self fetchFeed];
    messages = [[NSMutableArray alloc] initWithObjects:
                @"Testing some messages here.",
                @"Options for avatars: none, circles, or squares",
                nil];
    NSLog(@"test %@", JSONmessages);
    
    
}

- (void)viewDidLoad
{

[super viewDidLoad];
   
    
    self.delegate = self;
    self.dataSource = self;
    self.title = @"Messages";
    
    
   
}



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
            JSONmessages = json;
            [self updateUIWithDictionary: JSONmessages];
        });
        
    });

  


}

-(void)updateUIWithDictionary:(NSDictionary*)json {
    NSLog(@"updated? %@", JSONmessages);
    
    @try {
        
        
        NSArray* keys = [[JSONmessages valueForKey:@"messagesinconversation"] allObjects];
        
        int count = [keys count] ;
        NSLog(@"count is %i", count);
        for (int i=0; i < count; i++) {
            NSString *message = (NSString *)[[[JSONmessages objectForKey:@"messagesinconversation"] objectAtIndex:i] objectForKey:@"message"];
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
NSLog(@"Parsed: %@", messages);
NSLog(@"Parsed: %i", messages.count);
    
    



}

- (void)buttonPressed:(UIButton*)sender
{
    // Testing pushing/popping messages view
    MessagesViewController *vc = [[MessagesViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [messages addObject:text];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}




- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeOutgoing;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleSquare;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleSquare;
}

//  Optional delegate method
//  Required if using `JSMessagesViewTimestampPolicyCustom`
//
//  - (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
//

#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.timestamps objectAtIndex:indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}



@end
