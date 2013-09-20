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
#import "Model.h"
#import <QuartzCore/QuartzCore.h>

@interface DUViewController (){
    ConversationFeed* _feed;
    ImageFeed * _imgFeed;
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
    [self fireUpdate];
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

//////////////////////////////////////getting avatar image urls ///////////////////////////////

-(void) getImgUrls:(NSString *)getId
{
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/user.php?user=%@", getId];
    
    //fetch the feed
    _imgFeed = [[ImageFeed alloc] initFromURLWithString:callURL
                                             completion:^(JSONModel *model, JSONModelError *err) {
                                                 //json fetched
                                                 
                                                 NSLog(@"Loaded %@", _imgFeed.images);
                                                 [self.tableView reloadData];
                                                 
                                             }];
    
    
    //    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/user.php?user=%@", getId];
    //      NSLog(@"%@",getId);
    //      Model *model_Obj = [[Model alloc]init];
    //      [model_Obj loadUrl:callURL connec_identific:nil];
    //      model_Obj.delegate = self;
}

-(void)didReceiveResponse:(id)response connection_tag:(int)tagvalue_idnt;
{
    NSLog(@"%@",response);
}

//////////////////////////////////////////////////////////////////////////////////////////////

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
    NSURL *url;
    ConversationsModel* conversation = _feed.conversations[indexPath.row];
    ImageModel* iModel = _imgFeed.images[indexPath.row];
    if ([userid isEqualToString:conversation.startedbyid]) {
        //[self getImgUrls:conversation.sentto];
        //        //        NSLog(@"sentto : %@ - %@",conversation.sentto,conversation.title);
        url=[NSURL URLWithString:@"http://seconddate.se//ow_userfiles//plugins//base//avatars//avatar_1_1364328533.jpg"];
    }
    if ([userid isEqualToString: conversation.sentto ]) {
        //[self getImgUrls:conversation.startedbyid];
        url=[NSURL URLWithString:@"http://seconddate.se//ow_userfiles//plugins//base//avatars//avatar_10343414_1372318667.jpg"];
        //        //        NSLog(@"sentbyid :%@ - %@",conversation.startedbyid,conversation.title);
    }
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ConversationCell" forIndexPath:indexPath];
    cell.textLabel.text = conversation.title;
    cell.detailTextLabel.text = conversation.startedby;
    NSURLRequest *req=[NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
        cell.imageView.layer.cornerRadius = 10.0;
        cell.imageView.layer.borderColor = [UIColor blackColor].CGColor;
        cell.imageView.layer.borderWidth = 1.2;
        cell.imageView.clipsToBounds = YES;
        cell.imageView.image=[UIImage imageWithData:data];
    }];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationsModel* conversation = _feed.conversations[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MessagesViewController conversationIdMthd:conversation.conversationid];
    if ([userid isEqualToString:conversation.startedbyid]) {
        NSLog(@"sentto : %@ - %@",conversation.sentto,conversation.title);
        [MessagesViewController getIdMthd:conversation.sentto];
    }
    if ([userid isEqualToString: conversation.sentto ]) {
        NSLog(@"sentbyid :%@ - %@",conversation.startedbyid,conversation.title);
        [MessagesViewController getIdMthd:conversation.startedbyid];
    }
    [self performSegueWithIdentifier:@"getmessage" sender:self];
    
}



@end
