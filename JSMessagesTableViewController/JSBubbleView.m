//
//  JSBubbleView.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSBubbleView.h"
#import "JSMessageInputView.h"
#import "NSString+JSMessagesView.h"

CGFloat const kJSAvatarSize = 50.0f;

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kMarginLeft 16
#define kMarginRight 16
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 25.0f

@interface JSBubbleView()

- (void)setup;
- (UIImage *)bubbleImage;
- (CGRect)bubbleFrame;

+ (CGSize)textSizeForText:(NSString *)txt;
+ (CGSize)bubbleSizeForContentSize:(CGSize)contentSize;

@property (retain, nonatomic) UIImage* bubbleImage;
@property (retain, nonatomic) UIImage* selectedBubbleImage;
@end

@implementation JSBubbleView

@synthesize type;
@synthesize style;
@synthesize text;
@synthesize selectedToShowCopyMenu;
@synthesize textColor;
@synthesize contentView;

#pragma mark - Setup
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)rect
         bubbleType:(JSBubbleMessageType)bubleType
        bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
{
    self = [super initWithFrame:rect];
    if(self) {
        [self setup];
        self.type = bubleType;
        self.style = bubbleStyle;
    }
    return self;
}

- (void)dealloc
{
    self.text = nil;
}

#pragma mark - Setters
- (void)setType:(JSBubbleMessageType)newType
{
    type = newType;
    [self setNeedsDisplay];
}

- (void)setStyle:(JSBubbleMessageStyle)newStyle
{
    style = newStyle;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)newText
{
    self.contentView = nil;
    text = newText;    
    [self setNeedsDisplay];
}

- (void)setSelectedToShowCopyMenu:(BOOL)isSelected
{
    selectedToShowCopyMenu = isSelected;
    [self setNeedsDisplay];
}

- (void)setBubbleImage:(UIImage*)bubbleImage
andSelectedBubbleImage:(UIImage*)selectedBubbleImage {
    self.bubbleImage = bubbleImage;
    self.selectedBubbleImage = selectedBubbleImage;
    [self setNeedsDisplay];
}

- (void)setContentView:(UIView *)newView
{
    if(self.contentView)
        [self.contentView removeFromSuperview];
    
    text = nil;
    contentView = newView;
    
    [self addSubview:newView];
    [self setNeedsDisplay];
}
    
- (void)setTextColor:(UIColor *)newColor
{
    textColor = newColor;
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (CGRect)bubbleFrame
{
    CGSize bubbleSize;
    CGSize contentSize;
    
    if(self.contentView)
    {
        contentSize = [JSBubbleView sizeForContentView:self.contentView];
    }
    else
        contentSize = [JSBubbleView textSizeForText:self.text];

    bubbleSize = [JSBubbleView bubbleSizeForContentSize:contentSize];
    
    return CGRectMake((self.type == JSBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width : 0.0f),
                      kMarginTop,
                      bubbleSize.width,
                      bubbleSize.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if(self.contentView) {
        UIImage *image = [self correctBubbleImage];
        CGRect bubbleFrame = [self bubbleFrame];
        
        CGFloat startX = (self.type == JSBubbleMessageTypeOutgoing ? bubbleFrame.origin.x : 0.0f);
            
        self.contentView.frame = CGRectMake(startX + image.capInsets.left + kMarginLeft,
                                            image.capInsets.top + kPaddingTop,
                                            self.contentView.frame.size.width,
                                            self.contentView.frame.size.height);
    }
    
}

- (UIImage*)correctBubbleImage
{
    UIImage* image = nil;
    if(self.selectedToShowCopyMenu)
        image = self.selectedBubbleImage;
    else
        image = self.bubbleImage;
    
    return image;
}

- (void)drawRect:(CGRect)frame
{
    [super drawRect:frame];
    
	UIImage *image = [self correctBubbleImage];
    CGRect bubbleFrame = [self bubbleFrame];
	[image drawInRect:bubbleFrame];
    
    if(!self.contentView) {	
        CGSize textSize = [JSBubbleView textSizeForText:self.text];
        
        CGFloat textX = image.leftCapWidth - 3.0f + (self.type == JSBubbleMessageTypeOutgoing ? bubbleFrame.origin.x : 0.0f);
        
        CGRect textFrame = CGRectMake(textX,
                                      kPaddingTop + kMarginTop,
                                      textSize.width,
                                      textSize.height);
        
        [self.textColor set];
        [self.text drawInRect:textFrame
                     withFont:[JSBubbleView font]
                lineBreakMode:NSLineBreakByWordWrapping
                    alignment:NSTextAlignmentLeft];
    }
}

#pragma mark - Bubble view

+ (UIFont *)font
{
    return [UIFont systemFontOfSize:16.0f];
}

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width * 0.75f;
    CGFloat height = MAX([JSBubbleView numberOfLinesForMessage:txt],
                         [txt numberOfLines]) * [JSMessageInputView textViewLineHeight];
    
    return [txt sizeWithFont:[JSBubbleView font]
           constrainedToSize:CGSizeMake(width - kJSAvatarSize, height + kJSAvatarSize)
               lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)bubbleSizeForContentSize:(CGSize)contentSize
{
	return CGSizeMake(contentSize.width + kBubblePaddingRight,
                      contentSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)cellHeightForText:(NSString *)txt
{
    CGSize textSize = [JSBubbleView textSizeForText:txt];
    return [JSBubbleView bubbleSizeForContentSize:textSize].height + kMarginTop + kMarginBottom;
}

+ (CGSize)sizeForContentView:(UIView*)view
{
    CGSize size =  view.bounds.size;
    size.width = size.width + kMarginLeft + kMarginRight;
    size.height = size.height + kMarginTop + kMarginBottom;
    return size;
}

+ (CGFloat)cellHeightForView:(UIView*)view
{
    return [JSBubbleView bubbleSizeForContentSize:[JSBubbleView sizeForContentView:view]].height + kMarginTop + kMarginBottom;
}

+ (int)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (int)numberOfLinesForMessage:(NSString *)txt
{
    return (txt.length / [JSBubbleView maxCharactersPerLine]) + 1;
}

@end