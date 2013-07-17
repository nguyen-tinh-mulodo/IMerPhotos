//
//  KIFTestScenario+EXAdditions.m
//  KIF
//
//  Created by nguyenkhoi on 7/1/13.
//
//

#import "KIFTestScenario+EXAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+EXAdditions.h"

@implementation KIFTestScenario (EXAdditions)

+(id)scenarioToLogIn {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can successfully log in."];
    [scenario addStep:[KIFTestStep stepToReset]];
    
    [scenario addStep:[KIFTestStep stepToEnterText:@"nguyenkhoi1405@gmail.com" intoViewWithAccessibilityLabel:@"Login User Name"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"12345678" intoViewWithAccessibilityLabel:@"Login Password"]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(310, 150)]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:0.5 description:@"Wait 0.5s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log In"]];
    
    return scenario;
}

+(id)scenarioViewPhoto {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can view photo detail"];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"Wait 2s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Home"]];
    //[scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"New Photos Page" inDirection:KIFSwipeDirectionUp]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"Wait 2.0s"]];
    [scenario addStep:[KIFTestStep stepToScrollViewWithAccessibilityLabel:@"Collection View" byFractionOfSizeHorizontal:0 vertical:-60]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Feeds"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:0.5 description:@"Wait 0.5s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Cell"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Like"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Like"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Photo Detail"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Photo Detail" inDirection:KIFSwipeDirectionLeft]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Photo Detail" inDirection:KIFSwipeDirectionLeft]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Photo Detail" inDirection:KIFSwipeDirectionLeft]];
    [scenario addStep:[KIFTestStep stepToSwipeViewWithAccessibilityLabel:@"Photo Detail" inDirection:KIFSwipeDirectionLeft]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Photo Detail"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.5 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Feeds"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"Wait 1s"]];
    //[scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Mine"]];

    return scenario;
}

+(id)scenarioUpload {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can view photo detail"];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Upload"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(100, 100)]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(250, 300)]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Testing Integration Test" intoViewWithAccessibilityLabel:@"Description"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Tap View"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Post"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    
    return scenario;
}

+(id)scenarioToChangeSettings {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can change settings."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Settings"]];
    
//    [scenario addStep:[KIFTestStep stepToEnterText:@"Test" intoViewWithAccessibilityLabel:@"Change User Name"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"12345678" intoViewWithAccessibilityLabel:@"Old Password"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"12345678" intoViewWithAccessibilityLabel:@"New Password"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"12345678" intoViewWithAccessibilityLabel:@"Re-newPassword"]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(310, 150)]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:2.0 description:@"Wait 2s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Avatar"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(100, 100)]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(250, 300)]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Save"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Log Out"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    
    
    return scenario;

}


+(id)scenarioToRegister {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can register new account."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"test2@gmail.com" intoViewWithAccessibilityLabel:@"Register Email"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"12345678" intoViewWithAccessibilityLabel:@"Register Password"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"12345678" intoViewWithAccessibilityLabel:@"Register Re-password"]];
    [scenario addStep:[KIFTestStep stepToEnterText:@"Test" intoViewWithAccessibilityLabel:@"Register User Name"]];
    [scenario addStep:[KIFTestStep stepToTapScreenAtPoint:CGPointMake(310, 200)]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Sign Up"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    
    return scenario;

}

+(id)scenarioGetPass {
    KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can get password by email when forgetting."];
    [scenario addStep:[KIFTestStep stepToReset]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Get Password"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
   [scenario addStep:[KIFTestStep stepToEnterText:@"kuku@gmail.com" intoViewWithAccessibilityLabel:@"EmailTxt"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"GetPass"]];
    [scenario addStep:[KIFTestStep stepToWaitForTimeInterval:1.0 description:@"Wait 1s"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"OK"]];
    return scenario;
}

@end
