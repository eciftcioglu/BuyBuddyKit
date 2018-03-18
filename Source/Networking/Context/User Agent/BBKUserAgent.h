// BBKUserAgent.h
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

#if TARGET_OS_OSX
#import <SystemConfiguration/SCDynamicStoreCopySpecific.h>
#endif
#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Use the `BBKUserAgent` class to access information about the users current device, app and operating system information.
 */
NS_SWIFT_NAME(UserAgent)
@interface BBKUserAgent : NSObject

/**
 @name Properties
 */

/**
Information about the current framework name.
 */
@property (nonatomic, strong, nullable, readonly) NSString *engineName;

/**
 Information about the current framework versioning.
 */
@property (nonatomic, strong, nullable, readonly) NSString *engineVersion;

/**
 Information about the users device operating system name.
 */
@property (nonatomic, strong, nullable, readonly) NSString *engineSystemName;

/**
 Information about the users device operating system version.
 */
@property (nonatomic, strong, nullable, readonly) NSString *engineSystemVersion;

/**
 Information about the users device model.
 */
@property (nonatomic, strong, nullable, readonly) NSString *model;

/**
 The generated user agent string containing device,app and operating system information.
 */
@property (nonatomic, strong, nullable, readonly) NSString *userAgentString;

/**
 Information about the currently active application name.
 */
@property (nonatomic, strong, nullable, readonly) NSString *appName;

/**
 Information about the currently active application version.
 */
@property (nonatomic, strong, nullable, readonly) NSString *appVersion;

/**
 Information about the current CFNetwork version.
 */
@property (nonatomic, strong, nullable, readonly) NSString *networkVersion;

/**
 Information about the current Darwin operating system version.
 */
@property (nonatomic, strong, nullable, readonly) NSString *darwinVersion;

@end

NS_ASSUME_NONNULL_END
