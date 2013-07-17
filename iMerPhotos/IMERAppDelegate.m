//
//  IMERAppDelegate.m
//  iMerPhotos
//
//  Created by nguyenkhoi on 6/7/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import "IMERAppDelegate.h"
#if RUN_KIF_TESTS
#import "IMERTestController.h"
#endif

@implementation IMERAppDelegate

- (void)customizeAppearance
{
    // Customize background for all page
    //_window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios-fabric-1680-800x500.png"]];
    

    
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Condiment-Regular" size:25.0],
      UITextAttributeFont,
      nil]];
    
    UIImage *tabBackground = [[UIImage imageNamed:@"bg"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
   // [[UITabBar appearance]setBackgroundColor:[UIColor clearColor]];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"bg"]];
    
    
//    [[UITabBar appearance]setBackgroundColor:[UIColor clearColor]];
//    [[UITabBar appearance] setOpaque:FALSE];
//    [[UITabBar appearance] setAlpha:0.1];

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self customizeAppearance];
    
#if RUN_KIF_TESTS
    [[IMERTestController sharedInstance] startTestingWithCompletionBlock:^{
        // Exit after the tests complete so that CI knows we're done
        exit([[IMERTestController sharedInstance] failureCount]);
    }];
#endif
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
