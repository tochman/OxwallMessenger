//
//  MessageModel.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(void)validate:(NSError**)err
{
    NSLog(@"Message from %@", self.sentby);
}


@end
