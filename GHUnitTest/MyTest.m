//
//  MyTest.m
//  iMerPhotos
//
//  Created by Jack Dawson on 6/27/13.
//  Copyright (c) 2013 nguyenkhoi. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>
#import <OCMock.h>

@interface MyTest : GHTestCase { }
@end

@implementation MyTest

- (void)testSimplePass {
	// Another test
}

- (void)testSimpleFail {
	GHAssertTrue(NO, nil);
}

// simple test to ensure building, linking,
// and running test case works in the project
- (void)testOCMockPass {
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    GHAssertEqualObjects(@"mocktest", returnValue,
                         @"Should have returned the expected string.");
}

- (void)testOCMockFail {
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    
    NSString *returnValue = [mock lowercaseString];
    GHAssertEqualObjects(@"thisIsTheWrongValueToCheck",
                         returnValue, @"Should have returned the expected string.");
}


@end
