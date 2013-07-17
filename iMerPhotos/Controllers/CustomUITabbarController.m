//
//  CustomUITabbarController.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/20/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "CustomUITabbarController.h"
#import <UIKit/UIKit.h>

@implementation CustomUITabbarController 
@synthesize tabBar;

-(void)viewDidLoad {
    [super viewDidLoad];
    tabBar.backgroundColor = [UIColor clearColor];
    CGRect frame = CGRectMake(0, 0, 480, 49);
    UIView *v = [[UIView alloc] initWithFrame:frame];
    UIImage *i = [UIImage imageNamed:@"grad.png"];
    UIColor *c = [[UIColor alloc] initWithPatternImage:i];
    v.backgroundColor = c;
    [[self tabBar] insertSubview:v atIndex:0];
}


@end
