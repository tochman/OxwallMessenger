//
//  DUViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "DUViewController.h"
#import "Constants.h"
#import "HUD.h"
#import "JSONModelLib.h"
#import "ConversationFeed.h"
#import "ConversationsModel.h"
#import "MessagesViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "SDSegmentedControl.h"
#import "Lockbox.h"
#import "SWTableViewCell.h"
#import "OMHTTPCalls.h"

@interface DUViewController (){
    ConversationFeed* _feed;
    ConversationsModel* conversation;
    
    }
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DUViewController
static dispatch_once_t onceToken;
@synthesize username;
@synthesize realname;
@synthesize sex;
@synthesize membersince;
@synthesize presentation;
@synthesize avatarURL;
@synthesize convAvatar;
//@synthesize tableView = _tableView;
@synthesize profileView = _profileView;
@synthesize userid;
@synthesize senderAvatar;
@synthesize segmentedControl, selectedSegmentLabel;
@synthesize ConversationButton  = conversatinbutton;
@synthesize notif;
@synthesize currentConversationId;

static NSString * kMessageCountChanged = @"NULL";
NSString *SITE;
NSString *BASE_URL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self fireUpdate];

    }
    return self;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    //Setting up TableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.allowsSelection = NO; // We essentially implement our own selection
    //self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0); // Makes the horizontal row seperator stretch the entire length of the table view
    
    //Setting the Site Information
    SITE = [Constants getSiteName];
    BASE_URL = [Constants getBaseUrl];
    
    //Get everything together
    [self loadStandardUser];
    [self setLProfileLabels];
    
    //Segmented control
    segmentedControl.selectedSegmentIndex = 1;
    [self.tableView setHidden:NO];
    conversatinbutton.hidden = NO;
    [self.profileView setHidden:YES];
    
    // Title
    self.title = realname;
    [self.navigationItem setHidesBackButton:YES];
    
    //Some settings
    userid = [Lockbox stringForKey:@"userid"];
    [self updateSelectedSegmentLabel];
    
    
    //Profile view
    [self.profileView addSubview:membersinceLabel];
    [self.profileView addSubview:presentationTextview];
    [self.profileView addSubview:sexLabel];
    
    
    
    //Notifications
    notif = [[UILocalNotification alloc]init];
    notif.alertBody = @"There is a new message for you";
    notif.alertAction = @"View";
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    
    currentConversationId = [[NSString alloc]init];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    //Set the identifier
    [self fireUpdate];
    timer1 = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                            selector: @selector(fireUpdate) userInfo: nil repeats: YES];
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated  {
    [super viewWillDisappear:animated];
    
    
    [timer1 invalidate];
}

- (void)updateSelectedSegmentLabel
{
    self.selectedSegmentLabel.font = [UIFont boldSystemFontOfSize:self.selectedSegmentLabel.font.pointSize];
    self.selectedSegmentLabel.text = [NSString stringWithFormat:@"%d", self.segmentedControl.selectedSegmentIndex];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void)
                   {
                       self.selectedSegmentLabel.font = [UIFont systemFontOfSize:self.selectedSegmentLabel.font.pointSize];
                   });
}


-(void)fireUpdate  {
    //[HUD showUIBlockingIndicatorWithText:@"Getting Conversations"];
    NSString *callURL = [NSString stringWithFormat:@"%@/inbox_conversations.php?user=%@", BASE_URL, userid];
    
    //fetch the feed
    _feed = [[ConversationFeed alloc] initFromURLWithString:callURL
                                                 completion:^(JSONModel *model, JSONModelError *err) {
                                                     
                                                     //hide the loader view
                                                     //[HUD hideUIBlockingIndicator];
    
                                                     [HUD hideUIBlockingIndicator];
                                                     [self.tableView reloadData];
                                                     
                                               }];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadStandardUser {
    
    username = [Lockbox stringForKey:@"username"];
    realname = [Lockbox stringForKey:@"realname"];
    sex = [Lockbox stringForKey:@"sex"];
    membersince = [Lockbox stringForKey:@"membersince"];
    presentation = [Lockbox stringForKey:@"presentation"];
    avatarURL = [NSURL URLWithString:[Lockbox stringForKey:@"avatarURL"]];
}

-(void)setLProfileLabels
{
    
    usernameLabel.text = realname;
    sexLabel.text = sex;
    membersinceLabel.text = membersince;
    avatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:avatarURL]];
    avatar.layer.cornerRadius = 5.0;
    avatar.layer.masksToBounds = YES;
    avatar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    avatar.layer.borderWidth = 1.0;
    presentationTextview.text = presentation;
    
}


- (IBAction)logOut:(UIBarButtonItem *)sender {
    [HUD showUIBlockingIndicatorWithText:@"Logging out..."];
    [Lockbox setString:@"" forKey:@"userid"];
    [Lockbox setString:@"" forKey:@"username"];
    [Lockbox setString:@"" forKey:@"realname"];
    [Lockbox setString:@"" forKey:@"sex"];
    [Lockbox setString:@"" forKey:@"membersince"];
    [Lockbox setString:@"" forKey:@"presentation"];
    [Lockbox setString:@"" forKey:@"avatarURL"];
    
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
    conversation = _feed.conversations[indexPath.row];
    static NSString *identifier = @"ConversationCell";
    SWTableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons addUtilityButtonWithColor:
        [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 icon:[UIImage imageNamed:@"cross.png"]];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:identifier
                                  containingTableView:_tableView // Used for row height and selection
                                   leftUtilityButtons:nil
                                  rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    // Here we use the new provided setImageWithURL: method to load the web image
    
    [cell.imageView setImageWithURL:conversation.avatar
                   placeholderImage:[UIImage imageNamed:@"missingAvatar"]];
    
    cell.textLabel.text = conversation.title;
    if ([conversation.startedbyid isEqualToString:[Lockbox stringForKey:@"userid"]]){
        if ([conversation.conversationflag intValue] == 2 | [conversation.conversationflag intValue] == 0) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - unread", conversation.startedby];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_dot_small.png"]];
            [imageView setFrame:CGRectMake(45,30,7,7)]; //refactor this for better display in iOS6.0
            [cell.contentView addSubview:imageView];
            dispatch_once (&onceToken, ^{
            notif.applicationIconBadgeNumber = notif.applicationIconBadgeNumber +1;
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            });
            
        } else {
            
            cell.detailTextLabel.text = conversation.startedby;
        }
    } else if ([conversation.startedbyid isEqualToString:[Lockbox stringForKey:@"userid"]] == NO) {
        
        if ([conversation.conversationflag intValue] == 1 | [conversation.conversationflag intValue] == 0){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - unread", conversation.startedby];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_dot_small.png"]];
            [imageView setFrame:CGRectMake(45,30,7,7)]; //refactor this for better display in iOS6.0
            [cell.contentView addSubview:imageView];
            dispatch_once (&onceToken, ^{
            notif.applicationIconBadgeNumber = notif.applicationIconBadgeNumber +1;
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            });
        }
        cell.detailTextLabel.text = conversation.startedby;
        cell.imageView.layer.cornerRadius = 5.0;
        cell.imageView.layer.masksToBounds = YES;
        cell.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.imageView.layer.borderWidth = 0.5;
    }
    
    return cell;
    
}

- (void) setCurrentConversationId: (NSString*)passedConversationId {


    currentConversationId = passedConversationId;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"scroll view did begin dragging");
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Set background color of cell here if you don't want white
}

#pragma mark - SWTableViewDelegate



- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [HUD showUIBlockingIndicatorWithText:@"Deleting conversation"];
            NSLog(@"Delete button was pressed");
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            conversation = _feed.conversations[indexPath.row];
            currentConversationId = conversation.conversationid;
            [OMHTTPCalls deleteConversation:[Lockbox stringForKey:@"userid"] conversation:currentConversationId];
            [self fireUpdate];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        }
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    conversation = _feed.conversations[indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Here we are passing values to MessageVC. Can this be done in a better way?
    [MessagesViewController conversationIdMthd:conversation.conversationid];
    [MessagesViewController receiverIdMthd:conversation.sentto];
    [MessagesViewController senderAvatarMthd:conversation.avatar];
    [self performSegueWithIdentifier:@"getmessage" sender:self];
    
}

- (IBAction)newConversation: (UIButton *) sender{
    [self performSegueWithIdentifier:@"newConversation" sender:self];
    
}

- (IBAction)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)segmentDidChange:(id)sender
{
    if(segmentedControl.selectedSegmentIndex == 0){
		NSLog(@"1");
        [self.tableView setHidden:YES];
        conversatinbutton.hidden = YES;
        [self.profileView setHidden:NO];
	}
	if(segmentedControl.selectedSegmentIndex == 1){
        NSLog(@"2");
        [self.tableView setHidden:NO];
        conversatinbutton.hidden = NO;
        [self.profileView setHidden:YES];
	}
}


@end
