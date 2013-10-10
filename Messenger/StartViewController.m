//
//  StartViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-27.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "StartViewController.h"
#import "UIButton+NUI.h"

@interface StartViewController ()

@end

@implementation StartViewController

@synthesize settingsButton, aboutButton;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    self.settingsButton.nuiClass = @"SmallButton";
    self.aboutButton.nuiClass = @"SmallButton";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Oxwall Messenger";
    
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
