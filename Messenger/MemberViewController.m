//
//  ConversationsViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MemberViewController.h"
#import "Constants.h"
#import "JSONModelLib.h"
#import "ConversationFeed.h"
#import "HUD.h"
#import "Lockbox.h"

@interface MemberViewController () {
    ConversationFeed* _feed;
}

@end

@implementation MemberViewController
NSString *SITE;
NSString *BASE_URL;

@synthesize userid;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userid = @"1";
    //userid = [Lockbox stringForKey:@"userid"];
    
    //Setting the site information
    SITE = [Constants getSiteName];
    BASE_URL = [Constants getBaseUrl];
    
    // Title
    self.title = @"My conversations";
}

-(void)viewDidAppear:(BOOL)animated
{
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Getting Conversations"];
    //Set the identifier

    NSString *callURL = [NSString stringWithFormat:@"%@/inbox_conversations.php?user=%@", BASE_URL, userid];

    //fetch the feed
    _feed = [[ConversationFeed alloc] initFromURLWithString:callURL
                                           completion:^(JSONModel *model, JSONModelError *err) {
                                               
                                               //hide the loader view
                                               [HUD hideUIBlockingIndicator];
                                               
                                               //json fetched
                                               
                                               NSLog(@"Loaded %@", _feed.conversations);
                                               NSLog(@"Userid %@", userid);
                                               //[self.tableView reloadData];
                                               
                                           }];
}




#pragma mark - Table view data source

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    cell.textLabel.text = conversation.title;
    cell.detailTextLabel.text = conversation.startedby;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

[self performSegueWithIdentifier:@"getmessage" sender:self];
    
}

@end
