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
}

@end

@implementation MessagesViewController
//@synthesize message;
@synthesize JSONmessages;
@synthesize messages;
#pragma mark - Initialization
- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    [self loadfeed];

    NSLog (@"createD messages: %@'", messages);

    self.delegate = self;
    self.dataSource = self;
    
    self.title = @"Messages";
    

}


-(void)viewDidAppear:(BOOL)animated {

    
    
    
    
    /*self.messages = [[NSMutableArray alloc] initWithObjects:
                     @"Testing some messages here.",
                     @"Options for avatars: none, circles, or squares",
                     @"This is a complete re-write and refactoring.",
                     @"It's easy to implement. Sound effects and images included. Animations are smooth and messages can be of arbitrary size!", nil];
    
    */

   
NSLog (@"self.messages: %@'", self.messages);
    
    //NSLog (@"messages: %@'", messages);
    
    self.timestamps = [[NSMutableArray alloc] initWithObjects:
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate distantPast],
                       [NSDate date],
                       nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward
                                                                                           target:self
                                                                                           action:@selector(buttonPressed:)];
    
    
   
    




}

- (void)buttonPressed:(UIButton*)sender
{
    // Testing pushing/popping messages view
    MessagesViewController *vc = [[MessagesViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadfeed {
    [HUD showUIBlockingIndicatorWithText:@"Retriving data"];
    NSString *conversationid = @"55";
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_messages.php?conversation=%@", conversationid];
    
    [JSONHTTPClient getJSONFromURLWithString: callURL
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      //got JSON back
                                      [HUD hideUIBlockingIndicator];
                                      //NSLog(@"Got JSON from web: %@", json);
                                      JSONmessages = json;
[self createArray];
    
                                      
    }];
    
    
    return;
    
}
- (NSMutableArray *)createArray

{
    messages = [[NSMutableArray alloc] init];
    NSArray* keys = [[JSONmessages valueForKey:@"messagesinconversation"] allObjects];
    
    int count = [keys count] ;
    NSLog(@"count is %i", count);
    for (int i=0; i < count; i++) {
        NSString *message = (NSString *)[[[JSONmessages objectForKey:@"messagesinconversation"] objectAtIndex:i] objectForKey:@"message"];
        [messages addObject:message];
        
    }
    
    
    NSLog(@"createArray produces %@", messages);
    return messages;
}





#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messages addObject:text];
    
    [self.timestamps addObject:[NSDate date]];
    
    if((self.messages.count - 1) % 2)
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
    return [messages objectAtIndex:indexPath.row];
      
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
