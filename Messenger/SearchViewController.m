//
//  MasterViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SearchViewController.h"
#import "MessagesViewController.h"
#import "NewConversationViewController.h"
#import "DUViewController.h"

#import "JSONModelLib.h"
#import "UsersFeed.h"
//#import "OxwallFeed.h"
#import "HUD.h"

@interface SearchViewController () {
    UsersFeed* _feed;
    UsersModel* usersModel;
    NSArray* usersArr;
    
}

@end

@implementation SearchViewController
    
    UsersFeed * _feed;
    NSArray *searchResults;
    NSArray *searchResultsAvatar;
    NSMutableArray *searchResultId;
    // NSArray* usersArr;
    NSDictionary* json;
    UINavigationController *navController;
int row;

@synthesize usersArr, json, sender, receiver, subject, conversationId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    usersArr = [[NSArray alloc]init];
    json = [[NSDictionary alloc]init];
    
    
    // Title
    self.title = @"New message";
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    sender = [standardUserDefaults stringForKey:@"userid"];
    
    [self getFeed:@""];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    usersArr = nil;
    json = nil;
    
    if ([navController.viewControllers indexOfObject:self]==NSNotFound) {
        // back button was pressed.  We know this is true because self is no longer
        // in the navigation stack.
        NSLog(@"About to crash");
    }
    
    
    
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];
    
    searchResults = [[usersArr valueForKey:@"realname"] filteredArrayUsingPredicate:resultPredicate];
    //We can´t implement this this way.
    //searchResultsAvatar = [usersArr valueForKey:@"avatar"];
    
    
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    [newArray addObjectsFromArray:[usersArr valueForKey:@"realname"]];
    
    NSIndexSet *indexes = [newArray indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [resultPredicate evaluateWithObject:obj];
    }];
    
    NSUInteger index=[indexes firstIndex];
    searchResultId = [[NSMutableArray alloc] init];
    if (index != NSNotFound) {
        [searchResultId addObject:[NSString stringWithFormat:@"%d",index]];
    }
    
    NSLog(@"Search Result is %d",index);
    while(index != NSNotFound)
    {
        index=[indexes indexGreaterThanIndex: index];
        if(index != NSNotFound){
            [searchResultId addObject:[NSString stringWithFormat:@"%d",index]];
            NSLog(@"Search Result is %d",index);
        }
        
    }
    
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)getFeed:(NSString*)term {
    
    NSLog(@"Searching for '%@' ...", term);
    //URL escape the term
    
    
    //make HTTP call
    NSString* searchCall = [NSString stringWithFormat:@"%@/members.php?search=%@", BASE_URL, term];
    
    [JSONHTTPClient getJSONFromURLWithString: searchCall
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      
                                      //got JSON back
                                      NSLog(@"Got JSON from web: %@", json);
                                      
                                      if (err) {
                                          [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:[err localizedDescription]
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Close"
                                                            otherButtonTitles: nil] show];
                                          return;
                                      }
                                      
                                      //initialize the models
                                      usersArr = [UsersModel arrayOfModelsFromDictionaries:
                                                  json[@"posts"]
                                                  ];
                                      
                                      if (usersArr) NSLog(@"Loaded successfully models");
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResultId count];
        
    } else {
        
        
        return usersArr.count;
        
    }
    
    
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SearchCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    
    // Here we use the new provided setImageWithURL: method to load the web image
  
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        int row = [[searchResultId objectAtIndex:indexPath.row] integerValue];
        cell.textLabel.text = [[usersArr objectAtIndex:row] valueForKey:@"realname"];
        [cell.imageView setImageWithURL:[[usersArr objectAtIndex:row] valueForKey:@"avatar" ]
                       placeholderImage:[UIImage imageNamed:@"missingAvatar"]];
        
    } else {
        cell.textLabel.text = [[usersArr objectAtIndex:indexPath.row] valueForKey:@"realname"];
        [cell.imageView setImageWithURL:[[usersArr objectAtIndex:indexPath.row] valueForKey:@"avatar"]
                       placeholderImage:[UIImage imageNamed:@"missingAvatar"]];
        
    }
    

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        int row = [[searchResultId objectAtIndex:indexPath.row] integerValue];
        receiver = [[usersArr valueForKey:@"id"] objectAtIndex:row];
        
    } else {
        receiver = [[usersArr valueForKey:@"id"] objectAtIndex:indexPath.row];
        
    }
  
    
    NSLog(@"recievier vid val av rad: %@", receiver);
    [self showMessage:self];

}

- (void)showMessage:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter subject"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Continue", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
    
}

- (void)alertView:(UIAlertView *)message clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Clicked button index 0");
        // Add the action here
    } else {
        NSLog(@"Clicked button index other than 0");
        // Add another action here
        NSLog(@"subject: %@", subject);
        [self doPOST];
        //[self performSegueWithIdentifier:@"setUserDetail" sender:self];
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if( [inputText length] >= 3 )
    {
        subject = [[alertView textFieldAtIndex:0] text];
        return YES;
    }
    else
    {
        
        return NO;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setUserDetail"]) {
        NewConversationViewController *destViewController = segue.destinationViewController;
        
        NSIndexPath *indexPath = nil;
        
        if ([self.searchDisplayController isActive]) {
            indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
            destViewController.userName = [searchResults objectAtIndex:indexPath.row];
            
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
            destViewController.userName = [[usersArr valueForKey:@"realname"] objectAtIndex:indexPath.row];
            [self doPOST];
           
        }
    } else if ([segue.identifier isEqualToString:@"getBack"]) {
        [self performSegueWithIdentifier: @"getBack" sender: self];
    }
    
}

- (void)doPOST {
    //Prepering for POST request
    int timestamp = [[NSDate date] timeIntervalSince1970];

    
    
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:[NSString stringWithFormat:@"%@/inbox_addconversation.php", BASE_URL]]];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *postString =[NSString stringWithFormat:@"timeStamp=%d&senderId=%@&recipientId=%@&subject=%@&",
                           timestamp,
                           sender,
                           receiver,
                           subject];
    
    [request setValue:[NSString
                       stringWithFormat:@"%d", [postString length]]
   forHTTPHeaderField:@"Content-length"];
    
    [request setHTTPBody:[postString
                          dataUsingEncoding:NSUTF8StringEncoding]];
    
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSError *errorReturned = nil;
    NSURLResponse *theResponse =[[NSURLResponse alloc]init];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&errorReturned];
    
    if (errorReturned) {
        // Handle error.
    }
    else
    {
        NSError *jsonParsingError = nil;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:&jsonParsingError];
        NSLog(@"resultat? %@", jsonArray);
        conversationId = [jsonArray valueForKey:@"conversationId"];
    }
    
    [MessagesViewController conversationIdMthd:conversationId];
    [MessagesViewController receiverIdMthd:receiver];
    //[MessagesViewController senderAvatarMthd:conversation.avatar];

    [self performSegueWithIdentifier:@"message" sender:self];
    
 
    
}


-(IBAction)cancel {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
