//
//  KIFTestStep+EXAdditions.h
//  KIF
//
//  Created by nguyenkhoi on 7/1/13.
//
//

#import "KIFTestStep.h"

@interface KIFTestStep (EXAdditions)

//factory Steps
+(id)stepToReset;

// Step Collections
+ (NSArray *)stepsToGoLoginPage;

@end
