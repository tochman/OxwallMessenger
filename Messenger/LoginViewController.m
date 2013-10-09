//
//  LoginViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "LoginViewController.h"
#import "Constants.h"
#import "JSONModelLib.h"
#import "LoginModel.h"
#import "HUD.h"
#import "UICheckbox.h"

@interface LoginViewController () {
    LoginModel* _feed;
}


@end

@implementation LoginViewController
@synthesize checkbox = _checkbox;

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

    // Title
    self.title = @"Oxwall Messenger";
    self.checkbox.checked = FALSE;
    self.checkbox.disabled = FALSE;
    self.checkbox.text = @"Remember me";
    
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    usernameField.text = [standardUserDefaults stringForKey:@"username"];
 
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
    [HUD showUIBlockingIndicatorWithText:@"Logging in..."];
    NSLog(@"Loginmessege: %@", _feed.message);
    [self saveDefaultUserCredentials ];
    [HUD hideUIBlockingIndicator];
    [self performSegueWithIdentifier:@"userprofile" sender:self];
} else {
  NSLog(@"Fail");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Invalid credentials" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
    usernameField.text = @"";
    passwordField.text = @"";
    [usernameField becomeFirstResponder];

}
    return;
}

- (void)saveDefaultUserCredentials {
    //Lets save all gatherd user data in NSUserDefaults for later use
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];


    
    [[NSUserDefaults standardUserDefaults]
     setObject:_feed.userid forKey:@"userid"];
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
    [[NSUserDefaults standardUserDefaults]
     setURL:_feed.small_avatar forKey:@"avatarURL"];
    
    [standardUserDefaults synchronize];
    
    

  



}


- (IBAction)checkCredentials {
    
    
    if ([passwordField.text isEqual: @""] || [usernameField.text isEqual:@""])
        
    {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must provide both a username/email and a password" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        
        
        
        
    } else {
    
    
     [HUD showUIBlockingIndicatorWithText:@"Sending data"];
    NSString *callURL = [NSString stringWithFormat:@"%@/login.php?username=%@&password=%@", BASE_URL, usernameField.text, passwordField.text];

   
    _feed = [[LoginModel alloc] initFromURLWithString:callURL
     completion:^(JSONModel *model, JSONModelError *err)
        {
                                                        
          //hide the loader view
           [HUD hideUIBlockingIndicator];
           NSLog(@"call: %@", _feed);
          //json fetched
            if (err) {
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:[err localizedDescription]
                                           delegate:nil
                                  cancelButtonTitle:@"Close"
                                  otherButtonTitles: nil] show];
                return;
            }
    [self login];
    
       NSLog(@"user: %@", _feed.realname);
   // [self.tableView reloadData];
            
    }];
    }
    
}
-(IBAction)testCheckbox:(id)sender {
    NSLog(@"checked = %@", (self.checkbox.checked) ? @"YES" : @"NO");
 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self checkCredentials];
    return YES;
}
- (IBAction)showAbout:(id)sender {
    [self performSegueWithIdentifier:@"About" sender:sender];
}

@end
