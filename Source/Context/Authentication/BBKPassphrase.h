// BBKPassphrase.h
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

NS_ASSUME_NONNULL_BEGIN

@class BBKUser;
@protocol BBKPassphrasePersistenceCoordination;

/**
 Passphrase represents an access key to perform an authentication of the user.
 To enhance security, sensitive information such as login credentials (email, password etc.),
 passphrases are used as a middleware.
 
 ### Motivation
 
 Passphrases constitute main data structure of *stealth authentication* and resulting artifact of
 *concrete authentication*. 
 Passphrases are stored by its co-class `BBKPassphrasePersistenceCoordination`.
 
 To see more information, navigate to **Authentication** guide.
 */
@interface BBKPassphrase : NSObject

/**
 @name Identification
 */

/**
 Specifies database identifier of the passphrase.
 */
@property (nonatomic, strong, nonnull, readonly) NSNumber *ID;

/**
 @name Middleware Data
 */

/**
 Underlying data of the passphrase.
 
 @warning This data is critically sensitive, please check more information in
 **Terms of Conditions/Passphrase Security**.
 */
@property (nonatomic, strong, nonnull, readonly) NSString *passkey;

/**
 @name Issueing
 */

/**
 Date of issue of passphrase.
 */
@property (nonatomic, strong, nonnull, readonly) NSDate *issueDate;

/**
 @name Possesment
 */

/**
 The owner `BBKUser` instance.
 Available only upon creation, will be `nil` after decoding.
 */
@property (nonatomic, weak, nullable, readonly) BBKUser *owner;

/// :nodoc:
- (instancetype _Nonnull)initWithID:(NSNumber * _Nonnull)ID
                            passkey:(NSString * _Nonnull)passkey
                          issueDate:(NSDate * _Nonnull)date
                              owner:(BBKUser * _Nullable)owner NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#import "BBKPassphrase+FoundationConformance.h"
#import "BBKPassphrase+Validity.h"
#import "BBKPassphrase+Invalidation.h"
#import "BBKPassphrase+Persistence.h"
