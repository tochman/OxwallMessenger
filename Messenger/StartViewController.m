//
//  StartViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-27.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "StartViewController.h"
#import "UIButton+NUI.h"
#import "NSString+FontAwesome.h"

@interface StartViewController ()

@end

@implementation StartViewController

@synthesize settingsButton, aboutButton, versionLabel;



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
    self.title = @"Oxwall Messenger";
    settingsButton.nuiClass = @"none";
    aboutButton.nuiClass = @"none";
    versionLabel.text = @"Beta 0.6";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)start:(id)sender {
    [self performSegueWithIdentifier:@"start" sender:self];
    
}

- (IBAction)showAbout:(id)sender {
    [self performSegueWithIdentifier:@"About" sender:sender];
}

- (IBAction)showSettings:(id)sender {
    [self performSegueWithIdentifier:@"settings" sender:sender];
}

@end
