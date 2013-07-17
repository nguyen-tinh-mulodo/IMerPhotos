//
//  KIFTestStep+EXAdditions.m
//  KIF
//
//  Created by nguyenkhoi on 7/1/13.
//
//

#import "KIFTestStep+EXAdditions.h"

@implementation KIFTestStep (EXAdditions)

+(id)stepToReset {
    return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step,NSError ** error){
        BOOL successfulReset = YES;
        
        //do the actual reset for your app. Set successfulReset = NO if it fails
        
        KIFTestCondition(successfulReset, error,@"Failed to reset the application");
        return KIFTestStepResultSuccess;
    }];
}

+(NSArray*)stepsToGoLoginPage {
    NSMutableArray * steps = [[NSMutableArray alloc]init];
    
    //[steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log In"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log Out"]];
    
    [steps addObject:[KIFTestStep stepToSetOn:NO forSwitchWithAccessibilityLabel:@"Log In"]];
    [steps addObject:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register"]];
    
    return steps;
}

@end
