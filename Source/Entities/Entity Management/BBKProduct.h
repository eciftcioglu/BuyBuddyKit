// BBKSerialization.h
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
#import "BBKSerialization.h"

NS_ASSUME_NONNULL_BEGIN

/**
 `BBKProduct` object represents the response model which should be used to 
 represent either a product returned from the BuyBuddy platform or a product 
 which will be uploaded to the BuyBuddy platform.
 */
NS_SWIFT_NAME(Product)
@interface BBKProduct : NSObject <BBKSerialization>

/**
 @name Identification
 */

/**
 Specifies the BBKProduct identity in the *BuyBuddy* platform.
 */
@property (nonatomic, readonly) NSUInteger ID;

/// :nodoc:
@property (nonatomic, strong, nonnull, readonly) NSString *compiledID;

/// :nodoc:
- (instancetype _Nullable )initWithID:(NSUInteger)ID
                           compiledID:(NSString * _Nonnull)compiledID NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#import "BBKProduct+Pricing.h"
#import "BBKProduct+Metadata.h"
#import "BBKProduct+Device.h"
