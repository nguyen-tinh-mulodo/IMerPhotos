//
//  IMERNSUserDefaults.m
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 13/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERNSUserDefaults.h"
#import "Constants.h"

@implementation IMERNSUserDefaults

// Save information when user login successully
+(void)saveInfoUser:(NSString*)user_id token:(NSString*)token email:(NSString*)email username:(NSString*)username avatar:(NSString*)avatar created_date:(NSString*)created_date{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:TOKEN];
    [defaults setObject:user_id forKey:USER_ID];
    [defaults setObject:username forKey:USERNAME];
    [defaults setObject:email forKey:EMAIL];
    [defaults setObject:created_date forKey:CREATE_DATE];
    [defaults setObject:avatar forKey:AVATAR];
    [defaults synchronize];
}
+(void)saveUsername:(NSString *)username {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:username forKey:USERNAME];
    [defaults synchronize];
}
+(void)saveAvatar:(NSString*)urlAvatar{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:urlAvatar forKey:AVATAR];
    [defaults synchronize];
}

// Remove information when user log out
+(void)removeInfoUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:TOKEN];
    [defaults removeObjectForKey:USER_ID];
    [defaults removeObjectForKey:USERNAME];
    //[defaults removeObjectForKey:EMAIL];
    [defaults removeObjectForKey:CREATE_DATE];
    [defaults removeObjectForKey:AVATAR];
}

// Get Email
+(NSString*)getEmail {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:EMAIL];
}

// Get User Name
+(NSString*)getUserName{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USERNAME];
}

// Get Created Date
+(NSString*)getCreatedDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:CREATE_DATE];
}

// Get Token
+(NSString*)getToken{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:TOKEN];
}

// Get User Id
+(NSString*)getUserId{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:USER_ID];
}

// Get Avatar
+(NSString*)getAvatar{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:AVATAR];
}

@end
