// BBKPersistenceCoordination.h
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

@class BBKPassphrase;

/**
 `BBKPassphrasePersistenceCoordination` coordinates the persistence of a provided user passphrase.
 */
@protocol BBKPassphrasePersistenceCoordination <NSObject>

@optional
/**
 Persists the provided passphrase.
 
 @param passphrase The session passphrase which will be persisted.
 */
- (void)persistPassphrase:(BBKPassphrase * _Nonnull)passphrase;

@optional
/**
 The Async-invariant of the persistPassphrase method whcih includes a completionHandler.
 
 @param passphrase The session passphrase which will be persisted.
 @param handler The completion handler which will inform the user when the task is complete.
 */
- (void)persistPassphrase:(BBKPassphrase * _Nonnull)passphrase completionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@optional
/**
 Loads the persisted passphrase for the current session.
 */
- (BBKPassphrase *)loadPassphrase;

/**
 The Async-invariant of the loadPassphrase method whcih includes a completionHandler.
 
 @param handler The completion handler which will inform the user when the loading task is complete.
 */
@optional
- (void)loadPassphraseWithCompletionHandler:(void (^_Nonnull)(BBKPassphrase * _Nullable, NSError * _Nullable))handler;

/**
 Removes the current passphrase for the session.
 
 @warning When this method is called the passphrase will be lost and there will be no other way to retreieve it. A new passphrase will have to be created by providing user credentials.
 */
@optional
- (void)removePassphrase;

/**
 The Async-invariant of the removePassphrase method whcih includes a completionHandler.

 @param handler The completion handler which will inform the user when the task is complete.
 @warning When this method is called the passphrase will be lost and there will be no other way to retreieve it. A new passphrase will have to be created by providing user credentials.
 */
@optional
- (void)removePassphraseWithCompletionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@end
