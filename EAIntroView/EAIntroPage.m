//
//  EAIntroPage.m
//  EAIntroView
//
//  Copyright (c) 2013 Evgeny Aleksandrov.
//

#import "EAIntroPage.h"

@implementation EAIntroPage

+ (EAIntroPage *)page {
    EAIntroPage *newPage = [[EAIntroPage alloc] init];
    newPage.imgPositionY    = 50.0f;
    newPage.titlePositionY  = 240.0f;
    newPage.descPositionY   = 180.0f;
    newPage.title = @"";
    newPage.titleFont = [UIFont fontWithName:@"AppleGothic" size:18.0];
    newPage.titleColor = [UIColor grayColor];
    newPage.desc = @"";
    newPage.descFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
    newPage.descColor = [UIColor grayColor];
    
    return newPage;
}

+ (EAIntroPage *)pageWithCustomView:(UIView *)customV {
    EAIntroPage *newPage = [[EAIntroPage alloc] init];
    newPage.customView = customV;
    
    return newPage;
}

@end
