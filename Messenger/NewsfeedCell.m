//
//  NewsfeedCell.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-11-05.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "NewsfeedCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsfeedCell
@synthesize cellContentView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        cellContentView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 440)];
        cellContentView.backgroundColor = [UIColor whiteColor];
        
        
        UIView *profilePic = [[UIView alloc] initWithFrame:CGRectMake(9, 9, 30, 30)];
        profilePic.backgroundColor = [UIColor darkGrayColor];
        
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 9, 222, 18)];
        usernameLabel.font = [UIFont systemFontOfSize:14.0];
        usernameLabel.text = @"Username";
        
        UILabel *timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, 222, 17)];
        timestampLabel.font = [UIFont systemFontOfSize:12.0];
        timestampLabel.text = @"3 hours ago";
        timestampLabel.textColor = [UIColor lightGrayColor];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 50, 283, 41)];
        statusLabel.font = [UIFont systemFontOfSize:15.0];
        statusLabel.text = @"Status..status..status..status..status..status..status..status..status..status..status..status..status..status..status..";
        statusLabel.numberOfLines = 2;
        statusLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        UILabel *likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(9, 413, 32, 21)];
        likeLabel.font = [UIFont systemFontOfSize:13.0];
        likeLabel.text = @"Like";
        
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(113, 413, 74, 21)];
        commentLabel.font = [UIFont systemFontOfSize:13.0];
        commentLabel.text = @"Comment";
        
        UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(246, 413, 46, 21)];
        shareLabel.font = [UIFont systemFontOfSize:13.0];
        shareLabel.text = @"Share";
        
        [self addSubview:cellContentView];
        [cellContentView addSubview:profilePic];
        [cellContentView addSubview:usernameLabel];
        [cellContentView addSubview:timestampLabel];
        [cellContentView addSubview:statusLabel];
        [cellContentView addSubview:likeLabel];
        [cellContentView addSubview:commentLabel];
        [cellContentView addSubview:shareLabel];
        
        
    }
    return self;
}

- (void) initTimelineCell
{
    cellContentView.layer.cornerRadius = 2;
    cellContentView.layer.masksToBounds = NO;
    
    
    configured = YES;
}

- (bool) configured
{
    return configured;
}

@end
