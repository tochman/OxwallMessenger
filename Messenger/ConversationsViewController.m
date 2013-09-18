//
//  ConversationsViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "ConversationsViewController.h"

#import "JSONModelLib.h"
#import "ConversationFeed.h"
#import "HUD.h"

@interface ConversationsViewController () {
    ConversationFeed* _feed;
}

@end

@implementation ConversationsViewController
@synthesize userid;



- (void)viewDidLoad
{
    [super viewDidLoad];
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
[self.tableView deselectRowAtIndexPath:indexPath animated:YES];

[self performSegueWithIdentifier:@"getmessage" sender:self];
    
}

@end
