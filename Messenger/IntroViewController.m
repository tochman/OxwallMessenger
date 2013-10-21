//
//  IntroViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-10-14.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "IntroViewController.h"

@interface IntroViewController ()

@end

@implementation IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    // all settings are basic, pages with custom packgrounds, title image on each page
    [self showIntroWithCrossDissolve];
 
   
    // separate pages initialization
    //[self showIntroWithSeparatePagesInit];
    NSLog(@"Intro callback");
}

- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
   
    page1.title = @"BETA 0.4.2 UI";
    page1.desc = @"Current user is filtred from SearchView. Marketing - App leaves a notification on website whe user logges in. Issues with notification badge due to 'addObserver' and KVO features. ";
    page1.bgImage = [UIImage imageNamed:@"OM_background"];
    page1.titleImage = [UIImage imageNamed:@"OM114x114"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"Issues - will be fixed in BETA 0.5";
    page2.desc = @"Notification badge. TimeStamp in MessageViev. Site newsfeed instead of User profile? We' see... The rest will come in future betas... ";
    page2.bgImage = [UIImage imageNamed:@"OM_background"];
    page2.titleImage = [UIImage imageNamed:@"OM114x114"];;
    

    
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2]];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
}

- (void)showIntroWithSeparatePagesInit {
    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds];
    
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.0];
    
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
    page1.bgImage = [UIImage imageNamed:@"OM_background"];
    page1.titleImage = [UIImage imageNamed:@"OM114x114"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
    page2.bgImage = [UIImage imageNamed:@"OM_background"];
    page2.titleImage = [UIImage imageNamed:@"OM114x114"];
    
    [intro setPages:@[page1,page2]];
}

- (void)introDidFinish {
    UINavigationController *duview =[self.storyboard instantiateViewControllerWithIdentifier:@"mainNav"];
    
    // [duview setModalTransitionStyle:UIModalTrans];
    [self presentViewController:duview animated:YES completion:nil];
    NSLog(@"Intro callback");
}
@end

