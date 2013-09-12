//
//  MessagesViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-09-12.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "MessagesViewController.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "JSONModelLib.h"
#import "MessageFeed.h"
#import "HUD.h"

@interface MessagesViewController ()
{
    IBOutlet UIBubbleTableView *bubbleTable;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    
    NSMutableArray *bubbleData;
    
    MessageFeed* _feed;
}

@end

@implementation MessagesViewController
@synthesize message;
@synthesize messages;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadStandardUser];
    //[self setLProfileLabels];
    // Title
    self.title = @"Conversation";
    [self.navigationItem setHidesBackButton:YES];
    
    
    //Standard kod UI Bubble - test
    
    
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Lorem ipsum sjkdnvjfnv sfvsfv sdvsfvsfvs fvsfsrf wqrwrfwervwerfw evwervwerv  rfrkwee we w ew  ttrtwerwerwer er erwerwe erwerews.asdnm.asdfnm.asd.nmafsd" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
    photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:heyBubble, photoBubble, replyBubble, nil];
    bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
    [bubbleTable reloadData];
    
    // Keyboard events
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    
    //Slut på standard kod UIBubble
    
    [self loadfeed];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

#pragma mark - Keyboard events

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y -= kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height -= kbSize.height;
        bubbleTable.frame = frame;
    }];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.2f animations:^{
        
        CGRect frame = textInputView.frame;
        frame.origin.y += kbSize.height;
        textInputView.frame = frame;
        
        frame = bubbleTable.frame;
        frame.size.height += kbSize.height;
        bubbleTable.frame = frame;
    }];
}

#pragma mark - Actions

- (IBAction)sayPressed:(id)sender
{
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:textField.text date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    
    textField.text = @"";
    [textField resignFirstResponder];
}

- (void)loadfeed {
    [HUD showUIBlockingIndicatorWithText:@"Sending data"];
    NSString *conversationid = @"55";
    NSString *callURL = [NSString stringWithFormat:@"http://cloudshare.se/webservice/inbox_messages.php?conversation=%@", conversationid];
    
    [JSONHTTPClient getJSONFromURLWithString: callURL
                                  completion:^(NSDictionary *json, JSONModelError *err) {
                                      //got JSON back
                                      //NSLog(@"Got JSON from web: %@", json);
                                      messages = json;
                                      [self createArray];
                                      
                                  }];
    



}
- (void)createArray

{

    
    //NSLog(@"Messages %@", [messages allKeys]);
    
    NSArray* keys = [messages allKeys];
    
    int count = [keys count] ;
    for (int i=0; i < count; i++) {
    for(NSString* key in keys) {
        if ([key isEqualToString:@"messagesinconversation"]) {
            NSArray* arr = [messages objectForKey:key];
            NSString *sentby = [[arr valueForKey:@"sentby"] objectAtIndex:i];

            NSLog (@"%@", sentby);
         
        }
    }
    }

    
    
    }

@end
