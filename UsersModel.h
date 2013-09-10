//
//  UsersModel.h
//  OxwallMessenger
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "LocationModel.h"

@protocol UsersModel @end

@interface UsersModel : JSONModel

@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* realname;
@property (strong, nonatomic) NSString* email;

//@property (strong, nonatomic) LocationModel* location;

@end
