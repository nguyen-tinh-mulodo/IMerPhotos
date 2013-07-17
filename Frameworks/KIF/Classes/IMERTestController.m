//
//  IMERTestController.m
//  KIF
//
//  Created by nguyenkhoi on 7/1/13.
//
//

#import "IMERTestController.h"
#import "KIFTestScenario+EXAdditions.h"

@implementation IMERTestController

-(void)initializeScenarios {
    [self addScenario:[KIFTestScenario scenarioToLogIn]];
    
    [self addScenario:[KIFTestScenario scenarioViewPhoto]];
    [self addScenario:[KIFTestScenario scenarioUpload]];
    [self addScenario:[KIFTestScenario scenarioToChangeSettings]];
    [self addScenario:[KIFTestScenario scenarioToRegister]];
    [self addScenario:[KIFTestScenario scenarioGetPass]];
    
    
    //[super initializeScenarios];
}

@end
