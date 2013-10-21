//
//  Constants.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-24.
//  Copyright (c) 2013 NoceboDesign. All rights reserved.
//

#import "Constants.h"
#import "Lockbox.h"

@implementation Constants
static NSString *SITE = @"Demosite";
static NSString *BASE_URL = @"http://scalo.se/webservice";

//NSString * const BASE_URL = @"http://cloudshare.se/webservice";
+(void)setConstantValues:(NSString*)site setBaseURL:(NSString *)baseURL{
    SITE = site;
    BASE_URL = baseURL;
}

+(NSString*)getBaseUrl{
    return BASE_URL;
}

+(NSString*)getSiteName{
    return SITE;
}

@end
