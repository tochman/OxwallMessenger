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
#import "JSONModelLib.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize siteName, siteURL, connectionStatusLabel,sitePicker;

NSArray *availableSites;
NSString *SITE;
NSString *BASE_URL;


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
    
    //Setting the site Information
    SITE = [Constants getSiteName];
    BASE_URL = [Constants getBaseUrl];
    
    self.siteName.text = SITE;
    
    self.siteURL.text = [BASE_URL stringByReplacingOccurrencesOfString:@"/webservice" withString:@""];
    self.siteURL.placeholder = @"http://domain.com";
    self.connectionStatusLabel.hidden = TRUE;
    self.navigationItem.hidesBackButton = YES;
    
    [self loadAvailableSites];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadAvailableSites{
    //make HTTP call
    NSString* searchCall = [NSString stringWithFormat:@"%@/om_sites.php", BASE_URL];
    
    
    [JSONHTTPClient getJSONFromURLWithString: searchCall
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      
                                      if (err) {
                                          [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                      message:[err localizedDescription]
                                                                     delegate:nil
                                                            cancelButtonTitle:@"Close"
                                                            otherButtonTitles: nil] show];
                                          return;
                                      }
                                      
                                      availableSites = [NSArray arrayWithArray:json[@"sites"]];
                                      NSLog(@"Results %@",[[availableSites objectAtIndex:0] valueForKey:@"site"]);
                                      
                                      self.sitePicker.dataSource = self;
                                      self.sitePicker.delegate = self;
                                      [self.sitePicker reloadAllComponents];
                                }];
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



- (IBAction)close:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (availableSites!=nil) {
        return [availableSites count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (availableSites!=nil) {
        
        return [[availableSites objectAtIndex:row] valueForKey:@"site"];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    self.siteName.text = [[availableSites objectAtIndex:row] valueForKey:@"site"];
    self.siteURL.text = [[availableSites objectAtIndex:row] valueForKey:@"url"];
    
    //Set
    [Constants setConstantValues:[[availableSites objectAtIndex:row] valueForKey:@"site"] setBaseURL:[[availableSites objectAtIndex:row] valueForKey:@"url"]];
    
}

@end
