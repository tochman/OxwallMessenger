//
//  OxwallFeed.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//


#import "JSONModel.h"
#import "UsersModel.h"

@interface OxwallFeed : JSONModel

@property (strong, nonatomic) NSArray<UsersModel>* posts;

@end


