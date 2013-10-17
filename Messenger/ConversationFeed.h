//
//  ConversationFeed.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "ConversationsModel.h"

@interface ConversationFeed : JSONModel


@property (strong, nonatomic) NSArray<ConversationsModel>* conversations;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSNumber* conversationcount;


@end
