//
//  NewsfeedCell.h
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-11-05.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsfeedCell : UITableViewCell
{
    bool configured;
}

@property (nonatomic,strong) IBOutlet UIView *cellContentView;

- (void) initTimelineCell;
- (bool) configured;

@end
