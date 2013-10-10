//
//  StartViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-27.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIButton *aboutButton;

- (IBAction)start:(id)sender;
-(IBAction)showAbout:(id)sender;
- (IBAction)showSettings:(id)sender;

@end
