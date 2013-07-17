//
//  SignUpTest.m
//  iMerPhotos
//
//  Created by Lại Huy Thịnh on 01/07/2013.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock.h>
#import "Constants.h"
#import "IMERUtils.h"
#import "IMERNSUserDefaults.h"
#import "IMERPostData.h"
#import "IMERSignUpViewController.h"
@interface SignUpTest : GHTestCase { }
@end

@implementation SignUpTest

- (void)setUpClass {
    // Run at start of all tests in the class
    
    IMERSignUpViewController *signUpCtrl = [IMERSignUpViewController alloc];
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

- (void)testSignUpOK{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:@"testsignup@gmail.com"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PASSWORD AndValue:@"12345678"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:USERNAME AndValue:@"Tester"] forKey:@"2"];
    [IMERUtils postDataServer:dataPost url:API_REGISTERS controller:self];
}


- (void)testSignUpNG{
    NSMutableDictionary *dataPost = [[NSMutableDictionary alloc]init];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:EMAIL AndValue:@"lai.thinh@mulodo"] forKey:@"0"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:PASSWORD AndValue:@"12345678"] forKey:@"1"];
    [dataPost setValue:[[IMERPostData alloc]initWithNewData:USERNAME AndValue:@"Tester"] forKey:@"2"];
    [IMERUtils postDataServer:dataPost url:API_REGISTERS controller:self];
}

//--------ASIHTTPRequest Delegate----------
-(void)requestFinished:(ASIHTTPRequest *)request {
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        // Status code 200
        [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                    message:@"Register successfully!"
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
-(void)requestFailed:(ASIHTTPRequest *)request{
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Request Failed!"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}


@end
