//
//  SettingsViewController.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-10-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *siteName;
@property (strong, nonatomic) IBOutlet UITextField *siteURL;
@property (strong, nonatomic) IBOutlet UILabel *connectionStatusLabel;
- (IBAction)checkConnection:(id)sender;
-(IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *sitePicker;
@end
