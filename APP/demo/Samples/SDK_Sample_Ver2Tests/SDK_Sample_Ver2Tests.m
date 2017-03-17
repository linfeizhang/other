//
//  SDK_Sample_Ver2Tests.m
//  SDK_Sample_Ver2Tests
//
//  Created by Kusumoto Naoki on 2015/04/20.
//  Copyright (c) 2015年 Kusumoto Naoki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface SDK_Sample_Ver2Tests : XCTestCase

@end

@implementation SDK_Sample_Ver2Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
