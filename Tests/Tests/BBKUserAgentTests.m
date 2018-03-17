//
//  BBKUserAgentTests.m
//  BuyBuddyKit (iOS)
//
//  Created by Emir Çiftçioğlu on 16.03.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import "BBKTestCase.h"
#import "BBKUserAgent.h"
#import "BuyBuddyKit.h"

static BBKUserAgent *ScaffoldUserAgent();

NS_ASSUME_NONNULL_BEGIN

@interface BBKUserAgentTests : BBKTestCase

@property (nonatomic, strong, nullable, readwrite) BBKUserAgent *agent;
@property (nonatomic, strong, nullable, readwrite) NSString *engineName;
@property (nonatomic, strong, nullable, readwrite) NSString *engineSystemName;
@property (nonatomic, strong, nullable, readwrite) NSString *engineSystemVersion;
@property (nonatomic, strong, nullable, readwrite) NSString *model;
@property (nonatomic, strong, nullable, readwrite) NSString *userAgentString;
@property (nonatomic, strong, nullable, readwrite) NSString *appName;
@property (nonatomic, strong, nullable, readwrite) NSString *appVersion;
@property (nonatomic, strong, nullable, readwrite) NSString *networkVersion;
@property (nonatomic, strong, nullable, readwrite) NSString *darwinVersion;
@end

NS_ASSUME_NONNULL_END

@implementation BBKUserAgentTests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetsEngineName
{
    self.agent = ScaffoldUserAgent();
    self.engineName = self.agent.engineName;
    
    XCTAssertNotNil(self.engineName);
}

- (void)testGetsEngineSystemName
{
    self.agent = ScaffoldUserAgent();
    self.engineSystemName = self.agent.engineSystemName;
    
    XCTAssertNotNil(self.engineSystemName);
}

- (void)testGetsEngineSystemVersion
{
    self.agent = ScaffoldUserAgent();
    self.engineSystemVersion = self.agent.engineSystemVersion;
    
    XCTAssertNotNil(self.engineSystemVersion);
}

- (void)testGetsDeviceModel
{
    self.agent = ScaffoldUserAgent();
    self.model = self.agent.model;
    
    XCTAssertNotNil(self.model);
}

- (void)testGetsUserAgentString
{
    self.agent = ScaffoldUserAgent();
    self.userAgentString = self.agent.userAgentString;
    
    NSLog(@"%@", self.userAgentString);
    XCTAssertNotNil(self.userAgentString);
    XCTAssertTrue([self.userAgentString containsString: [NSString stringWithCString:BBKVersionString encoding:NSUTF8StringEncoding]]);
}

- (void)testGetsAppName
{
    self.agent = ScaffoldUserAgent();
    self.appName = self.agent.appName;
    
    XCTAssertNotNil(self.appName);
}

- (void)testGetsAppVersion
{
    self.agent = ScaffoldUserAgent();
    self.appVersion = self.agent.appVersion;
    
    XCTAssertNotNil(self.appVersion);
}

- (void)testGetsNetworkVersion
{
    self.agent = ScaffoldUserAgent();
    self.networkVersion = self.agent.networkVersion;
    
    XCTAssertNotNil(self.networkVersion);
}

- (void)testGetsDarwinVersion
{
    self.agent = ScaffoldUserAgent();
    self.darwinVersion = self.agent.darwinVersion;
    
    XCTAssertNotNil(self.darwinVersion);
}

@end

static BBKUserAgent *ScaffoldUserAgent()
{
    return [[BBKUserAgent alloc] init];
}
