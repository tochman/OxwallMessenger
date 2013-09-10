//
//  LoginModel.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol LoginModel @end

@interface LoginModel : JSONModel

//@property (strong, nonatomic) NSArray<LoginModel>* posts;

@property (strong, nonatomic) NSString* success;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* user;
@property (strong, nonatomic) NSString* realname;
@property (strong, nonatomic) NSString* member_since;
@property (strong, nonatomic) NSString* sex;
@property (strong, nonatomic) NSString* birth;
@property (strong, nonatomic) NSNumber* age;
@property (strong, nonatomic) NSURL* big_avatar;
@property (strong, nonatomic) NSURL* small_avatar;
@property (strong, nonatomic) NSString* profiletext;

//@property (strong, nonatomic) NSString* password;

@end
