//
//  IMERUtils.m
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 6/10/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERUtils.h"
#import "IMERPostData.h"
#import "Constants.h"

@implementation IMERUtils


// ------check validate Email-------------
+(BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

// Method common to post data to server by params
+(void)postDataServer:(NSMutableDictionary*)data url:(NSString*)actionName controller:(UIViewController*) controllerName{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    dispatch_async(backgroundQueue, ^{
        // Init Url
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kServerURL,actionName]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        // Set method request
        [request setRequestMethod:REQUEST_METHOD];
        [request addRequestHeader:REQUEST_HEADER value:[NSString stringWithFormat:@"%@/",kServerURL]];
        // Check params in NSMutableDictionary and set value to post
        for(int i = 0; i<data.count;i++){
            NSString *number = [[NSString alloc] initWithFormat:@"%i", i];
            IMERPostData *dataPost = [data objectForKey:number];
            // Set key - value params to post URL
            [request setPostValue:dataPost.valueParam forKey:dataPost.nameParam];
        }
        request.userInfo = [NSDictionary dictionaryWithObject:actionName forKey:@"type"];
        // Set delegate for ViewCotroller
        [request setDelegate:controllerName];
        [request startAsynchronous];

    });
}

// Convert NSString to NSDate format - yyyy-MM-dd HH:mm:ss
+ (NSDate *)convertStringToDate:(NSString *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //NSDate *nowDate = [[NSDate alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    date = [date stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    NSDate *nowDate = [formatter dateFromString:date];
    return nowDate;  
}

// Convert NSDate to NSString with format
// From yyyy-MM-dd HH:mm:ss To dd MMM y
+ (NSString *)convertDateToStringWithFormat:(NSDate *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM y"];
    return [dateFormatter stringFromDate:date];
}



+ (NSString *)dateDiff:(NSString *)origDate {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *convertedDate = [df dateFromString:origDate];
    //NSDate *convertedDate = [self convertStringToDate:origDate];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
    	return @"never";
    } else 	if (ti < 60) {
    	return @"less than a minute ago";
    } else if (ti < 3600) {
    	int diff = round(ti / 60);
    	return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
    	int diff = round(ti / 60 / 60);
    	return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
    	int diff = round(ti / 60 / 60 / 24);
    	return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
    	return @"never";
    }
}

// Convert NSDate to relative date string
+ (NSString *)differenceString:(NSDate *) date{
    NSDate *now = [NSDate date];
    double time = [date timeIntervalSinceDate:now];
    time *= -1;
    if (time < 60) {
        int diff = round(time);
        if (diff == 1)
            return @"1 second ago";
        return [NSString stringWithFormat:@"%d seconds ago", diff];
    } else if (time < 3600) {
        int diff = round(time / 60);
        if (diff == 1)
            return @"1 minute ago";
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (time < 86400) {
        int diff = round(time / 60 / 60);
        if (diff == 1)
            return @"1 hour ago";
        return [NSString stringWithFormat:@"%d hours ago", diff];
    } else if (time < 604800) {
        int diff = round(time / 60 / 60 / 24);
        if (diff == 1)
            return @"yesterday";
        if (diff == 7)
            return @"a week ago";
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        int diff = round(time / 60 / 60 / 24 / 7);
        if (diff == 1)
            return @"a week ago";
        return [NSString stringWithFormat:@"%d weeks ago", diff];
    }
}


// Resize imaage with CGSize
+ (UIImage*)resizeImageWithImage:(UIImage*)image toSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // draw in new context, with the new size
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(UILabel*)myLabelWithText:(NSString *)text {
    CGRect frame = CGRectMake(0, 0, 320, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    UIFont *titleFont = [UIFont fontWithName:FONT size:FONT_SIZE];
    label.backgroundColor = [UIColor clearColor];
    label.font = titleFont;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:32.0f/255.0f green:178.0f/255.0f blue:170.0f/255.0f alpha:1.0];
    label.text = text;
    return label;
}

+(NSArray*)getResponseNoticeWithRequest:(ASIHTTPRequest *)request {
    NSError *error;
    //NSString *responseString = [request responseString];
    NSData *responseData = [request responseData];
    //NSLog(@"Response %d : %@", request.responseStatusCode, responseString);
    // Get dictionary response from request
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSDictionary *errorDic = [[responseDic objectForKey:RESPONSE]objectForKey:ERROR];
    // Get status code
    NSString *status_code = [errorDic objectForKey:STATUS_CODE];
    // Get status message
    NSString *message = [errorDic objectForKey:MESSAGE];
    
    NSArray* array = [[NSArray alloc]initWithObjects:status_code,message, responseDic,nil];
    return array;
}


//resize image
+(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


// rotate image
+ (UIImage*) rotateImage:(UIImage* )src {
    
    UIImageOrientation orientation = src.imageOrientation;
    
    UIGraphicsBeginImageContext(src.size);
    
    [src drawAtPoint:CGPointMake(0, 0)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, [IMERUtils radians:90]);
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, [IMERUtils radians:90]);
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, [IMERUtils radians:0]);
    }
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (CGFloat) radians:(int)degrees {
    return (degrees/180)*(22/7);
}

@end
