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
#import "Lockbox.h"
#import "UIButton+NUI.h"

@interface LoginViewController () {
    LoginModel* _feed;
}


@end

@implementation LoginViewController
@synthesize checkbox = _checkbox;
@synthesize settingsButton, aboutButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Register to receive an update when the app goes into the backround
        //It will call our "appEnteredBackground method
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(appEnteredBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Title
    self.title = @"Login";
    settingsButton.nuiClass = @"none";
    aboutButton.nuiClass = @"none";
    self.checkbox.nuiClass = @"none";
    self.checkbox.checked = FALSE;
    self.checkbox.disabled = FALSE;
    self.checkbox.text = @"Remember me";
    self.checkbox.hidden = TRUE;
    [self.navigationItem setHidesBackButton:YES];
    //usernameField.placeholder = @"Username or e-mail";
    passwordLabel.text =[NSString stringWithFormat:@"Your username at %@", SITE ];
    
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    //if ([[standardUserDefaults stringForKey:@"username"] length] != 0) {
    
    if ([[standardUserDefaults stringForKey:@"username"]  isEqual: @""]){
    //if ([[[standardUserDefaults stringForKey:@"username"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] != 0){
    usernameField.placeholder = @"Username or e-mail";
        
    } else {
    usernameField.text = [standardUserDefaults stringForKey:@"username"];
    }
 
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
    [passwordField becomeFirstResponder];

}
    return;
}

- (void)saveDefaultUserCredentials {
    //Set user defaults to NSUserDefaults when in development
    
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
    
    // Set user defaults to Lockbox for later use when in in production
    [Lockbox setString:_feed.userid forKey:@"userid"];
    [Lockbox setString:_feed.user forKey:@"username"];
    [Lockbox setString:_feed.realname forKey:@"realname"];
    [Lockbox setString:_feed.sex forKey:@"sex"];
    [Lockbox setString:_feed.member_since forKey:@"membersince"];
    [Lockbox setString:[_feed.small_avatar absoluteString] forKey:@"avatarURL"];
    
    
  //To use that avatar url:
    // avatarURL = [NSURL URLWithString:[Lockbox stringForKey:@"avatarURL"]];
  



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

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}


- (void)appEnteredBackground{
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}






-(IBAction)testCheckbox:(id)sender {
    NSLog(@"checked = %@", (self.checkbox.checked) ? @"YES" : @"NO");
 
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    
    if (textField == usernameField) {
		[textField resignFirstResponder];
		[passwordField becomeFirstResponder];
	}
	
	else if (textField == passwordField) {
		[textField resignFirstResponder];
	}

    [self checkCredentials];
    return YES;
}
- (IBAction)showAbout:(id)sender {
    [self performSegueWithIdentifier:@"About" sender:sender];
}

- (IBAction)showSettings:(id)sender {
    [self performSegueWithIdentifier:@"settings" sender:sender];
}

@end
