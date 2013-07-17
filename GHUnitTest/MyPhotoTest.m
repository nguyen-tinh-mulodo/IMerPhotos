//
//  MyPhotoTest.m
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 28/06/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock.h>
#import "Constants.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"
#import "IMERMyPhotosViewController.h"

@interface MyPhotoTest : GHTestCase { }
@end

@implementation MyPhotoTest

- (void)setUpClass {
    // Run at start of all tests in the class
    
    IMERMyPhotosViewController *myPhotoCtrl = [IMERMyPhotosViewController alloc];
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

- (void)testMyPhotoOK{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:@"b19c94ff412667571d19de7eac03c5add3e3d3bd"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:COUNT AndValue:[NSString stringWithFormat:@"%i", 0]] forKey:@"2"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:OFFSET AndValue:[NSString stringWithFormat:@"%i", 12]] forKey:@"3"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID_NEED AndValue:@"1"] forKey:@"4"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TYPE AndValue:USER] forKey:@"5"];
       
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_GETPHOTOS controller:self];}

- (void)testMyPhotoNG{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"1"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:COUNT AndValue:[NSString stringWithFormat:@"%i", 0]] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:OFFSET AndValue:[NSString stringWithFormat:@"%i", 12]] forKey:@"2"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:ID_NEED AndValue:@"1"] forKey:@"3"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:TYPE AndValue:USER] forKey:@"4"];
    
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_GETPHOTOS controller:self];
}

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    NSString *sumStr = @"0";
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        
        // Get data object
        NSDictionary *dataCommon = [[[arrayResponseNotice objectAtIndex:2] objectForKey:RESPONSE]objectForKey:DATA];
        NSArray *data = [dataCommon objectForKey:@"photo_list"];
        sumStr = [dataCommon objectForKey:@"sum"];
        
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Normal"
                                    message:@"Response is OK"
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
        
    } else {
        // Error
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }

    
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
