//
//  PhotoDetailTest.m
//  iMerPhotos
//
//  Created by Jack Dawson on 6/28/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//
#import <GHUnitIOS/GHUnit.h>
#import <OCMock.h>
#import "IMERPhotoDetailViewController.h"
#import "Constants.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"
#import "IMERPhoto.h"

@interface PhotoDetailTest : GHTestCase { }
@end

IMERPhoto *photo;
@implementation PhotoDetailTest
- (void)setUpClass {
    // Run at start of all tests in the class
    photo = [[IMERPhoto alloc]init];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}

- (void)testgetphotoinfopass{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:@"abc"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PHOTO_ID AndValue:@"170"] forKey:@"2"];
    
    // Call function postDataServer to
    //[IMERUtils postDataServer:dataPost url:API_GETPHOTOINFOS controller:self];
    [IMERUtils postDataServer:dataPost url:API_GETPHOTOINFOS controller:self];
}

- (void)testgetphotoinfofalse{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:@"gyjuy"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PHOTO_ID AndValue:@"170"] forKey:@"2"];
    
    // Call function postDataServer to
    //[IMERUtils postDataServer:dataPost url:API_GETPHOTOINFOS controller:self];
    [IMERUtils postDataServer:dataPost url:API_GETPHOTOINFOS controller:self];
}

-(void) testlikepass{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"id" AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"token" AndValue:@"abc"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"photo_id" AndValue:@"170"] forKey:@"2"];
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_LIKES controller:self];
}

-(void) testlikefalse{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"id" AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"token" AndValue:@"abc"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"photo_id" AndValue:@"999"] forKey:@"2"];
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_LIKES controller:self];
}

-(void) testgetuserlikedpass{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"id" AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"token" AndValue:@"abc"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"photo_id" AndValue:@"16"] forKey:@"2"];
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_GETLIKEDUSERS controller:self];
}

-(void) testgetuserlikedfalse{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"id" AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"token" AndValue:@"fdgf"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:@"photo_id" AndValue:@"16"] forKey:@"2"];
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_GETLIKEDUSERS controller:self];
}


//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    NSError *error;
    NSString *responseString = [request responseString];
    NSData *responseData = [request responseData];
    //NSLog(@"Response %d : %@", request.responseStatusCode, [request responseString]);
    // Get dictionary response from request
    NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    
    NSDictionary *errorDic = [[responseDic objectForKey:@"response"]objectForKey:@"error"];
    // Get status code
    NSString *status_code = [errorDic objectForKey:@"status"];
    // Get status message
    NSString *message = [errorDic objectForKey:@"message"];
    //NSLog(@"%@,%@",status_code,message);
    if ([status_code isEqualToString:@"200"]) {
        // Good List
        NSArray *data = [[responseDic objectForKey:@"response"]objectForKey:@"data"];
        
        //Handle Multiple Request
        if([[request.userInfo objectForKey:@"type"]isEqualToString:API_GETPHOTOINFOS]){
            for (NSDictionary* dic in data) {
                NSDictionary *photoinfo = [dic objectForKey:@"photo"];
                //photo.photoId = [photoinfo objectForKey:@"id"];
                photo.comment = [photoinfo objectForKey:@"comment"];
                photo.upload_date = [photoinfo objectForKey:@"upload_date"];
                photo.totalLike = [photoinfo objectForKey:@"total_like"];
                dispatch_queue_t backgroundQueue = dispatch_queue_create("com.jack.queue", 0);
                dispatch_async(backgroundQueue, ^{
                    
                    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kServerURL,[photoinfo objectForKey:@"photo_path"]];
                    photo.imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:strUrl]];
                    
                });
                
                NSDictionary *user = [dic objectForKey:@"user"];
                photo.username = [user objectForKey:@"username"];
                
                NSDictionary *liked = [dic objectForKey:@"0"];
                photo.isLiked = [liked objectForKey:@"isLiked"];
                
                NSLog(@"Your photo info: comment %@,upload_date %@",photo.comment,photo.upload_date);
            }
        }
        
        else if ([[request.userInfo objectForKey:@"type"]isEqualToString:API_LIKES]){
            int i = [photo.totalLike intValue];
            if([photo.isLiked isEqual: @"1"]){
                photo.isLiked = @"0";
                photo.totalLike = [NSString stringWithFormat:@"%i",i-1];
            }else{
                photo.isLiked = @"1";
                photo.totalLike = [NSString stringWithFormat:@"%i",i+1];
            }
            NSLog(@"like succeed");
        }
        
        else if ([[request.userInfo objectForKey:@"type"]isEqualToString:API_GETLIKEDUSERS]){
            if(data != (id)[NSNull null]){
                for (NSDictionary* dic in data) {
                    NSDictionary *user = [dic objectForKey:@"user"];
                    NSLog(@"%@",[user objectForKey:@"username"]);
                }
            }
            else photo.totalLike = @"0";
        }
        
        
    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
    }
    
    
    
}
- (void) requestStarted:(ASIHTTPRequest *) request {
    //NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Request Failed!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil]show];
}


@end
