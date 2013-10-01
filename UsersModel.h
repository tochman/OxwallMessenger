//
//  UsersModel.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//


#import "JSONModel.h"

@protocol UsersModel @end

@interface UsersModel : JSONModel

@property (strong, nonatomic) NSString* id;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* realname;
@property (strong, nonatomic) NSString* email;
@property (strong, nonatomic) NSURL* avatar;








@end
