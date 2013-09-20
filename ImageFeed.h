//
//  ImageFeed.h
//  Oxwall Messenger
//
//  Created by India on 20/09/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"
#import "ImageModel.h"

@interface ImageFeed : JSONModel

@property (strong, nonatomic) NSArray<ImageModel>* images;

@end
