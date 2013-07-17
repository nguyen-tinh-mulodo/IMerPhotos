//
//  CustomUITabbarController.h
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/20/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomUITabbarController : UITabBarController {
    IBOutlet UITabBar *tabBar;
}

@property (nonatomic,retain) UITabBar *tabBar;

@end
