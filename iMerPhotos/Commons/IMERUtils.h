//
//  IMERUtils.h
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface IMERUtils : NSObject{

}

// ------check validate Email-------------
+ (BOOL) validateEmail: (NSString *) candidate;

// ------Method common to post data to server by params-------------
+ (void)postDataServer:(NSMutableDictionary*)data url:(NSString*)actionName controller:(UIViewController*) controllerName;

// Convert NSString to NSDate format - yyyy-MM-dd HH:mm:ss
+ (NSDate *)convertStringToDate:(NSString *) date;

// Convert NSDate to NSString with format
// From yyyy-MM-dd HH:mm:ss To dd MMM y
+ (NSString *)convertDateToStringWithFormat:(NSDate *) date;


+ (NSString *)dateDiff:(NSString *)origDate;

// Convert NSDate to relative date string
+ (NSString *)differenceString:(NSDate *) date;

// Resize imaage with CGSize
+ (UIImage*)resizeImageWithImage:(UIImage*)image toSize:(CGSize)newSize;
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

// Rotate image
+ (UIImage*) rotateImage:(UIImage* )src;

//custom label
+(UILabel*)myLabelWithText:(NSString*)text;

//get response_notice
+(NSArray*)getResponseNoticeWithRequest:(ASIHTTPRequest*)request;

@end
