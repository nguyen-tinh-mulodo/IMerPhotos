//
//  LoginTest.m
//  iMerPhotos
//
//  Created by Jack Dawson on 6/28/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock.h>
#import "IMERViewController.h"
#import "Constants.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"

@interface LoginTest : GHTestCase { }
@end

@implementation LoginTest

- (void)setUpClass {
    // Run at start of all tests in the class
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

- (void)testloginPass{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:@"lai.thinh@mulodo.com"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PASSWORD AndValue:@"12345678"] forKey:@"1"];
    [IMERUtils postDataServer:dataPost url:API_LOGINS controller:self];
}

- (void)testloginFail{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:@"afa@yahoo.com"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PASSWORD AndValue:@"1234"] forKey:@"1"];
    [IMERUtils postDataServer:dataPost url:API_LOGINS controller:self];
}

//-----ASIHTTPRequest Delegate-----------
- (void) requestFinished:(ASIHTTPRequest *)request {
    
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        
        NSDictionary *data = [[[arrayResponseNotice objectAtIndex:2] objectForKey:RESPONSE]objectForKey:DATA];
        // Get Token
        NSString *token = [data objectForKey:TOKEN];
        // Get User Id
        NSString *user_id = [data objectForKey:USER_ID];
        // Get User Name
        NSString *user_name = [data objectForKey:USERNAME];
        
        NSLog(@"Login successfull: Hi %@ ,id %@ ,token %@", user_name,user_id,token);
    } else {
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
