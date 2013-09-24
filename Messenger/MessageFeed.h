//
//  MessageFeed.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "MessageModel.h"

@interface MessageFeed : JSONModel

@property (strong, nonatomic) NSMutableArray<MessageModel>* messagesinconversation;


@end
