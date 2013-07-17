//
//  LostPasswordTest.m
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
#import "IMERLostPasswordViewController.h"

@interface LostPasswordTest : GHTestCase { }
@end

@implementation LostPasswordTest

- (void)setUpClass {
    // Run at start of all tests in the class
    
    IMERLostPasswordViewController *lostPassCtrl = [IMERLostPasswordViewController alloc];
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

- (void)testLostPasswordOK{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:@"lai.huy.thinh@gmail.com"] forKey:@"0"];
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_LOSTPASSWORDS controller:self];
}

- (void)testLostPasswordNG{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:@"unknown@gmail.com"] forKey:@"0"];
    // Call function postDataServer to
    [IMERUtils postDataServer:dataPost url:API_LOSTPASSWORDS controller:self];
}

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        // Status code 200
        [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                    message:@"Check your email to get new password"
                                   delegate:self
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
