// BBKNavigator.h
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
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

@class BBKUserAgent, BBKCarrier;

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 Use the `BBKNavigator` class to access information about the users device and carrier information.
 */
NS_SWIFT_NAME(Navigator)
@interface BBKNavigator : NSObject

/**
 Information about the users user agent. For more information inspect the `BBKUserAgent` class.
 */
@property (nonatomic, strong, nullable, readonly) BBKUserAgent *userAgent;

#if TARGET_OS_IPHONE
/**
 Information about the users carrier. For more information inspect the `BBKCarrier` class.
 */
@property (nonatomic, strong, nullable, readonly) BBKCarrier *carrier;
#endif

/**
 Information about the users current time conventions associated with the current geopolitical region.
 */
@property (nonatomic, strong, nullable, readonly) NSTimeZone *currentTimeZone;

/**
The alphanumeric string unique to the current users device, used only for serving advertisements.
*/
@property (nonatomic, strong, nullable, readonly) NSString *AAID;

/**
 An alphanumeric string that uniquely identifies the current users device to the app’s vendor.
 */
@property (nonatomic, strong, nullable, readonly) NSString *UUID;

@end

NS_ASSUME_NONNULL_END


