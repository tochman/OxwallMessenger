//
//  MessagesViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessagesViewController.h"
#import "ODRefreshControl.h"

#pragma mark - Initialization

@interface MessagesViewController ()
@end

@implementation MessagesViewController
@synthesize messages, json;

static NSString *conversationid;

- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}

+ (void)conversationIdMthd : (NSString *)conversationIdStr {
    conversationid = conversationIdStr;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    self.title = @"Messages";
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSLog(@"conversationid :%@",conversationid);
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_messages.php?conversation=%@", conversationid];
    NSData* messFeed = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:callURL]
                        ];
    
    if (messFeed) {
        
        json = [NSJSONSerialization
                JSONObjectWithData:messFeed
                options:kNilOptions
                error:nil];
    }
    
    [self setArrays];
    
    
    
    //Refresh  code
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)setArrays {
    self.messages = [[NSMutableArray alloc]init];
    
    NSString* key =@"message";
    [self.messages addObjectsFromArray:[[json objectForKey:@"messagesinconversation"]valueForKey:[key stringByReplacingOccurrencesOfString:@"\n" withString:@""]]];
    
    if (!self.messages){
        NSLog(@"Messages empty");
    } else {
        NSLog(@"Messages in MessVC: %@", self.messages);
        
    }
    
    self.timestamps = [[NSMutableArray alloc] init];
    NSString* messagecreated =@"messagecreated";
    [self.timestamps addObjectsFromArray:[[json objectForKey:@"messagesinconversation"]valueForKey:messagecreated]];
    
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
    return self.messages.count;
    NSLog(@"Messages count: %i", self.messages.count);
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    [self.messages addObject:text];
    
    [self.timestamps addObject:text];
    
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
    return JSMessagesViewAvatarPolicyNone;
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
    return (self.messages)[indexPath.row];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.timestamps)[indexPath.row];
}

- (UIImage *)avatarImageForIncomingMessage
{
    return [UIImage imageNamed:@"demo-avatar-woz"];
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

#pragma mark - ODRefreshControl
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    //Refresh code - for now it is just for show, not fully implemented
    double delayInSeconds = 1.0;
    [self.messages addObject:@"Added @ MessVC."];
    
    [self setArrays];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
}

@end