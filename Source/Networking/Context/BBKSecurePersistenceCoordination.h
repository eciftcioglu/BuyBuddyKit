// BBKSecurePersistenceCoordination.h
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

typedef NS_ENUM(NSUInteger, BBKKeychainDataType) {
    BBKKeychainDataTypeGenericPassword,
    BBKKeychainDataTypeCryptographicKey,
    BBKKeychainDataTypeCertificate,
};

NS_ASSUME_NONNULL_BEGIN

/**
 The protocol `BBKSecurePersistenceCoordination.h` is adopted by an object who mediates the
 coordination of persistence of secure data (i.e. passphrases) in a storage back-end.
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
 We highly encourage you to check out `BBKKeychainPersistenceCoordinator` concrete class
 and its implementation.
 */
@protocol BBKSecurePersistenceCoordination <NSObject>

/**
 @name Persisting & Loading Objects
 */

/**
 Persists given data in secure persistence layer asynchronously.
 
 @param data Data to be stored by the coordinator.
 @param type Type of the going to be stored by the coordinator.
 @param keyString Key of the value.
 @param attributes Additional attributes passed to the persistence coordinator.
 @param handler An optional callback function to be called at the end of the action.
 */
@optional
- (void)persistData:(NSData * _Nonnull)data
             ofType:(BBKKeychainDataType)type
             forKey:(NSString * _Nonnull)keyString
     withAttributes:(NSDictionary<NSString *, id> *)attributes
  completionHandler:(void (^ _Nullable)(NSError * _Nullable error))handler;

/**
 Loads data from persistence layer with given key asynchronously.
 
 @param keyString Key of the value.
 @param handler A mandatory callback function to be called at the end of the action.
 */
@optional
- (void)loadDataForKey:(NSString * _Nonnull)keyString
     completionHandler:(void (^ _Nonnull)(NSData * _Nullable data, NSError * _Nullable error))handler;

/**
 Persists given data in secure persistence layer.
 
 @param data Data to be stored by the coordinator.
 @param type Type of the going to be stored by the coordinator.
 @param keyString Key of the value.
 @param attributes Additional attributes passed to the persistence coordinator.
 @param errPtr In case of an error, a pointer to reference the `NSError` object.
 */
@required
- (BOOL)persistData:(NSData * _Nonnull)data
             ofType:(BBKKeychainDataType)type
             forKey:(NSString * _Nonnull)keyString
     withAttributes:(NSDictionary<NSString *, id> *)attributes
              error:(NSError * __autoreleasing _Nullable * _Nullable)errPtr;

/**
 Loads data from persistence layer with given key.
 
 @param keyString Key of the value.
 */
@required
- (NSData * _Nullable)loadDataForKey:(NSString * _Nonnull)keyString
                               error:(NSError * __autoreleasing _Nullable * _Nullable)errPtr;

@end

NS_ASSUME_NONNULL_END

typedef NSString * _Null_unspecified BBKSecurePersistenceAttributeKey NS_EXTENSIBLE_STRING_ENUM;
