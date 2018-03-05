// BBKKeychainPersistenceCoordinator.h
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

#import <Foundation/Foundation.h>

#if TARGET_OS_IOS || TARGET_OS_MAC

#import "../BBKSecurePersistenceCoordination.h"

#if __IPHONE_7_0 || __MAC_10_9
#define BBK_KEYCHAIN_SYNCHRONIZATION_AVAILABLE 1
#endif

#if __IPHONE_3_0 || __MAC_10_9
#define BBK_KEYCHAIN_ACCESS_GROUP_AVAILABLE 1
#endif

#ifdef BBK_KEYCHAIN_SYNCHRONIZATION_AVAILABLE
typedef NS_ENUM(NSUInteger, BBKKeychainSynchronizationMode) {
    BBKKeychainSynchronizationModeAny,
    BBKKeychainSynchronizationModeNo,
    BBKKeychainSynchronizationModeYes,
};
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 A concrete implementation of `BBKSecurePersistenceCoordination` protocol, which uses
 *Keychain Services* of *iOS* and *macOS* platforms.
 
 Keychains can be used to store passwords, cryptographic keys, certificates & identities and notes.
 
 ![Keychain Services](https://github.com/heybuybuddy/BuyBuddyKit/raw/refactor/Documentation/Assets/keychain_services_api.png)
 Reference: [Apple Keychain Services Reference](https://developer.apple.com/documentation/security/keychain_services)
 */
@interface BBKKeychainPersistenceCoordinator :
    NSObject<BBKSecurePersistenceCoordination>

/**
 @name Initialization
 */

/**
 Initializes the coordinator.
 */
- (instancetype _Nonnull)init;

/**
 @name Persisting & Retrieving Data
 */

/**
 Persists given data in secure keychain.
 
 @param data Data to be stored by the coordinator.
 @param type Type of the going to be stored by the coordinator.
 @param keyString Key of the value.
 @param errPtr In case of an error, a pointer to reference the `NSError` object.
 */
- (BOOL)persistData:(NSData * _Nonnull)data
             ofType:(BBKKeychainDataType)type
            forKey:(NSString * _Nonnull)keyString
              error:(NSError * __autoreleasing _Nullable * _Nullable)errPtr;

/**
 Loads data from secure keychain with given key.
 
 @param keyString Key of the value.
 @param errPtr In case of an error, a pointer to reference the `NSError` object.
 */
- (NSData * _Nullable)loadDataForKey:(NSString * _Nonnull)keyString
                               error:(NSError * __autoreleasing _Nullable * _Nullable)errPtr;

/**
 @name Read & Write Information
 */

/**
 Specifies the last date an object persisted.
 */
@property (nonatomic, strong, nullable, readonly) NSDate *lastWriteTimestamp;

/**
 Specifies the last date an object retrieved.
 */
@property (nonatomic, strong, nullable, readonly) NSDate *lastReadTimestamp;

@end

NS_ASSUME_NONNULL_END

/**
 @name Constants
 */

/**
 Unique string used to identify the keychain item.
 */
extern UInt8 const BBKKeychainStorageKey[];

#if TARGET_OS_MAC
extern NSString * const BBKKeychainStorageErrorUserInfoKey;
#endif

#endif
