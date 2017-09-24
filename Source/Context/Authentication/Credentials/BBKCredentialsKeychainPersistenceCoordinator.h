// BBKCredentialsKeychainPersistenceCoordinator.h
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
#import "BBKCredentialsPersistenceCoordination.h"

#if TARGET_OS_IOS || TARGET_OS_MAC

NS_ASSUME_NONNULL_BEGIN

/**
 A concrete implementation of `BBKCredentialsPersistenceCoordination` protocol, which uses
 *Keychain Services* of *iOS* and *macOS* platforms.
 
 Keychains can be used to store passwords, cryptographic keys, certificates & identities and notes.
 User credentials contain a email-password tuple in order to authenticate in the platform.
 
 ![Keychain Services](https://github.com/heybuybuddy/BuyBuddyKit/raw/refactor/Documentation/Assets/keychain_services_api.png)
 Reference: [Apple Keychain Services Reference](https://developer.apple.com/documentation/security/keychain_services)
 */
@interface BBKCredentialsKeychainPersistenceCoordinator :
    NSObject<BBKCredentialsPersistenceCoordination>

/**
 @name Read & Write Information
 */

/**
 Specifies the last date a user credentials object persisted.
 */
@property (nonatomic, strong, nullable, readonly) NSDate *lastWriteTimestamp;

/**
 Specifies the last date a user credentials object retrieved.
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
extern UInt8 const BBKCredentialKeychainStorageKey[];

#endif
