//
//  MessagesViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "JSONModel.h"
#import "JSMessagesViewController.h"

@interface MessagesViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) NSDictionary *JSONmessages;
   
@property (nonatomic, strong) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;

@end
