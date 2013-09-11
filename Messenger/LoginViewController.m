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
   // credentialsDictionary = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:_feed.password, nil] forKeys:[NSArray arrayWithObjects:_feed.user, nil]];
    
    
    // Title
    self.title = @"Oxwall Messenger";
}

-(void)viewDidAppear:(BOOL)animated
{
    //show loader view
    
    
 
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
    [self saveDefaultUserCredentials ];
    [self performSegueWithIdentifier:@"userprofile" sender:self];
} else {
  NSLog(@"Fail");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invelid credentials" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];

}
    return;
}

- (void)saveDefaultUserCredentials {
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];


    


    [[NSUserDefaults standardUserDefaults]
     setObject:_feed.user forKey:@"username"];
    [[NSUserDefaults standardUserDefaults]
     setObject:_feed.realname forKey:@"realname"];
    [[NSUserDefaults standardUserDefaults]
     setObject:_feed.sex forKey:@"sex"];
    [[NSUserDefaults standardUserDefaults]
     setObject:_feed.member_since forKey:@"membersince"];
    [[NSUserDefaults standardUserDefaults]
     setObject:_feed.profiletext forKey:@"presentation"];
    
    [standardUserDefaults synchronize];
    
    

  



}


- (IBAction)checkCredentials {
     [HUD showUIBlockingIndicatorWithText:@"Getting User"];
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/login.php?username=%@&password=%@", usernameField.text, passwordField.text];

   
    _feed = [[LoginModel alloc] initFromURLWithString:callURL
                                                    completion:^(JSONModel *model, JSONModelError *err) {
                                                        
                                                        //hide the loader view
                                                        [HUD hideUIBlockingIndicator];
                                                      //  NSLog(@"call: %@", callURL);
                                                        NSLog(@"call: %@", _feed);
                                                        //json fetched
                                                        [self login];
                                                       
                                                        NSLog(@"user: %@", _feed.realname);
                                                        
                                                        // [self.tableView reloadData];
                                                        
                                                    }];
    
    
}
@end
