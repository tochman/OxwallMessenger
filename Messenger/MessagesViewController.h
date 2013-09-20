//
//  MessagesViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSMessagesViewController.h"
#import "ODRefreshControl.h"

@interface MessagesViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>  {
    ODRefreshControl * refreshControlll;
    NSTimer *timer1,*timer2,*timer3;
    UIImage *incommingImg;
}



@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) NSMutableArray *timestamps;
@property (strong, nonatomic) NSDictionary *json;

+ (void)conversationIdMthd : (NSString *)conversationIdStr;
+ (void)getIdMthd : (NSString *)getIdStr;
- (UIImage *)avatarImageForIncomingMessage;

@end
