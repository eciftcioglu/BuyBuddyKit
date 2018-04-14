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

#import <Foundation/Foundation.h>

@class BBKCredentials;

/**
 `BBKPassphrasePersistenceCoordination` coordinates the persistence of a provided user credentials.
 */
@protocol BBKCredentialsPersistenceCoordination <NSObject>

@optional
/**
 Persists the provided credentials.
 
 @param credentials The session credentials which will be persisted.
 */
- (void)persistCredentials:(BBKCredentials * _Nonnull)credentials;

@optional
/**
 The Async-invariant of the persistCredentials method whcih includes a completionHandler.
 
 @param credentials The session credentials which will be persisted.
 @param handler The completion handler which will inform the user when the task is complete.
 */
- (void)persistCredentials:(BBKCredentials * _Nonnull)credentials completionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@optional
/**
 Loads the persisted credentials for the current session.
 */
- (BBKCredentials *)loadCredentials;

/**
 The Async-invariant of the loadCredentials method whcih includes a completionHandler.
 
 @param handler The completion handler which will inform the user when the loading task is complete.
 */
@optional
- (void)loadCredentialsWithCompletionHandler:(void (^_Nonnull)(BBKCredentials * _Nullable, NSError * _Nullable))handler;

/**
 Removes the current credentials for the session.
 
 @warning When this method is called the credentials will be lost and there will be no other way to retreieve it.
 */
@optional
- (void)removeCredentials;

/**
 The Async-invariant of the removeCredentials method whcih includes a completionHandler.
 
 @param handler The completion handler which will inform the user when the task is complete.
 @warning When this method is called the credentials will be lost and there will be no other way to retreieve it.
 */
@optional
- (void)removeCredentialsWithCompletionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@end
