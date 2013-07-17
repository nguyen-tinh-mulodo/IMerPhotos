//
//  HomeTest.m
//  iMerPhotos
//
//  Created by Jack Dawson on 7/1/13.
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

@interface HomeTest : GHTestCase { }
@end
NSArray *arrayResponseNotice;
NSMutableArray *listPhoto;
@implementation HomeTest
- (void)setUpClass {
    // Run at start of all tests in the class
    listPhoto = [[NSMutableArray alloc]init];
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

-(void)testloaddatapass{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:@"abc"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID_NEED AndValue:@"1"] forKey:@"2"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:COUNT AndValue:@"21"] forKey:@"3"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TYPE AndValue:EXCLUDED] forKey:@"4"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:OFFSET AndValue:@"1"] forKey:@"5"];
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_GETPHOTOS controller:self];
}

-(void)testloaddatafalse{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:@"sdfdsf"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID_NEED AndValue:@"1"] forKey:@"2"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:COUNT AndValue:@"21"] forKey:@"3"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TYPE AndValue:EXCLUDED] forKey:@"4"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:OFFSET AndValue:@"1"] forKey:@"5"];
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_GETPHOTOS controller:self];
}

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    //dispatch_queue_t myqueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    //dispatch_async(myqueue, ^{
    arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        // Good List - Set number of photo
        // Get data object
        NSArray *data = [[[arrayResponseNotice objectAtIndex:2] objectForKey:RESPONSE]objectForKey:DATA];
        if(data.count < 1){
            // Empty list
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Don't have new photo"
                                       delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        }else{
            // Get photos list
            //[listPhoto removeAllObjects];
            for (NSDictionary *photo in data)
            {
                // Get Photo Object from json string
                NSDictionary *objPhoto = [photo objectForKey:PHOTO_UPCASE];
                // Init new photo from value that get from service
                IMERPhoto *newPhoto = [[IMERPhoto alloc]init];
                newPhoto.photoId = [objPhoto objectForKey:ID];
                newPhoto.comment = [objPhoto objectForKey:COMMENT];
                newPhoto.photoPath = [objPhoto objectForKey:PHOTO_PATH];
                newPhoto.userUploadId = [objPhoto objectForKey:USER_ID];
                newPhoto.upload_date = [objPhoto objectForKey:UPLOAD_DATE];
                newPhoto.totalLike = [objPhoto objectForKey:TOTAL_LIKE];
                newPhoto.username = [objPhoto objectForKey:USERNAME];
                newPhoto.isLiked = [objPhoto objectForKey:IS_LIKED];
                newPhoto.thumnailPath = [objPhoto objectForKey:THUMNAIL_PATH];
                
                [listPhoto addObject:newPhoto];
                
            }
            NSLog(@"total %i photos",listPhoto.count);
        }
        
    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
     
    //});
    
}
- (void) requestStarted:(ASIHTTPRequest *) request {
    NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Request Failed!" delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil]show];
}

@end
