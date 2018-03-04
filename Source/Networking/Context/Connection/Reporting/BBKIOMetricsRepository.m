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

#import "BBKIOMetricsRepository.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBKIOMetricsRepository ()

@property (nonatomic, strong, readwrite, nullable) NSDate *lastSubmission;
@property (nonatomic, readwrite) NSUInteger numberOfSubmissions;

@end

NS_ASSUME_NONNULL_END

@implementation BBKIOMetricsRepository

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _metrics = [[NSMutableArray alloc] init];
        _numberOfSubmissions = 0;
    }
    
    return self;
}

#pragma mark - Managing metrics

- (void)addMetrics:(BBKIOMetrics *)metrics
{
    [_metrics addObject:metrics];
}

#pragma mark - Submission

- (void)pushMetrics
{
    //  TODO: Push metrics to the repository.
    
    self.lastSubmission = [NSDate new];
    self.numberOfSubmissions += 1;
}

@end
