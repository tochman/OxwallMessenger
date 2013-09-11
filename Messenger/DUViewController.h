//
//  DUViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DUViewController : UIViewController {


    IBOutlet UILabel *usernameLabel;

    IBOutlet UILabel *sexLabel;

    IBOutlet UILabel *membersinceLabel;

    IBOutlet UITextView *presentationTextview;
    
    IBOutlet UIImageView *avatar;
}
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) NSString *realname;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *membersince;
@property (strong, nonatomic) NSString *presentation;
@property (strong, nonatomic) NSURL *avatarURL;


- (IBAction)checkConversations:(id)sender;
- (IBAction)logOut:(UIBarButtonItem *)sender;

@end
