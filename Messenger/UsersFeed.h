//
//  UsersFeed.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-24.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "UsersModel.h"
@interface UsersFeed : JSONModel
@property (strong, nonatomic) NSArray<UsersModel>* posts;

//@property (strong, nonatomic) NSArray* realname;
//@property (strong, nonatomic) NSArray* avatar;

@end
