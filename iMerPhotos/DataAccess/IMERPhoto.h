//
//  IMERPhoto.h
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 14/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMERPhoto : NSObject{
    NSString* photoId;
    NSString* comment;
    NSString* photoPath;
    NSString* upload_date;
    NSString* userUploadId;
    NSString* totalLike;
    NSString* username;
    NSString* isLiked;
    NSData* imageData;
    NSString* thumnailPath;
}

@property (nonatomic,retain) NSString *photoId;
@property (nonatomic,retain) NSString *comment;
@property (nonatomic,retain) NSString *photoPath;
@property (nonatomic,retain) NSString *upload_date;
@property (nonatomic,retain) NSString *userUploadId;
@property (nonatomic,retain) NSString *totalLike;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *isLiked;
@property (nonatomic,retain) NSData *imageData;
@property (nonatomic,retain) NSString *thumnailPath;

@end
