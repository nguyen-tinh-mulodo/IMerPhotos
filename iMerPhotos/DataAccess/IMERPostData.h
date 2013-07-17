//
//  IMERPostData.h
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 12/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMERPostData : NSObject{
    NSString* nameParam;
    NSString* valueParam;
}

@property (nonatomic,retain) NSString *nameParam;
@property (nonatomic,retain) NSString *valueParam;

-(id)initWithNewData:(NSString*)name AndValue:(NSString*)value;

@end
