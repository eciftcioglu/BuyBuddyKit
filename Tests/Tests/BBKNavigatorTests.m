// BBKNavigatorTests.m
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
#import "BBKNavigator.h"

static BBKNavigator *ScaffoldNavigator();

NS_ASSUME_NONNULL_BEGIN

@interface BBKNavigatorTests : BBKTestCase

@property (nonatomic, strong, nullable, readwrite) BBKNavigator *navigator;
@property (nonatomic, strong, nullable, readwrite) BBKUserAgent *agent;
@property (nonatomic, strong, nullable, readwrite) BBKCarrier *carrier;
@property (nonatomic, strong, nullable, readwrite) NSString *uuid;
@property (nonatomic, strong, nullable, readwrite) NSString *aaid;
@property (nonatomic, strong, nullable, readwrite) NSTimeZone *timeZone;

@end

NS_ASSUME_NONNULL_END

@implementation BBKNavigatorTests

- (void)setUp
{
    [super setUp];
    
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitsNavigator
{
    BBKNavigator *navigator = [[BBKNavigator alloc] init];
    
    XCTAssertNotNil(navigator);
}

- (void)testGetsUserAgent
{
    self.navigator = ScaffoldNavigator();
    self.agent = self.navigator.userAgent;
    
    XCTAssertNotNil(self.agent);
}

#if TARGET_OS_IOS
- (void)testGetsCarrier
{
    self.navigator = ScaffoldNavigator();
    self.carrier = self.navigator.carrier;
    
    XCTAssertNotNil(self.carrier);
}
#endif

- (void)testGetsUUID
{
    self.navigator = ScaffoldNavigator();
    self.uuid = self.navigator.UUID;

    XCTAssertNotNil(self.uuid);
}

#if TARGET_OS_IOS || TARGET_OS_TV
- (void)testGetsAAID
{
    self.navigator = ScaffoldNavigator();
    self.aaid = self.navigator.AAID;
    
    XCTAssertNotNil(self.aaid);
}
#endif

- (void)testGetsTimeZone
{
    self.navigator = ScaffoldNavigator();
    self.timeZone = self.navigator.currentTimeZone;
    
    XCTAssertNotNil(self.timeZone);
}

@end

static BBKNavigator *ScaffoldNavigator()
{
    return [[BBKNavigator alloc] init];
}
