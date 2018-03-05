// BBKIOMetrics.m
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

#import "BBKIOMetrics.h"

NS_ASSUME_NONNULL_BEGIN

@interface BBKIOMetrics ()

@property (nonatomic, readwrite) NSUInteger domainLookup;
@property (nonatomic, readwrite) NSUInteger connection;
@property (nonatomic, readwrite) NSUInteger secureConnection;
@property (nonatomic, readwrite) NSUInteger remoteProcessing;
@property (nonatomic, readwrite) NSUInteger requestTransfer;
@property (nonatomic, readwrite) NSUInteger responseTransfer;

@end

NS_ASSUME_NONNULL_END

@implementation BBKIOMetrics

#pragma mark - Initialization

- (instancetype)initWithDomainLookup:(NSUInteger)domainLookup
                          connection:(NSUInteger)connection
                    secureConnection:(NSUInteger)secureConnection
                    remoteProcessing:(NSUInteger)remoteProcessing
                     requestTransfer:(NSUInteger)requestTransfer
                    responseTransfer:(NSUInteger)responseTransfer
{
    self = [super init];
    
    if (self) {
        _domainLookup = domainLookup;
        _connection = connection;
        _secureConnection = secureConnection;
        _remoteProcessing = remoteProcessing;
        _requestTransfer = requestTransfer;
        _responseTransfer = responseTransfer;
    }
    
    return self;
}

#pragma mark - Getters

- (NSUInteger)roundTripTime
{
    return self.domainLookup + self.connection + self.requestTransfer + self.remoteProcessing + self.responseTransfer;
}

@end
