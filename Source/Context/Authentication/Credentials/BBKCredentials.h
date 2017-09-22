// BBKCredentials.h
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

/**
 A class that contains user credentials for challenging the platform's
 authentication authority with email (aka BuyBuddy ID) and password.
 
 ## Discussion
 
 A `BBKCredentials` object should not be persisted in an unsafe way since
 this information belongs to platform users, and highly sensitive.
 
 #### Persistence
 
 We provide credential persistence helper protocol 
 `BBKCredentialsPersistenceCoordination` in order to store passwords.
 An concrete implementation of this protocol can be found in class
 `BBKCredentialsKeychainPersistenceCoordinator`, which persists instances
 of this class in *Keychain* included in *Apple's Security Framework*.
 
 Please read **Privacy Policy** of our services before implementing with
 this class.
 
 ## Subclassing
 
 `BBKCredentials` class should not be subclassed in any way since it
 contains critical information about user access.
 */
@interface BBKCredentials : NSObject

/**
 @name Sensitive Information
 */

/**
 Specifies user's identity in *BuyBuddy* platform as an email.
 */
@property (nonatomic, strong, nonnull, readonly) NSString *email;

/**
 Specifies user's password.
 */
@property (nonatomic, strong, nonnull, readonly) NSString *password;

/// :nodoc:
- (instancetype _Nonnull)initWithEmail:(NSString * _Nonnull)email
                              password:(NSString * _Nonnull)password;

@end
