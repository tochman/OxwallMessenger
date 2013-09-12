//
//  MessageFeed.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessageFeed.h"

@implementation MessageFeed

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
            @"messagesinconversation.messageid":@"messageid",
            @"messagesinconversation.messagecreated":@"messagecreated",
            @"messagesinconversation.sentbyIDy":@"sentbyID",
            @"messagesinconversation.sentby":@"sentby",
            @"messagesinconversation.title":@"title",
            @"messagesinconversation.message":@"message",
            }];
}

@end
