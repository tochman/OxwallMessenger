//
//  NewsfeedTableViewController.m
//  Oxwall Messenger
//
//  Created by Thomas Ochman on 2013-11-03.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "NewsfeedTableViewController.h"
#import "NewsfeedCell.h"

@interface NewsfeedTableViewController ()


@end

@implementation NewsfeedTableViewController

    static NSString *CellIdentifier = @"timelineCell";


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[NewsfeedCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
     NSLog(@"NewsfeedTableViewController.h!!!! %@", CellIdentifier);
    
    //[self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    //[self.tableView setSeparatorColor:[UIColor clearColor]];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 450;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    if (![cell configured])
//    {
//        [cell initTimelineCell];
//    }
    NSLog(@"hallå!!!!");
    cell.detailTextLabel.text = @"Test";
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
