//
//  MessageModel.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol MessageModel @end

@interface MessageModel : JSONModel

@property (strong, nonatomic) NSString* messageid;
@property (strong, nonatomic) NSString* messagecreated;
@property (strong, nonatomic) NSString* sentbyID;
@property (strong, nonatomic) NSString* sentby;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* message;

@end
