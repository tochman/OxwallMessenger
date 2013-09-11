//
//  DUViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-11.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "DUViewController.h"

@interface DUViewController ()

@end

@implementation DUViewController
@synthesize username;
@synthesize realname;
@synthesize sex;
@synthesize membersince;
@synthesize presentation;
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
    [self loadStandardUser];
    [self setLProfileLabels];
    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadStandardUser {
    NSUserDefaults *standardUserDefaults  = [NSUserDefaults standardUserDefaults];
    
    username = [standardUserDefaults stringForKey:@"username"];
    realname = [standardUserDefaults stringForKey:@"realname"];
    sex = [standardUserDefaults stringForKey:@"sex"];
    membersince = [standardUserDefaults stringForKey:@"membersince"];
    presentation = [standardUserDefaults stringForKey:@"presentation"];
    
}

-(void)setLProfileLabels
{

    usernameLabel.text = realname;
    sexLabel.text = sex;
    membersinceLabel.text = membersince;
    presentationTextview.text = presentation;

}

@end
