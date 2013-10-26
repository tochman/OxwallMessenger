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
    newPage.titlePositionY  = 290.0f;
    newPage.descPositionY   = 220.0f;
    newPage.title = @"";
    newPage.titleFont = [UIFont fontWithName:@"AppleGothic" size:20.0];
    newPage.titleColor = [UIColor whiteColor];
    newPage.desc = @"";
    newPage.descFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0];
    newPage.descColor = [UIColor whiteColor];
    
    return newPage;
}

+ (EAIntroPage *)pageWithCustomView:(UIView *)customV {
    EAIntroPage *newPage = [[EAIntroPage alloc] init];
    newPage.customView = customV;
    
    return newPage;
}

@end
