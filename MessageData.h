//
//  MessageData.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-17.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageData : NSObject


@property (strong, nonatomic) NSDictionary *JSONmessages;

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, strong) NSMutableArray *gMesseges;

-(void)fetchFeed;
-(void)updateUIWithDictionary:(NSDictionary*)json;
- (NSMutableArray*)messeges;

@end
