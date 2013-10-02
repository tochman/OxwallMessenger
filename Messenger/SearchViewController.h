//
//  SearchViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "JSONModelArray.h"
@interface SearchViewController : UITableViewController
@property JSONModelArray *users;
@property (strong, nonatomic) NSArray* usersArr;
@property (strong, nonatomic) NSDictionary *json;
@property (strong, nonatomic) NSString *subject;
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSString *receiver;
@property (strong, nonatomic) NSString *conversationId;

-(IBAction)cancel;

@end
