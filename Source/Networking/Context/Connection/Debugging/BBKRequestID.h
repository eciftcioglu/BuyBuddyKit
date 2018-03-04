// BBKRequestID.h
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

/**
 The `BBKRequestID` class represents identifier attached to a HTTP request,
 uniquely identifying the request from the client-side.
 
 ## Overview
 
 Request identifiers are created from crypto-safe pseudo-random generator,
 and have exact length of the number given in `BBKRequestIDStringLength`.
 
 */
@interface BBKRequestID : NSObject

/**
 @name Creating Request Identifiers
 */

/**
 Creates and returns a new `BBKRequestID` object.
 */
+ (BBKRequestID * _Nonnull)requestID;

- (instancetype _Nullable)initWithRequestIDBytes:(NSData * _Nonnull)bytes NS_DESIGNATED_INITIALIZER;

/**
 Accessing Request Identifier
 */
@property (nonatomic, strong, nonnull, readonly) NSString *requestIDString;

@end

FOUNDATION_EXPORT NSUInteger const BBKRequestIDStringLength;
