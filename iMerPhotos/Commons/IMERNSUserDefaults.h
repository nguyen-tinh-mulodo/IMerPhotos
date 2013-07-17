//
//  IMERNSUserDefaults.h
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 13/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMERNSUserDefaults : NSObject

// Save information when user login successfully
+(void)saveInfoUser:(NSString*)user_id token:(NSString*)token email:(NSString*)email username:(NSString*)username avatar:(NSString*)avatar created_date:(NSString*)created_date;
+(void)saveUsername:(NSString*)username;
// Get info user name
+(NSString*)getUserName;
// Get info created date
+(NSString*)getCreatedDate;
// Get info token
+(NSString*)getToken;
// Get info user id
+(NSString*)getUserId;
// Get Avatar
+(NSString*)getAvatar;
// Get Email
+(NSString*)getEmail;

// Remove information when user log out
+(void)removeInfoUser;
+(void)saveAvatar:(NSString*)urlAvatar;

@end
