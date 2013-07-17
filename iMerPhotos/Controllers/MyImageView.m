//
//  MyImageView.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/24/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setContentMode:UIViewContentModeScaleAspectFill];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_image != nil) {
        [_image drawInRect:self.bounds];
    }
}

-(void)startRequest:(NSString *)_url {
    if (_request != nil) {
        [_request clearDelegatesAndCancel];
    }
    
    _request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [_request setTimeOutSeconds:30];
    
    [_request setDelegate:self];
    [_request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([request responseStatusCode] == 200) {
        _image = [[UIImage alloc] initWithData:[request responseData]];
        [self setImage:_image];
        [self setNeedsDisplay];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"request failed");
}

@end
