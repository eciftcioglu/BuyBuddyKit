// BBKIOMetrics.h
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

/**
 A `BBKIOMetrics` object encapsulates latency statistics collected during network operations,
 and is sent to the platform later by `BBKIOMetricsRepository`.
 */
@interface BBKIOMetrics : NSObject

/**
 @name Statistics
 */

/**
 The time passed during DNS resolution, in nanoseconds.
 */
@property (nonatomic, readonly) NSUInteger domainLookup;

/**
 The time passed during establishment of TCP connection, in nanoseconds.
 */
@property (nonatomic, readonly) NSUInteger connection;

/**
 The time passed during TLS handshaking, in nanoseconds.
 */
@property (nonatomic, readonly) NSUInteger secureConnection;

/**
 The time passed during processing of request by the remote host, in nanoseconds.
 */
@property (nonatomic, readonly) NSUInteger remoteProcessing;

/**
 The time passed during data transfer of request.
 */
@property (nonatomic, readonly) NSUInteger requestTransfer;

/**
 The time passed during data transfer of response.
 */
@property (nonatomic, readonly) NSUInteger responseTransfer;

/**
 The total time passed during round-trip.
 */
@property (nonatomic, readonly) NSUInteger roundTripTime;

/// :nodoc
- (instancetype _Nonnull)initWithDomainLookup:(NSUInteger)domainLookup
                                  connection:(NSUInteger)connection
                            secureConnection:(NSUInteger)secureConnection
                            remoteProcessing:(NSUInteger)remoteProcessing
                             requestTransfer:(NSUInteger)requestTransfer
                            responseTransfer:(NSUInteger)responseTransfer;

@end

NS_ASSUME_NONNULL_END

#import "BBKIOMetrics+FoundationConformance.h"
