//
//  MessagesViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
#import "MessagesViewController.h"
#import "ODRefreshControl.h"



#pragma mark - Initialization

@interface MessagesViewController ()
@end

@implementation MessagesViewController

@synthesize messages, json, jsonDict;

static NSString *conversationid;
static NSString *receiver;
static NSURL *senderAvatarURL;
static UIImage *senderAvatar;

ODRefreshControl *refreshControl1;

- (UIButton *)sendButton
{
    // Override to use a custom send button
    // The button's frame is set automatically for you
    return [UIButton defaultSendButton];
}

+ (void)conversationIdMthd : (NSString *)conversationIdStr {
    conversationid = conversationIdStr;
}

+ (void)receiverIdMthd : (NSString *)receiverIdStr; {
    receiver = receiverIdStr;
}

+ (void)senderAvatarMthd : (NSURL *)senderAvatarPassed {
    
    senderAvatarURL = senderAvatarPassed;
    return; //??
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
    
    json =[[NSMutableDictionary alloc]init];
    NSLog(@"MVC conversationid :%@",conversationid);
    NSLog(@"MVC sender avatar %@", senderAvatarURL);
    NSLog(@"MVC reciever %@", receiver);
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    self.sender = [standardUserDefaults stringForKey:@"userid"];
    
    
    
    NSString *callURL = [NSString stringWithFormat:@"%@/inbox_messages.php?conversationId=%@", BASE_URL, conversationid];
    NSData* messFeed = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:callURL]
                        ];
    
    if (messFeed) {
        // Make sure json is truly mutable
        json = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization
                                                              JSONObjectWithData:messFeed
                                                              options:kNilOptions
                                                              error:nil]];
    }
    
    
    
    //Refresh  code
    ODRefreshControl* refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    timer1 = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                            selector: @selector(dropViewDidBeginRefreshingTime:) userInfo: nil repeats: YES];
    timer2 = [NSTimer scheduledTimerWithTimeInterval: 35.0 target: refreshControl
                                            selector: @selector(beginRefreshing) userInfo: nil repeats: YES];
    timer3 = [NSTimer scheduledTimerWithTimeInterval: 40.0 target: refreshControl
                                            selector: @selector(endRefreshing) userInfo: nil repeats: YES];
    
    //Make all unwanted characters disappear
    [self cleanArray];
    
    //Load the avatar of sender - we are not implementing avatars for outgoing messages
    [self getAvatar];
    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:YES];
}

-(void) viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
    
    [json removeAllObjects];
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
    }

}


- (void)getAvatar {
    
    senderAvatar = [[UIImage alloc]init];
    senderAvatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:senderAvatarURL]];
    
}




#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger keyCountForObject = [[[json objectForKey:@"messagesinconversation"]allObjects ] count];
    return keyCountForObject;
    //return self.messages.count;
    
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{

    
    self.newmessage = text;
    
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self sendMessage:self];
    [self scrollToBottomAnimated:YES];
    [self finishSend];
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Create custom method to display separate incoming from outgoing messages.
    if ([[[json objectForKey:@"messagesinconversation"]valueForKey:@"sentbyID"][indexPath.row] isEqual:self.sender]) {
        return (indexPath.row) ? JSBubbleMessageTypeOutgoing : JSBubbleMessageTypeOutgoing;
    }
    
    return (indexPath.row) ? JSBubbleMessageTypeIncoming : JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    //TODO: No timestamps are showing.
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyIncomingOnly;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleCircle;
}



#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([[json objectForKey:@"messagesinconversation"]valueForKey:@"message"]) [indexPath.row];
    
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([[json objectForKey:@"messagesinconversation"]valueForKey:@"messagecreated"]) [indexPath.row];
    
}

- (UIImage *)avatarImageForIncomingMessage
{
    return senderAvatar;
}

- (UIImage *)avatarImageForOutgoingMessage
{
    return senderAvatar;
}

#pragma mark - ODRefreshControl


// Why two methods????

- (void)dropViewDidBeginRefreshing: (ODRefreshControl *)refreshControl
{
    //Refresh code - for now it is just for show, not fully implemented
    double delayInSeconds = 1.0;
    //[self.messages addObject:@"Added @ MessVC."];
    [self loadJson];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [refreshControl endRefreshing ];
    });
}

- (void)dropViewDidBeginRefreshingTime: (ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self loadJson];
    });
}

- (void)endRefresh:(NSTimer *)timer
{
    ODRefreshControl* refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    refreshControl = (ODRefreshControl *)timer;
    [refreshControl endRefreshing];
}

- (IBAction)sendMessage:(id)sender{
    
    [self doPOST];
    [self scrollToBottomAnimated:YES];
    
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger numberOfRows = [self.tableView numberOfRowsInSection:0];
    if (numberOfRows) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:numberOfRows-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)doPOST {
    //Prepering for POST request
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:[NSString stringWithFormat:@"%@/inbox_addmessage.php", BASE_URL]]];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString =[NSString stringWithFormat:@"conversationId=%@&timeStamp=%d&senderId=%@&recipientId=%@&text=%@&",
                           conversationid,
                           timestamp,
                           self.sender,
                           self.receiver,
                           self.newmessage];
    
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
    [self dropViewDidBeginRefreshingTime:nil];
    [self scrollToBottomAnimated:YES];
    [self.tableView reloadData];
    return;
    
}

-(void)cleanArray
{
    //clean up array
    //get the array of message dictionaries:
    NSArray * mess = [json objectForKey:@"messagesinconversation"];
    
    //create new array for new messages
    NSMutableArray * newMessages = [NSMutableArray arrayWithCapacity:mess.count];
    
    //then iterate over all messages
    for (NSDictionary * dict in mess)
    {
        //create new mutable dictionary
        jsonDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        //get the original text
        NSString * msg = [dict objectForKey:@"message"];
        msg = [msg stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        msg = [msg stringByReplacingOccurrencesOfString:@"- sent with OxwallMessenger" withString:@""];
        [jsonDict setObject:msg forKey:@"message"];
        //store the new dict in new array
        [newMessages addObject:jsonDict];
        //Now we update the json object
        [json setObject:newMessages forKey:@"messagesinconversation"];
        
    }
    
    
}

- (void) loadJson {
    NSLog(@"conversationID %@", conversationid);
    NSString *callURL = [NSString stringWithFormat:@"%@/inbox_messages.php?conversationId=%@", BASE_URL, conversationid];
    NSData* messFeed = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString:callURL]
                        ];
    
    if (messFeed) {
        // Make sure json is truly mutable
        json = [NSMutableDictionary dictionaryWithDictionary:[NSJSONSerialization
                                                              JSONObjectWithData:messFeed
                                                              options:kNilOptions
                                                              error:nil]];
        [self cleanArray];
        [self scrollToBottomAnimated:YES];
        [self.tableView reloadData];
    }
    
}

@end