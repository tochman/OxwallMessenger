//
//    UICheckbox.h
//
//    Author:    Brayden Wilmoth
//    Co-Author: Jordan Perry
//    Edited:    07/17/2012
//
//    Copyright (c) 2012 Brayden Wilmoth.  All rights reserved.
//    http://www.github.com/brayden/
//    http://www.github.com/jordanperry/
//

#import <UIKit/UIKit.h>

@interface UICheckbox : UIControl

-(void)setChecked:(BOOL)boolValue;
-(void)setDisabled:(BOOL)boolValue;
-(void)setText:(NSString *)stringValue;

@property(nonatomic, assign)BOOL checked;
@property(nonatomic, assign)BOOL disabled;
@property(nonatomic, strong)NSString *text;

@end
