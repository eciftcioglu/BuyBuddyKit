// BBKCarrier.h
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

#if TARGET_OS_IOS
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Use the `BBKCarrier` class to access information about the users carrier information.
 */
NS_SWIFT_NAME(Carrier)
@interface BBKCarrier : NSObject

/**
 @name Properties
 */

/**
 Information about the users carrier name.
 */
@property(nonatomic, strong, nonnull, readonly) NSString *carrierName;

/**
 Information about the users carrier ISO country code.
 */
@property(nonatomic, strong, nonnull, readonly) NSString *isoCountryCode;

/**
 Information about the users carrier mobile country code.
 */
@property(nonatomic, strong, nonnull, readonly) NSString *mobileCountryCode;

/**
 Information about the users carrier mobile network code.
 */
@property(nonatomic, strong, nonnull, readonly) NSString *mobileNetworkCode;

@end

NS_ASSUME_NONNULL_END

#endif


