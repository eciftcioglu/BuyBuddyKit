// BBKCarrierTests.m
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
#import "BBKCarrier.h"

static BBKCarrier *ScaffoldCarrier();

NS_ASSUME_NONNULL_BEGIN

#if TARGET_OS_IPHONE

@interface BBKCarrierTests : BBKTestCase

@property (nonatomic, strong, nullable, readwrite) BBKCarrier *carrier;
@property(nonatomic, strong, nonnull, readwrite) CTTelephonyNetworkInfo *netInfo;
@property(nonatomic, strong, nonnull, readwrite) NSString *carrierName;
@property(nonatomic, strong, nonnull, readwrite) NSString *isoCountryCode;
@property(nonatomic, strong, nonnull, readwrite) NSString *mobileCountryCode;
@property(nonatomic, strong, nonnull, readwrite) NSString *mobileNetworkCode;

@end

#endif

NS_ASSUME_NONNULL_END

#if TARGET_OS_IPHONE

@implementation BBKCarrierTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetsCarrierName
{
    self.carrier = ScaffoldCarrier();
    self.carrierName = self.carrier.carrierName;
    
    XCTAssertNotNil(self.carrierName);
}

- (void)testGetsIsoCountryCode
{
    self.carrier = ScaffoldCarrier();
    self.isoCountryCode = self.carrier.isoCountryCode;
    
    XCTAssertNotNil(self.isoCountryCode);
}

- (void)testGetsMobileCountryCode
{
    self.carrier = ScaffoldCarrier();
    self.mobileCountryCode = self.carrier.mobileCountryCode;
    
    XCTAssertNotNil(self.mobileCountryCode);
}

- (void)testGetsMobileNetworkCode
{
    self.carrier = ScaffoldCarrier();
    self.mobileNetworkCode = self.carrier.mobileNetworkCode;
    
    XCTAssertNotNil(self.mobileNetworkCode);
}

@end

#endif

static BBKCarrier *ScaffoldCarrier()
{
    return [[BBKCarrier alloc] init];
}

