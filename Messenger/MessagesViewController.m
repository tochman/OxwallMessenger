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
@synthesize JSONmessages;
@synthesize messages;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.title = @"Messages";
    [self fetchFeed];
    
     NSLog(@"test %@", messages);
}


- (id)fetchFeed
{
    __block NSMutableArray* mess;
    NSString *conversationid = @"55";
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_messages.php?conversation=%@", conversationid];
    
    
    
    _feed = [[MessageFeed alloc] initFromURLWithString:callURL //this method takes some time to complete and is handled on a different thread.
                                            completion:^(JSONModel *model, JSONModelError *err)
             {
                 mess = [[NSMutableArray alloc]initWithObjects:[_feed.messagesinconversation valueForKey:@"message"], nil];
                 NSLog(@"messages %@", mess); // this is called last in your code and your messages has been has been set as an iVar.
             }];
    // this logging is called immediately after initFromURLWithString is passed thus it will return nothing
    messages = mess;
    NSLog(@"messages %@", messages);
    return messages;

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
