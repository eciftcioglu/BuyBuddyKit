//
//  BBKCarrierTests.m
//  BuyBuddyKit (iOS)
//
//  Created by Emir Çiftçioğlu on 16.03.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

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

