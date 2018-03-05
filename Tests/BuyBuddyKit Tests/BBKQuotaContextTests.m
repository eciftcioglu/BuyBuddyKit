// BBKQuotaContextTests.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//               2016-2018 BuyBuddy Elektronik Güvenlik Bilişim Reklam Telekomünikasyon Sanayi ve Ticaret Limited Şirketi ( https://www.buybuddy.co/ )
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
#import "BBKQuotaContext.h"

static BBKQuotaContext *ScaffoldQuotaContext();

NS_ASSUME_NONNULL_BEGIN

@interface BBKQuotaContextTests : BBKTestCase

@property (nonatomic, strong, nullable, readwrite) BBKQuotaContext *quota;
@property (nonatomic, strong, nullable, readwrite) NSDate *resetDate;

@end

NS_ASSUME_NONNULL_END

@implementation BBKQuotaContextTests

- (void)setUp
{
    [super setUp];
    
    self.resetDate = [NSDate dateWithTimeIntervalSinceNow:3600];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitsQuotaContext
{
    BBKQuotaContext *quotaContext = [[BBKQuotaContext alloc] initWithConsumedAmount:70
                                                                      maximumAmount:100
                                                                     quotaResetDate:self.resetDate];
    
    XCTAssertNotNil(quotaContext);
    XCTAssert(quotaContext.maximumAmount == 100);
    XCTAssert(quotaContext.consumedAmount == 70);
    XCTAssert(quotaContext.quotaResetDate == self.resetDate);
}

- (void)testCalculatesRemainingAmountWithAvailability
{
    self.quota = [[BBKQuotaContext alloc] initWithConsumedAmount:70
                                                   maximumAmount:100
                                                  quotaResetDate:self.resetDate];
    
    XCTAssertEqual(self.quota.remainingAmount,
                   self.quota.maximumAmount - self.quota.consumedAmount);
    XCTAssertTrue(self.quota.isAvailable);
}

- (void)testCalculatesRemainingAmountWithoutAvailability
{
    self.quota = ScaffoldQuotaContext();
    
    XCTAssertEqual(self.quota.remainingAmount,
                   self.quota.maximumAmount - self.quota.consumedAmount);
    XCTAssertFalse(self.quota.isAvailable);
}

- (void)testDecodesObject
{
    self.quota = ScaffoldQuotaContext();
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.quota];
    
    BBKQuotaContext *context = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    XCTAssertNotNil(context);
    XCTAssertEqual(self.quota.remainingAmount, context.remainingAmount);
    XCTAssertEqual(self.quota.maximumAmount, context.maximumAmount);
    XCTAssertEqual(self.quota.consumedAmount, context.consumedAmount);
    XCTAssertTrue([self.quota.quotaResetDate isEqualToDate:context.quotaResetDate]);
}

- (void)testEncodesObject
{
    self.quota = ScaffoldQuotaContext();
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.quota];
    
    XCTAssertNotNil(encodedObject);
}

- (void)testCopyObject
{
    self.quota = ScaffoldQuotaContext();
    BBKQuotaContext *copy = [self.quota copy];
    
    XCTAssertEqual(self.quota.remainingAmount, copy.remainingAmount);
    XCTAssertEqual(self.quota.maximumAmount, copy.maximumAmount);
    XCTAssertEqual(self.quota.consumedAmount, copy.consumedAmount);
    XCTAssertEqual(self.quota.quotaResetDate, copy.quotaResetDate);
}

@end

static BBKQuotaContext *ScaffoldQuotaContext()
{
    return [[BBKQuotaContext alloc] initWithConsumedAmount:100
                                             maximumAmount:100
                                            quotaResetDate:[[NSDate alloc] init]];
}

