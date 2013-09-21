//
//  LoginViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UICheckbox;
@interface LoginViewController : UIViewController {
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;

    NSDictionary *credentialsDictionary;
}
@property(nonatomic, weak)IBOutlet UICheckbox *checkbox;
- (IBAction)checkCredentials;
- (IBAction)testCheckbox:(id)sender;
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end
