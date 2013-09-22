//
//  MessagesViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//
#import <SDWebImage/UIImageView+WebCache.h>
#import "MessagesViewController.h"
#import "ODRefreshControl.h"



#pragma mark - Initialization

@interface MessagesViewController ()
@end

@implementation MessagesViewController

@synthesize messages, json;
@synthesize imageView = _imageView;
static NSString *conversationid;
static NSString *receiver;
//static NSURL *senderAvatarURL;
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

+ (void)senderAvatarMthd : (UIImage *)senderAvatarPassed {

    senderAvatar = senderAvatarPassed;
    return;
    
    
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
    NSLog(@"%@", senderAvatar);
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
    
    
    //Refresh  code
    ODRefreshControl* refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    timer1 = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                            selector: @selector(dropViewDidBeginRefreshingTime:) userInfo: nil repeats: YES];
    timer2 = [NSTimer scheduledTimerWithTimeInterval: 35.0 target: refreshControl
                                            selector: @selector(beginRefreshing) userInfo: nil repeats: YES];
    timer3 = [NSTimer scheduledTimerWithTimeInterval: 40.0 target: refreshControl
                                            selector: @selector(endRefreshing) userInfo: nil repeats: YES];
    
    
    [self setArrays];
}

-(void) viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [timer1 invalidate];
    [timer2 invalidate];
    [timer3 invalidate];
}

- (void)setArrays {
    self.messages = [[NSMutableArray alloc]init];
    
    NSString* key =@"message";
    [self.messages addObjectsFromArray:[[json objectForKey:@"messagesinconversation"]valueForKey:key]];
    
    [self cleanArray];
    
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
    
    self.newmessage = text;
    
    if((self.messages.count - 1) % 2)
        [JSMessageSoundEffect playMessageSentSound];
    else
        [JSMessageSoundEffect playMessageReceivedSound];
    
    [self sendMessage:self];
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
    return JSMessagesViewAvatarPolicyIncomingOnly;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleCircle;
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
    return senderAvatar;
}

- (UIImage *)avatarImageForOutgoingMessage
{
   return senderAvatar;
}

#pragma mark - ODRefreshControl
- (void)dropViewDidBeginRefreshing: (ODRefreshControl *)refreshControl
{
    //Refresh code - for now it is just for show, not fully implemented
    double delayInSeconds = 1.0;
    [self.messages addObject:@"Added @ MessVC."];
    
    [self setArrays];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing ];
    });
}

- (void)dropViewDidBeginRefreshingTime: (ODRefreshControl *)refreshControl
{
    double delayInSeconds = 1.0;
    [self.messages addObject:@"Added @ MessVC."];
    
    [self setArrays];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
    //Display button for tha sake of testing what's going on
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Pressed" message:@"Button pressed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
}


- (void)doPOST {
    //Prepering for POST request
    int timestamp = [[NSDate date] timeIntervalSince1970];
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    self.sender = [standardUserDefaults stringForKey:@"userid"];
    
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://cloudshare.se/webservice/inbox_addmessage.php"]];
    
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
    
    NSLog(@"POST data %@", [NSString stringWithFormat:@"conversationId=%@&timeStamp=%d&senderId=%@&recipientId=%@&text=%@&",
                            conversationid,
                            timestamp,
                            self.sender,
                            receiver,
                            self.newmessage]);
    
}

-(void)cleanArray
{
    //clean up array
    
    NSMutableArray *arra = [[NSMutableArray alloc] init];
    NSString *str = [[NSString alloc]init];
    
    for(str in self.messages){
        str = [str stringByReplacingOccurrencesOfString:@"&nbsp;"
                                             withString:@""];
        
        
        [arra addObject:str];
    }
    [self.messages removeAllObjects];
    [self.messages addObjectsFromArray:arra ];
    
    
}

@end