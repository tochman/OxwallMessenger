//
//  AppDelegate.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//


#import "AppDelegate.h"
#import <NewRelicAgent/NewRelicAgent.h>
#import "TestFlight.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:@"AAd40e0cf67623484b41b889aa53df62ba66828e9f"];
    [TestFlight takeOff:@"67454926-2384-4f01-832e-f0fc275f363d"];
    //[NUIAppearance init];
    
    // Add the view controller's view to the window and display.
    
    
    application.applicationIconBadgeNumber = application.applicationIconBadgeNumber = 0;
    
    // Handle launching from a notification
    UILocalNotification *notif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notif) {
        NSLog(@"Recieved Notification %@",notif);
    }
    
    return YES;
}
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    NSLog(@"Recieved Notification %@",notif);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

-(void)applicationDidEnterBackground:(UIApplication*)application{
    
    UILocalNotification*notification =[[UILocalNotification alloc] init];
    notification.fireDate =[[NSDate date] dateByAddingTimeInterval:60*60*24];
    notification.alertBody =@"OxwallMessenger -  Don't forget to check your messages :(";
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
