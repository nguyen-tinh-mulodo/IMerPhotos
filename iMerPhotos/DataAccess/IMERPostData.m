//
//  IMERPostData.m
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 12/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERPostData.h"

@implementation IMERPostData
@synthesize nameParam,valueParam;

-(id)initWithNewData:(NSString*)name AndValue:(NSString*)value{
    nameParam = name;
    valueParam = value;
    return self;
}

@end
