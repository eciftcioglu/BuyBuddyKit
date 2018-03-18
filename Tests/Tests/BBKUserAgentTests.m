// BBKUserAgentTests.m
// Copyright (c) 2016-2018 BuyBuddy Elektronik Güvenlik Bilişim Reklam Telekomünikasyon Sanayi ve Ticaret Limited Şirketi ( https://www.buybuddy.co/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
