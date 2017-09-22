// BBKPassphrase+Persistence.h
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

#import "BBKPassphrase.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBKPassphrase (Persistence)

/**
 @name Persistence
 */

/**
 The persistence coordinator who is in charge of storing the passphrase and loading it back.
 */
@property (nonatomic, weak, nullable, readonly) id<BBKCredentialsPersistenceCoordination> coordinator;

/**
 Persists passphrase immediately.
 
 ### Discussion
 
 To persist a passphrase, it needs to have a coordinator object assigned to it, that means
 `coordinator` property should be non-`nil`, otherwise it will raise an `NSException`.
 
 @param errorPtr If non-`nil`, address of an `NSError` object will be assigned to the given pointer.
 @return `YES` if passphrase is successfully persisted to the storage, otherwise `NO`.
 */
- (BOOL)persistImmediately:(NSError * _Nullable __autoreleasing * _Nullable)errorPtr;

@end

NS_ASSUME_NONNULL_END
