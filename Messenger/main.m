//
//  main.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-10.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "AppDelegate.h"



/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)






int main(int argc, char *argv[])
{
    @autoreleasepool {
        
        
        if (SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(@"6.1")) {
            [NUISettings init];
            [NUISettings setGlobalExclusions:@[@"EAIntroView", @"EAIntroPage", @"SWTableViewCell", @"SDSegmentedControl", @"JSMessagesViewController"]];
            
        }
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
//            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//            { //Use standard UI
//            } else {
//            [NUISettings init];
//            [NUISettings setGlobalExclusions:@[@"EAIntroView", @"EAIntroPage"]];
//            }
            [NUISettings init];
            [NUISettings setGlobalExclusions:@[@"EAIntroView", @"EAIntroPage", @"SWTableViewCell", @"SDSegmentedControl", @"JSMessagesViewController"]];        }

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
