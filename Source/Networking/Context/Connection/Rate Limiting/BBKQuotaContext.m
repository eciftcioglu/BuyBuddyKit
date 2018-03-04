// BBKQuotaContext.m
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

#import "BBKQuotaContext.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBKQuotaContext ()

@property (nonatomic, readwrite) NSUInteger consumedAmount;
@property (nonatomic, readwrite) NSUInteger maximumAmount;
@property (nonatomic, strong, nonnull, readwrite) NSDate *quotaResetDate;

@end

NS_ASSUME_NONNULL_END

@implementation BBKQuotaContext

#pragma mark - Initializers

- (instancetype)initWithConsumedAmount:(NSUInteger)consumedAmount
                         maximumAmount:(NSUInteger)maximumAmount
                        quotaResetDate:(NSDate *)quotaResetDate
{
    self = [super init];
    
    if (self) {
        _maximumAmount = maximumAmount;
        _quotaResetDate = quotaResetDate;
        _consumedAmount = consumedAmount;
    }
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

#pragma mark - Accessors

- (NSUInteger)remainingAmount
{
    return self.maximumAmount - self.consumedAmount;
}

- (BOOL)isAvailable
{
    return self.consumedAmount < self.maximumAmount;
}

@end

