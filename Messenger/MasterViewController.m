//
//  MasterViewController.m
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

#import "JSONModelLib.h"
#import "OxwallFeed.h"
#import "HUD.h"

@interface MasterViewController () {
    OxwallFeed* _feed;
}
@end

@implementation MasterViewController

-(void)viewDidAppear:(BOOL)animated
{
    //show loader view
    [HUD showUIBlockingIndicatorWithText:@"Getting Users"];
    
    //fetch the feed
    _feed = [[OxwallFeed alloc] initFromURLWithString:@"http://cloudshare.se/webservice/members.php?search=Tho"
                                         completion:^(JSONModel *model, JSONModelError *err) {
                                             
                                             //hide the loader view
                                             [HUD hideUIBlockingIndicator];
                                             
                                             //json fetched
                                             NSLog(@"posts: %@", _feed.posts);
                                             
                                             [self.tableView reloadData];
                                             
                                         }];
}

#pragma mark - table methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _feed.posts.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UsersModel* loan = _feed.posts[indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ from %@",
                           loan.username, loan.realname
                           ];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"profile" sender:self];
    
    // This is not used
    /*
    UsersModel* loan = _feed.posts[indexPath.row];
    
    
     NSString* message = [NSString stringWithFormat:@"User: %@ has a Realname of: %@ and his email is: %@",
                         loan.username, loan.realname, loan.email
                         ];*/
    

    
    
    
    
    //[HUD showAlertWithTitle:@"User details" text:message];
}



@end
