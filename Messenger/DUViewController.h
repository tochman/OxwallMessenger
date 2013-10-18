//
//  DUViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCountObserver.h"


@interface DUViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    
    IBOutlet UILabel *usernameLabel;
    
    IBOutlet UILabel *sexLabel;
    
    IBOutlet UILabel *membersinceLabel;
    
    IBOutlet UITextView *presentationTextview;
    
    IBOutlet UIImageView *avatar;
    
    IBOutlet UITableView *tableView;
    
    NSTimer *timer1;
    
    NSMutableArray *avatarImageUrls;
    NSURL *finalImgUrl;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *selectedSegmentLabel;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *realname;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *membersince;
@property (strong, nonatomic) NSString *presentation;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) IBOutlet UIImageView *convAvatar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *profileView;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) UIImage *senderAvatar;
@property (strong, nonatomic)  IBOutlet UIButton * ConversationButton;

//Observer and Notifications
@property (nonatomic, strong) MessageCountObserver * messageObserver;
@property (nonatomic, strong) NSMutableArray *messageCountsArr;
@property (nonatomic, strong) NSMutableArray *messageCountsArrCopy;
@property (nonatomic, strong) NSMutableDictionary *messageCountsDic;
@property (nonatomic, strong) NSMutableDictionary *messageCountsDicCopy;
@property (nonatomic, strong) UILocalNotification *localNotif;
- (void)addMessageCount:(NSNumber *)mc; // Not used?

- (IBAction)segmentDidChange:(id)sender;
- (IBAction)logOut:(UIBarButtonItem *)sender;
- (IBAction)newConversation: (UIButton *) sender;
- (IBAction)cancel;

@end
