//
//  SettingsViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-10-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import "Lockbox.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize siteName, siteURL, connectionStatusLabel;
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
	self.title = @"Settings";
    self.siteName.text = SITE;
    //self.siteURL.text = BASE_URL;
    self.siteURL.placeholder = @"http://domain.com";
    self.connectionStatusLabel.hidden = TRUE;
   // self.navigationItem.hidesBackButton = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)checkConnection:(id)sender {
    [self.view endEditing:YES];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/webservice/", siteURL.text]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    [request setHTTPMethod:@"HEAD"];
  
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection)
    {
        NSLog(@"NSURLConnection connection==true");
        NSHTTPURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSLog(@"responseData: %i", response.statusCode);
        NSLog(@"url: %@", response.URL);
        if ([[response.URL absoluteString] isEqualToString: [NSString stringWithFormat:@"%@/webservice/", siteURL.text]]) {
            self.connectionStatusLabel.hidden = FALSE;
            self.connectionStatusLabel.text = @"Connected";
           // BASE_URL = [response.URL absoluteString];
        }
        else {
            self.connectionStatusLabel.hidden = FALSE;
            self.connectionStatusLabel.text = @"Server not configured";
            NSLog(@"responseData: %@", response.URL);
        }

    }
    else
    {
        self.connectionStatusLabel.hidden = FALSE;
        self.connectionStatusLabel.text = @"Could not connect to server";
        NSLog(@"NSURLConnection connection==false");
    };
}
@end
