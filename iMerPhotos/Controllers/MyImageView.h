//
//  MyImageView.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/24/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MyImageView : UIImageView<ASIHTTPRequestDelegate> {
    ASIHTTPRequest *_request;
    UIImage *_image;
}

-(void)startRequest:(NSString*)_url;

@end
