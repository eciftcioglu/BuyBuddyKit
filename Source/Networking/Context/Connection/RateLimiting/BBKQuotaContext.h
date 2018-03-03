// BBKQuotaContext.h
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
 A `BBKQuotaContext` object contains the quota information of the user in context.
 */
NS_SWIFT_NAME(QuotaContext)
@interface BBKQuotaContext : NSObject

/**
 The total consumed amount of quota by the user in context during the session in context.
 */
@property (nonatomic, readonly) NSUInteger consumedAmount;
/**
 The maximum amount of consumable quota by the user in context during the session in context.
 */
@property (nonatomic, readonly) NSUInteger maximumAmount;
/**
 The current quota reset date for the user in context.
 */
@property (nonatomic, strong, nonnull, readonly) NSDate *quotaResetDate;
/**
 The remaining amount of usable quota for the user in context during the session in context.
 */
@property (nonatomic,  readonly) NSUInteger remainingAmount;
/**
 A boolean value determining whether key value observation is available or not during the session in context..
 
 Defaults to `YES`.
 Do not change the value unless you really know what you are doing.
 */
@property (readonly, nonatomic, assign, getter = isAvailable) BOOL available;

/**
 @name Instantiation
 */

/**
 Initializes a `BBKQuotaContext` object with the given consumed amount of quota, maximum amount of quota and the quota reset date.
 
 @param consumedAmount The consumed amount of quota by the user in context.
 @param maximumAmount The maximum amount of quota available for the user in context.
 @param quotaResetDate The reset date of the quota for the user in context.
 */
- (instancetype _Nonnull)initWithConsumedAmount:(NSUInteger)consumedAmount
                                  maximumAmount:(NSUInteger)maximumAmount
                                 quotaResetDate:(NSDate * _Nonnull)quotaResetDate NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

#import "BBKQuotaContext+FoundationConformance.h"
