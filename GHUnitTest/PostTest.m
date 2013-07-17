//
//  PostTest.m
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
#import "IMERPostViewController.h"

@interface PostTest : GHTestCase { }
@end
@implementation PostTest

- (void)setUpClass {
    // Run at start of all tests in the class
    
    IMERPostViewController *postCtrl = [IMERPostViewController alloc];
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


- (void)testPostOk{    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kServerURL,API_UPLOADPHOTOS]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    UIImage *img = [UIImage imageNamed:@"test_upload.jpg"];
    NSData *imageDataTest = UIImageJPEGRepresentation(img,1);
    [request addData:imageDataTest withFileName:@"test_upload.jpg" andContentType:@"image/jpeg" forKey:@"data[image]"];
    [request setPostValue:@"Testing commnt when upload photo" forKey:@"comment"];
    [request setPostValue:@"abcd" forKey:TOKEN];
    [request setPostValue:@"3" forKey:ID];
    [request startAsynchronous];
}
- (void)testPostNG{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kServerURL,API_UPLOADPHOTOS]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request addRequestHeader:@"Content-Type" value:@"multipart/form-data"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    //UIImage *img = [UIImage imageNamed:@"test_upload.jpg"];
    // NSData *imageDataTest = UIImageJPEGRepresentation(img,1);
    // [request addData:imageDataTest withFileName:@"myphoto.jpg" andContentType:@"image/jpeg" forKey:@"data[image]"];
    [request setPostValue:@"Testing commnt when upload photo" forKey:@"comment"];
    [request setPostValue:@"abcdefgh" forKey:TOKEN];
    [request setPostValue:@"3" forKey:ID];
    [request startAsynchronous];
}

//------ASIHTTPRequest Delegate-------
-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSArray *arrayResponseNotice = [IMERUtils getResponseNoticeWithRequest:request];
    if ([[arrayResponseNotice objectAtIndex:0] isEqualToString:@"200"]) {
        [[[UIAlertView alloc] initWithTitle:[arrayResponseNotice objectAtIndex:1]
                                    message:@"Your photo was uploaded!"
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"ERROR!"
                                    message:[arrayResponseNotice objectAtIndex:1]
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request {
    [[[UIAlertView alloc] initWithTitle:@"ERROR!"
                                message:@"Request Failed!"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

@end
