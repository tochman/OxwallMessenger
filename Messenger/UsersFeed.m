//
//  UsersFeed.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-24.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "UsersFeed.h"


@implementation UsersFeed
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"posts.realname":@"riktigtnamn",
                                                       @"avatar": @"avatar",
                                                       }];
}

@end
