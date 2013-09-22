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
#import "ImageFeed.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>

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
@synthesize convAvatar;
@synthesize tableView = _tableView;
@synthesize userid;
@synthesize senderAvatar;

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
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //Set the identifier
    [self fireUpdate];
    timer1 = [NSTimer scheduledTimerWithTimeInterval: 30.0 target: self
                                            selector: @selector(fireUpdate) userInfo: nil repeats: YES];
    
}

-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    [timer1 invalidate];
}

-(void)fireUpdate  {
    [HUD showUIBlockingIndicatorWithText:@"Getting Conversations"];
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_conversations.php?user=%@", userid];
    
    //fetch the feed
    _feed = [[ConversationFeed alloc] initFromURLWithString:callURL
                                                 completion:^(JSONModel *model, JSONModelError *err) {
                                                     
                                                     //hide the loader view
                                                     [HUD hideUIBlockingIndicator];
                                                     
                                                     //json fetched
                                                     
                                                     //NSLog(@"Loaded %@", _feed.conversations);
                                                     NSLog(@"Fired!!!!");
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
    //presentationTextview.text = presentation;
    avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarURL]];
    
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
    [standardUserDefaults synchronize];
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
    senderAvatar = nil;
    ConversationsModel* conversation = _feed.conversations[indexPath.row];
    static NSString *identifier = @"ConversationCell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image
    [cell.imageView setImageWithURL:conversation.avatar
                   placeholderImage:[UIImage imageNamed:@"missingAvatar"]];

    senderAvatar = cell.imageView.image;
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
    [MessagesViewController receiverIdMthd:conversation.sentto];
    [MessagesViewController getSenderAvatarIdMthd:senderAvatar];
    NSLog(@"senderAvatar DUVC%@", senderAvatar);
    [self performSegueWithIdentifier:@"getmessage" sender:self];
    
}




@end
