//
//  MessageCountObserver.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-10-16.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessageCountObserver.h"

@implementation MessageCountObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"keyPath %@", keyPath);
    if (context == @"test")
    {
        id newValue = [object valueForKeyPath:keyPath];
        NSLog(@"The keyPath %@ changed to %@", keyPath, newValue);
    }
    else if ([keyPath rangeOfString:@"Key"].location != NSNotFound)
    {
        id newValue = change[NSKeyValueChangeNewKey];
        id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
//        if (newValue == oldValue){
//        
//            NSLog(@"The keyPath %@ changed from %@ to %@", keyPath, oldValue, newValue);
//        }
        NSLog(@"The keyPath %@ changed from %@ to %@", keyPath, oldValue, newValue);
    }
    else if ([keyPath isEqual:@"messagecount"])
    {
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        id oldValue = change[NSKeyValueChangeOldKey];
        NSLog(@"The keyPath %@ changed from %@ to %@", keyPath, oldValue, newValue);
    }
}

@end
