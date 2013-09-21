//
//  ConversationsModel.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol ConversationsModel @end

@interface ConversationsModel : JSONModel


@property (strong, nonatomic) NSString* conversationid;
@property (strong, nonatomic) NSString* startedbyid;
@property (strong, nonatomic) NSString* startedby;
@property (strong, nonatomic) NSString* sentto;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSURL* messages;
@property (strong, nonatomic) NSURL* avatar;





@end
