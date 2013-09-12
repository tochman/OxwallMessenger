//
//  MessagesViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "JSONModel.h"

@interface MessagesViewController : UIViewController <UIBubbleTableViewDataSource>

@property (strong, nonatomic) NSDictionary *messages;
@property (strong, nonatomic) NSArray *message;

@end
