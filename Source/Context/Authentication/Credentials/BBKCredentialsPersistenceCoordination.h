// BBKCredentialsPersistenceCoordination.h
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

NS_ASSUME_NONNULL_BEGIN

@class BBKCredentials;

/**
 The protocol `BBKCredentialsPersistenceCoordination` is adopted by an object who mediates the
 coordination of persistence of passphrases in a storage back-end.
 Later, the object should be able to reoccupy that previously persisted object.
 
 ## Overview
 
 As a coordinator of the persistence back-end, the implementations should not leak any information
 about the underlying storage layer, and it should recover from the errors if error arises from
 storage layer.
 
 ## Implementation
 
 Persisting a user credential is directly related with **Privacy Policy** of our platform.
 An insecure implementation may lead to leaked sensitive information of users.
 We do not force you to store the user credentials somewhere (like Keychain), nevertheless one should
 think twice before implementing this protocol in a homebrew coordinator.
 We highly encourage you to check out `BBKCredentialsKeychainPersistenceCoordinator` concrete class
 and its implementation.
 */
@protocol BBKCredentialsPersistenceCoordination <NSObject>

/**
 Persisting & Loading Objects
 */
@required
/**
 Persists given credentials in persistence layer.
 
 @param credentials Credentials to be stored by the coordinator.
 @param success Block that gets executed when persistence operation is successful.
 @param failure Block that gets executed in case of an error.
 */
- (void)persistCredentials:(nonnull BBKCredentials *)credentials
                   success:(nullable void (^)(BBKCredentials * _Nonnull credentials))success
                   failure:(nullable void (^)(NSError * _Nonnull error))failure;

/**
 Loads user credentials from persistence layer.
 
 @param completion The completion block which gets executed when operation is completed.
 */
- (void)loadCredentialsWithCompletion:(nonnull void (^)(BBKCredentials * _Nullable credentials,
                                                        NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
