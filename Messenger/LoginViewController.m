//
//  LoginViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "JSONModelLib.h"
#import "LoginModel.h"
#import "HUD.h"

@interface LoginViewController () {
    LoginModel* _feed;
}


@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    // Title
    self.title = @"Oxwall Messenger";
}

-(void)viewDidAppear:(BOOL)animated
{
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Getting User"];
    
    //fetch the feed
    _feed = [[LoginModel alloc] initFromURLWithString:@"http://cloudshare.se/webservice/login.php?username=xxx&password=xxx"
                                           completion:^(JSONModel *model, JSONModelError *err) {
                                               
                                               //hide the loader view
                                               [HUD hideUIBlockingIndicator];
                                               
                                               //json fetched
                                               [self login];
                                               NSLog(@"user: %@", _feed.realname);
                                               
                                              // [self.tableView reloadData];
                                               
                                           }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)login
{
if ([_feed.success isEqual: @"1"])
{
  NSLog(@"Loginmessege: %@", _feed.message);
} else {
  NSLog(@"Fail");
}
    return;
}

@end
