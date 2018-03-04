// BBKIOMetricsRepository
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

#import "BBKIOMetrics.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Stores `BBKIOMetrics` objects, pushes them to the central repository with the
 */
@interface BBKIOMetricsRepository : NSObject {
@private
    NSMutableArray<BBKIOMetrics *> *_metrics;
}

@property (nonatomic, strong, readonly, nonnull) NSArray<BBKIOMetrics *> *metrics;

/**
 @name Management
 */

- (void)addMetrics:(BBKIOMetrics * _Nonnull)metrics;

/**
 @name Submission
 */

/**
 Timestamp of last submission to the platform.
 */
@property (nonatomic, strong, readonly, nullable) NSDate *lastSubmission;

/**
 Number of the pushes to the central repository.
 */
@property (nonatomic, readonly) NSUInteger numberOfSubmissions;

/**
 Pushes metrics to the central repository.
 */
- (void)pushMetrics;

@end

NS_ASSUME_NONNULL_END
