//
//  ImageModel.h
//  Oxwall Messenger
//
//  Created by India on 20/09/13.
//  Copyright (c) 2013 Underplot ltd. All rights reserved.
//

#import "JSONModel.h"

@protocol ImageModel  @end

@interface ImageModel : JSONModel

@property (strong, nonatomic) NSString *small_avatar;

@end
