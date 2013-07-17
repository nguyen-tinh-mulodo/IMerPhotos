//
//  SettingTest.m
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
#import "IMERSettingsViewController.h"
@interface SettingTest : GHTestCase { }
@end

@implementation SettingTest

int flag = 0;

- (void)setUpClass {
    // Run at start of all tests in the class
    
    IMERSettingsViewController *settingCtrl = [IMERSettingsViewController alloc];
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

- (void)testChangeSettingOK{
    
    flag = 1;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kServerURL,API_CHANGESETTINGS]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    UIImage *img = [UIImage imageNamed:@"test_upload.jpg"];
    NSData *imageDataTest = UIImageJPEGRepresentation(img,1);
    [request addData:imageDataTest withFileName:@"myphoto.jpg" andContentType:@"image/jpeg" forKey:@"data[avatar]"];
    [request setPostValue:@"abc" forKey:TOKEN];
    [request setPostValue:@"1" forKey:ID];
    [request setPostValue:@"Lai Thinh" forKey:USERNAME];
    [request setPostValue:@"12345678" forKey:@"old_pwd"];
    [request setPostValue:@"12345678" forKey:@"new_pwd"];
    [request startAsynchronous];
}

- (void)testChangeSettingNG{
    flag = 1;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kServerURL,API_CHANGESETTINGS]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    UIImage *img = [UIImage imageNamed:@"test_upload.jpg"];
    NSData *imageDataTest = UIImageJPEGRepresentation(img,1);
    [request addData:imageDataTest withFileName:@"myphoto.jpg" andContentType:@"image/jpeg" forKey:@"data[avatar]"];
    [request setPostValue:@"abc" forKey:TOKEN];
    [request setPostValue:@"1" forKey:ID];
    [request setPostValue:@"Lai Thinh" forKey:USERNAME];
    [request setPostValue:@"123456789999" forKey:@"old_pwd"];
    [request setPostValue:@"12345678" forKey:@"new_pwd"];
    [request startAsynchronous];
}

- (void)testLogoutOk{
    flag = 2;
    
    NSMutableDictionary *dataPost2 = [[NSMutableDictionary alloc]init];
    [dataPost2 setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"3"] forKey:@"0"];
    [dataPost2 setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:@"abcdefgh"] forKey:@"1"];
    [IMERUtils postDataServer:dataPost2 url:API_LOGOUTS controller:self];
}
- (void)testLogoutNG{
    flag = 2;
    NSMutableDictionary *dataPost2 = [[NSMutableDictionary alloc]init];
    [dataPost2 setValue:[[IMERPostData alloc]initWithNewData:ID AndValue:@"3"] forKey:@"0"];
     [dataPost2 setValue:[[IMERPostData alloc]initWithNewData:TOKEN AndValue:@"awdadwad21323"] forKey:@"1"];
    [IMERUtils postDataServer:dataPost2 url:API_LOGOUTS controller:self];
}

//------ASIHTTPRequest Delegate-------------
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    if (flag == 2) {
        if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
            // Status code 200
            [[[UIAlertView alloc] initWithTitle:@"Confirm"
                                        message:@"Logout successfull"
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        } else {
            // Error
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[arrayResponseNotice objectAtIndex:1]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        }
        
    } else if (flag == 1){
        if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {            
            // Status code 200
            [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                        message:@"Save successfully!"
                                       delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        } else {
            // Error
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:[arrayResponseNotice objectAtIndex:1]
                                       delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
            
        }
        
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request {
    [[[UIAlertView alloc] initWithTitle:@"Error"
                                message:@"Request Failed!"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

@end
