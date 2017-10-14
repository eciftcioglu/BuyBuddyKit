// BBKCredentialsKeychainPersistenceCoordinatorTests.m
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
#import "BBKCredentials.h"
#import "BBKCredentialsKeychainPersistenceCoordinator.h"

NSString * const Email = @"test@mail.com";
NSString * const Password = @"234234234";
NSTimeInterval const TestDuration = 5.00f;

NS_ASSUME_NONNULL_BEGIN

@interface BBKCredentialsKeychainPersistenceCoordinatorTests : BBKTestCase

@property (nonatomic, strong, nullable, readwrite) BBKCredentials *credentials;
@property (nonatomic, strong, nullable, readwrite) BBKCredentialsKeychainPersistenceCoordinator *coordinator;

@end

NS_ASSUME_NONNULL_END

@implementation BBKCredentialsKeychainPersistenceCoordinatorTests

- (void)setUp
{
    [super setUp];
    
    self.credentials = [[BBKCredentials alloc] initWithEmail:Email password:Password];
    
    self.coordinator = [[BBKCredentialsKeychainPersistenceCoordinator alloc] init];
}

- (void)testStoringCredentials
{
    XCTestExpectation *expectation = [[XCTestExpectation alloc] initWithDescription:@"Store passphrase"];
    
    void (^successBlk)(BBKCredentials * _Nonnull) = ^void (BBKCredentials * _Nonnull passphrase) {
        [expectation fulfill];
    };
    
    void (^failureBlk)(NSError * _Nonnull) = ^void (NSError * _Nonnull error) {
        NSAssert(NO, error.description);
    };
    
    [self.coordinator persistCredentials:self.credentials
                                 success:successBlk
                                 failure:failureBlk];
    
    [self waitForExpectations:@[expectation]
                      timeout:TestDuration];
}

@end















