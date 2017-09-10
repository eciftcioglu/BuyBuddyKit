// BBKNetworkReachabilityManagerTests.h
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

#import "BBKNetworkReachabilityManager.h"
#import <netinet/in.h>

@interface BBKNetworkReachabilityManagerTests : BBKTestCase
@property (nonatomic, strong) BBKNetworkReachabilityManager *addressReachability;
@property (nonatomic, strong) BBKNetworkReachabilityManager *domainReachability;
@end

@implementation BBKNetworkReachabilityManagerTests

- (void)setUp
{
    [super setUp];
    
    self.domainReachability = [BBKNetworkReachabilityManager managerForDomain:@"localhost"];
    self.addressReachability = [BBKNetworkReachabilityManager managerForDefaultAddress];
}

- (void)tearDown
{
    [self.addressReachability stopPolling];
    [self.domainReachability stopPolling];
    
    [super tearDown];
}

- (void)testAddressReachabilityStartsInUnknownState
{
    XCTAssertEqual(self.addressReachability.networkReachabilityStatus,
                   BBKNetworkReachabilityStatusUnknown,
                   @"Reachability should start in an unknown state");
}

- (void)testDomainReachabilityStartsInUnknownState
{
    XCTAssertEqual(self.domainReachability.networkReachabilityStatus,
                   BBKNetworkReachabilityStatusUnknown,
                   @"Reachability should start in an unknown state");
}

- (void)verifyReachabilityNotificationGetsPostedWithManager:(BBKNetworkReachabilityManager *)manager
{
    [self expectationForNotification:BBKNetworkingReachabilityDidChangeNotification
                              object:nil
                             handler:^BOOL(NSNotification *note) {
                                 BBKNetworkReachabilityStatus status;
                                 status = [note.userInfo[BBKNetworkingReachabilityNotificationStatusItem] integerValue];
                                 BOOL isReachable = (status == BBKNetworkReachabilityStatusReachableViaWLAN
                                                     || status == BBKNetworkReachabilityStatusReachableViaWWAN);
                                 return isReachable;
                             }];
    
    [manager startPolling];
    
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testAddressReachabilityNotification
{
    [self verifyReachabilityNotificationGetsPostedWithManager:self.addressReachability];
}

- (void)testDomainReachabilityNotification
{
    [self verifyReachabilityNotificationGetsPostedWithManager:self.domainReachability];
}

- (void)verifyReachabilityStatusBlockGetsCalledWithManager:(BBKNetworkReachabilityManager *)manager
{
    __weak __block XCTestExpectation *expectation = [self expectationWithDescription:@"reachability status change block gets called"];
    
    [manager setReachabilityStatusChangeBlock:^(BBKNetworkReachabilityStatus status) {
        BOOL isReachable = (status == BBKNetworkReachabilityStatusReachableViaWLAN
                            || status == BBKNetworkReachabilityStatusReachableViaWWAN);
        if (isReachable) {
            [expectation fulfill];
            expectation = nil;
        }
    }];
    
    [manager startPolling];
    
    [self waitForExpectationsWithCommonTimeout];
    [manager setReachabilityStatusChangeBlock:nil];
    
}

- (void)testAddressReachabilityBlock
{
    [self verifyReachabilityStatusBlockGetsCalledWithManager:self.addressReachability];
}

- (void)testDomainReachabilityBlock
{
    [self verifyReachabilityStatusBlockGetsCalledWithManager:self.domainReachability];
}

@end
