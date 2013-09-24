//
//  DetailViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface NewConversationViewController : UIViewController


@property (nonatomic, strong) IBOutlet UILabel *userLabel;
@property (nonatomic, strong) NSString *userName;


- (IBAction)cancel;
@end
