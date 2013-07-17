//
// Created by sbeyers on 3/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharingActivityProvider.h"


@implementation SharingActivityProvider {

}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    // Log out the activity type that we are sharing with
    NSLog(@"%@", activityType);

    // Create the default sharing string
    NSString *shareString = @"CapTech is a great place to work";

    // customize the sharing string for facebook, twitter
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        shareString = [NSString stringWithFormat:@"%@", self.stringFaceBook];
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        shareString = [NSString stringWithFormat:@"%@", self.stringTwitter];
    } 

    return shareString;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end