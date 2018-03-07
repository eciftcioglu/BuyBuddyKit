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

NSString * const GenericPasswordKey = @"aKey";
NSString * const CryptographicKeyKey = @"cKey";
NSString * const NonExistentKey = @"someKey";

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
    
    [self cleanup];
}

- (void)tearDown
{
    [self cleanup];
    
    [super tearDown];
}

- (void)cleanup
{
    NSError *error = nil;
    
    [self.coordinator removeDataForKey:GenericPasswordKey
                                ofType:BBKKeychainDataTypeGenericPassword
                                 error:&error];
    
    XCTAssertNil(error);
    
    [self.coordinator removeDataForKey:CryptographicKeyKey
                                ofType:BBKKeychainDataTypeCryptographicKey
                                 error:&error];
    
    XCTAssertNil(error);
}

#pragma mark - Generic passwords

- (void)testStoresAndLoadsGenericPassword
{
    NSDictionary *attrs = @{BBKKeychainStorageAttributeComment: @"That fuck was good tho, dope af.",
                            BBKKeychainStorageAttributeAccount: @"Chatatata",
                            BBKKeychainStorageAttributeService: @"Something clever.",
                            BBKKeychainStorageAttributeSynchronizable: (__bridge id)kCFBooleanTrue};
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    NSError *error = nil;
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:GenericPasswordKey
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    NSData *loadedData = [self.coordinator loadDataForKey:GenericPasswordKey
                                                   ofType:BBKKeychainDataTypeGenericPassword
                                                    error:&error];
    
    XCTAssertNil(error);
    XCTAssertTrue([data isEqualToData:loadedData]);
}

- (void)testLoadsNilDataIfGenericPasswordDoesNotExist
{
    NSError *error = nil;
    NSData *data = [self.coordinator loadDataForKey:NonExistentKey
                                             ofType:BBKKeychainDataTypeGenericPassword
                                              error:&error];
    
    XCTAssertNil(error);
    XCTAssertNil(data);
}

- (void)testUpdatesGenericPassword
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    NSData *nextData = [NSKeyedArchiver archivedDataWithRootObject:[[BBKPassphrase alloc] initWithID:[NSNumber numberWithInt:0]
                                                                                             passkey:@"whoa"
                                                                                           issueDate:[NSDate new]
                                                                                               owner:nil]];
    
    NSDictionary *attrs = @{BBKKeychainStorageAttributeDescription: @"Some description.",
                            BBKKeychainStorageAttributeComment: @"Some comment."};
    NSError *error = nil;
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:GenericPasswordKey
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    NSData *loadedData = [self.coordinator loadDataForKey:GenericPasswordKey
                                                   ofType:BBKKeychainDataTypeGenericPassword
                                                    error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(loadedData);
    XCTAssertTrue([loadedData isEqualToData:data]);
    XCTAssertFalse([loadedData isEqualToData:nextData]);
    
    [self.coordinator persistData:nextData
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:GenericPasswordKey
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    loadedData = [self.coordinator loadDataForKey:GenericPasswordKey
                                                   ofType:BBKKeychainDataTypeGenericPassword
                                                    error:&error];
    
    XCTAssertNil(error);
    XCTAssertFalse([loadedData isEqualToData:data]);
    XCTAssertTrue([loadedData isEqualToData:nextData]);
}

- (void)testRemovesGenericPassword
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    NSDictionary *attrs = @{BBKKeychainStorageAttributeDescription: @"Some description.",
                            BBKKeychainStorageAttributeComment: @"Some comment."};
    NSError *error = nil;
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeGenericPassword
                           forKey:GenericPasswordKey
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    [self.coordinator removeDataForKey:GenericPasswordKey
                                ofType:BBKKeychainDataTypeGenericPassword
                                 error:&error];
    
    XCTAssertNil(error);
    
    NSData *loadedData = [self.coordinator loadDataForKey:GenericPasswordKey
                                                   ofType:BBKKeychainDataTypeGenericPassword
                                                    error:&error];
    
    XCTAssertNil(error);
    XCTAssertNil(loadedData);
}

#pragma mark - Cryptographic keys

- (void)testStoresAndLoadsAndUpdatesAndRemovesCryptographicKey
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.passphrase];
    NSDictionary *attrs = @{};
    NSError *error = nil;
    
    [self.coordinator persistData:data
                           ofType:BBKKeychainDataTypeCryptographicKey
                           forKey:CryptographicKeyKey
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    NSData *loadedData = [self.coordinator loadDataForKey:CryptographicKeyKey
                                                   ofType:BBKKeychainDataTypeCryptographicKey
                                                    error:&error];
    
    XCTAssertNotNil(loadedData);
    XCTAssertTrue([loadedData isEqualToData:data]);
    XCTAssertNil(error);
    
    BBKPassphrase *passphrase = [[BBKPassphrase alloc] initWithID:@0
                                                          passkey:@"another key"
                                                        issueDate:[NSDate new]
                                                            owner:nil];
    
    NSData *newData = [NSKeyedArchiver archivedDataWithRootObject:passphrase];
    
    [self.coordinator persistData:newData
                           ofType:BBKKeychainDataTypeCryptographicKey
                           forKey:CryptographicKeyKey
                   withAttributes:attrs
                            error:&error];
    
    XCTAssertNil(error);
    
    NSData *updatedData = [self.coordinator loadDataForKey:CryptographicKeyKey
                                                    ofType:BBKKeychainDataTypeCryptographicKey
                                                     error:&error];
    
    XCTAssertNil(error);
    XCTAssertNotNil(updatedData);
    XCTAssertFalse([updatedData isEqualToData:data]);
    XCTAssertTrue([updatedData isEqualToData:newData]);
    
    [self.coordinator removeDataForKey:CryptographicKeyKey
                                ofType:BBKKeychainDataTypeCryptographicKey
                                 error:&error];
    
    XCTAssertNil(error);
    
    NSData *removedData = [self.coordinator loadDataForKey:CryptographicKeyKey
                                                    ofType:BBKKeychainDataTypeCryptographicKey
                                                     error:&error];
    
    XCTAssertNil(error);
    XCTAssertNil(removedData);
}

- (void)testLoadsNilDataIfCryptographicKeyDoesNotExist
{
    NSError *error = nil;
    NSData *nilData = [self.coordinator loadDataForKey:NonExistentKey
                                                ofType:BBKKeychainDataTypeCryptographicKey
                                                 error:&error];
    
    XCTAssertNil(error);
    XCTAssertNil(nilData);
}

@end















