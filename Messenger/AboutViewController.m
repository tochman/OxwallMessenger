//
//  AboutViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-10-09.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.navigationItem.hidesBackButton = YES;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
