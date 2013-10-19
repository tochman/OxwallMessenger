//
//  LoginViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCDFormInputAccessoryView.h"

@class UICheckbox;
@interface LoginViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
    IBOutlet UILabel *passwordLabel;

    NSDictionary *credentialsDictionary;
}
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property(nonatomic, weak)IBOutlet UICheckbox *checkbox;
@property (nonatomic, strong) XCDFormInputAccessoryView *inputAccessoryView;
- (IBAction)checkCredentials;
- (IBAction)testCheckbox:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
-(IBAction)showAbout:(id)sender;
- (IBAction)showSettings:(id)sender;
- (void) animateTextField: (UITextField*) textField up: (BOOL) up;
@end
