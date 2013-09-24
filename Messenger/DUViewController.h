//
//  DUViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DUViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    
    IBOutlet UILabel *usernameLabel;
    
    IBOutlet UILabel *sexLabel;
    
    IBOutlet UILabel *membersinceLabel;
    
    //IBOutlet UITextView *presentationTextview;
    
    IBOutlet UIImageView *avatar;
    
    IBOutlet UITableView *tableView;
    
    NSTimer *timer1;
    
    NSMutableArray *avatarImageUrls;
    NSURL *finalImgUrl;
}

@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *realname;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *membersince;
@property (strong, nonatomic) NSString *presentation;
@property (strong, nonatomic) NSURL *avatarURL;
@property (strong, nonatomic) IBOutlet UIImageView *convAvatar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *userid;
@property (strong, nonatomic) UIImage *senderAvatar;



- (IBAction)logOut:(UIBarButtonItem *)sender;
- (IBAction)newConversation;

@end
