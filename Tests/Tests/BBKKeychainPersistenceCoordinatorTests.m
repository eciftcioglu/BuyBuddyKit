// BBKKeychainPersistenceCoordinatorTests.m
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
#import "BBKPassphrase.h"
#import "BBKKeychainPersistenceCoordinator.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBKKeychainPersistenceCoordinatorTests : BBKTestCase

@property (nonatomic, strong, readwrite, nullable) BBKPassphrase *passphrase;
@property (nonatomic, strong, readwrite, nullable) BBKKeychainPersistenceCoordinator *coordinator;

@end

NS_ASSUME_NONNULL_END

@implementation BBKKeychainPersistenceCoordinatorTests

- (void)setUp
{
    [super setUp];
    
    self.passphrase = [[BBKPassphrase alloc] initWithID:@0
                                                passkey:@"some passkey"
                                              issueDate:[[NSDate alloc] init]
                                                  owner:nil];
    
    self.coordinator = [[BBKKeychainPersistenceCoordinator alloc] init];
}

- (void)testStoresGenericPassword
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Stores passphrase as a generic password"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:@"aKey"
                   withAttributes:@{BBKKeychainStorageAttributeComment: @"That fuck was good tho, dope af.",
                                    BBKKeychainStorageAttributeAccount: @"Chatatata",
                                    BBKKeychainStorageAttributeService: @"Something clever.",
                                    BBKKeychainStorageAttributeSynchronizable: (__bridge id)kCFBooleanTrue}
                completionHandler:^(NSError * _Nullable error) {
                    [expectation fulfill];
                }];
    
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testLoadsGenericPassword
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Loads passphrase as a generic password"];
    
    NSData *previousData = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    
    [self.coordinator loadDataForKey:@"aKey"
                              ofType:BBKKeychainDataTypeGenericPassword
                   completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
                       BBKPassphrase *unarchivedPassphrase = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                       
                       XCTAssertNotNil(data);
                       XCTAssertNil(error);
                       XCTAssertFalse([data isEqualToData:previousData]);
                       XCTAssertTrue([self.passphrase.passkey isEqualToString:unarchivedPassphrase.passkey]);
                       
                       [expectation fulfill];
                   }];
    
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testUpdatesGenericPassword
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    NSData *nextData = [NSKeyedArchiver archivedDataWithRootObject:[[BBKPassphrase alloc] initWithID:[NSNumber numberWithInt:0]
                                                                                             passkey:@"whoa"
                                                                                           issueDate:[NSDate new]
                                                                                               owner:nil]];
    
    NSString *key = @"aKey";
    NSDictionary *attrs = @{BBKKeychainStorageAttributeDescription: @"Some description.",
                            BBKKeychainStorageAttributeComment: @"Some comment."};
    NSError *error = nil;
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:key
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    NSData *loadedData = [self.coordinator loadDataForKey:key
                                                   ofType:BBKKeychainDataTypeGenericPassword
                                                    error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(loadedData);
    XCTAssertTrue([loadedData isEqualToData:data]);
    XCTAssertFalse([loadedData isEqualToData:nextData]);
    
    [self.coordinator persistData:nextData
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:key
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    loadedData = [self.coordinator loadDataForKey:key
                                                   ofType:BBKKeychainDataTypeGenericPassword
                                                    error:&error];
    
    XCTAssertNil(error);
    XCTAssertFalse([loadedData isEqualToData:data]);
    XCTAssertTrue([loadedData isEqualToData:nextData]);
}

- (void)testRemovesGenericPassword
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    NSString *key = @"aKey";
    NSDictionary *attrs = @{BBKKeychainStorageAttributeDescription: @"Some description.",
                            BBKKeychainStorageAttributeComment: @"Some comment."};
    NSError *error = nil;
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:key
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    [self.coordinator removeDataForKey:key
                                ofType:BBKKeychainDataTypeGenericPassword
                                 error:&error];
    
    XCTAssertNil(error);
    
    NSData *loadedData = [self.coordinator loadDataForKey:key
                                                   ofType:BBKKeychainDataTypeGenericPassword
                                                    error:&error];
    
    XCTAssertNil(error);
    XCTAssertNil(loadedData);
}

- (void)testStoresCryptographicKey
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Stores passphrases"];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeCryptographicKey
                           forKey:@"aKey"
                   withAttributes:@{}
                completionHandler:^(NSError * _Nullable error) {
                    [expectation fulfill];
                }];
    
    [self waitForExpectationsWithCommonTimeout];
}

@end















