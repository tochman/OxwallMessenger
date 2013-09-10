//
//  DetailViewController.h
//  JSON_HelloWorld
//
//  Created by Marin Todorov on 13/01/2013.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property(weak, nonatomic) NSObject* dataModel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
