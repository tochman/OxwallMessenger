//
//  DUViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "DUViewController.h"
#import "HUD.h"
#import "JSONModelLib.h"
#import "ConversationFeed.h"
#import "MessagesViewController.h"

@interface DUViewController (){
    ConversationFeed* _feed;
}


@end

@implementation DUViewController

@synthesize username;
@synthesize realname;
@synthesize sex;
@synthesize membersince;
@synthesize presentation;
@synthesize avatarURL;
@synthesize tableView = _tableView;
@synthesize userid;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self loadStandardUser];
    [self setLProfileLabels];
    // Title
    self.title = realname;
    [self.navigationItem setHidesBackButton:YES];
    
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    userid = [standardUserDefaults stringForKey:@"userid"];
    // Title
    self.title = @"My conversations";
    
}

-(void)viewDidAppear:(BOOL)animated
{
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Getting Conversations"];
    //Set the identifier
    
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_conversations.php?user=%@", userid];
    
    //fetch the feed
    _feed = [[ConversationFeed alloc] initFromURLWithString:callURL
                                                 completion:^(JSONModel *model, JSONModelError *err) {
                                                     
                                                     //hide the loader view
                                                     [HUD hideUIBlockingIndicator];
                                                     
                                                     //json fetched
                                                     
                                                     NSLog(@"Loaded %@", _feed.conversations);
                                                     NSLog(@"Userid %@", userid);
                                                     [self.tableView reloadData];
                                                     
                                                 }];
    
    timer1 = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                            selector: @selector(fireUpdate) userInfo: nil repeats: YES];
}

-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [timer1 invalidate];
}

-(void)fireUpdate  {
    
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_conversations.php?user=%@", userid];
    
    //fetch the feed
    _feed = [[ConversationFeed alloc] initFromURLWithString:callURL
                                                 completion:^(JSONModel *model, JSONModelError *err) {
                                                     
                                                     //hide the loader view
                                                     [HUD hideUIBlockingIndicator];
                                                     
                                                     //json fetched
                                                     
                                                     NSLog(@"Loaded %@", _feed.conversations);
                                                     NSLog(@"Userid %@", userid);
                                                     [self.tableView reloadData];
                                                     
                                                 }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadStandardUser {
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    
    username = [standardUserDefaults stringForKey:@"username"];
    realname = [standardUserDefaults stringForKey:@"realname"];
    sex = [standardUserDefaults stringForKey:@"sex"];
    membersince = [standardUserDefaults stringForKey:@"membersince"];
    presentation = [standardUserDefaults stringForKey:@"presentation"];
    avatarURL = [standardUserDefaults URLForKey:@"avatarURL"];
    
}

-(void)setLProfileLabels
{
    
    usernameLabel.text = realname;
    sexLabel.text = sex;
    membersinceLabel.text = membersince;
    presentationTextview.text = presentation;
    avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarURL]];
    
}

- (IBAction)checkConversations:(id)sender {
    [self performSegueWithIdentifier:@"conversations" sender:self];
}

- (IBAction)logOut:(UIBarButtonItem *)sender {
    [HUD showUIBlockingIndicatorWithText:@"Logging out..."];
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    
    [standardUserDefaults setObject:@"" forKey:@"username"];
    [standardUserDefaults setObject:@"" forKey:@"realname"];
    [standardUserDefaults setObject:@"" forKey:@"sex"];
    [standardUserDefaults setObject:@"" forKey:@"membersince"];
    [standardUserDefaults setObject:@"" forKey:@"presentation"];
    [standardUserDefaults setObject:@"" forKey:@"avatarURL"];
    [NSThread sleepForTimeInterval:0.5];
    [HUD hideUIBlockingIndicator];
    [self performSegueWithIdentifier:@"start" sender:self];
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feed.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationsModel* conversation = _feed.conversations[indexPath.row];
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    cell.textLabel.text = conversation.title;
    cell.detailTextLabel.text = conversation.startedby;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationsModel* conversation = _feed.conversations[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MessagesViewController conversationIdMthd:conversation.conversationid];
    [self performSegueWithIdentifier:@"getmessage" sender:self];
    
}



@end
