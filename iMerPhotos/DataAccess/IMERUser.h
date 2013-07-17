//
//  IMERUser.h
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 12/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMERUser : NSObject{
    NSString* userId;
    NSString* username;
    NSString* password;
    NSString* email;
    NSString* avatar;
    NSString* token;
    NSString* createdDate;
}
@property (nonatomic,retain) NSString *userId;
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *email;
@property (nonatomic,retain) NSString *avatar;
@property (nonatomic,retain) NSString *token;
@property (nonatomic,retain) NSString *createdDate;

@end
