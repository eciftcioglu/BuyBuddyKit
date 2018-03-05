// BBKIOMetrics+FoundationConformance.m
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

#import "BBKIOMetrics+FoundationConformance.h"

@implementation BBKIOMetrics (FoundationConformance)

#pragma mark - Secure coding conformance

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithDomainLookup:[aDecoder decodeIntegerForKey:@"domainLookup"]
                           connection:[aDecoder decodeIntegerForKey:@"connection"]
                     secureConnection:[aDecoder decodeIntegerForKey:@"secureConnection"]
                     remoteProcessing:[aDecoder decodeIntegerForKey:@"remoteProcessing"]
                      requestTransfer:[aDecoder decodeIntegerForKey:@"requestTransfer"]
                     responseTransfer:[aDecoder decodeIntegerForKey:@"responseTransfer"]];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:self.domainLookup forKey:@"domainLookup"];
    [aCoder encodeInteger:self.connection forKey:@"connection"];
    [aCoder encodeInteger:self.secureConnection forKey:@"secureConnection"];
    [aCoder encodeInteger:self.remoteProcessing forKey:@"remoteProcessing"];
    [aCoder encodeInteger:self.requestTransfer forKey:@"requestTransfer"];
    [aCoder encodeInteger:self.responseTransfer forKey:@"responseTransfer"];
}

#pragma mark - Copying conformance

- (id)copyWithZone:(NSZone *)zone
{
    return [[[super class] allocWithZone:zone] initWithDomainLookup:self.domainLookup
                                                         connection:self.connection
                                                   secureConnection:self.secureConnection
                                                   remoteProcessing:self.remoteProcessing
                                                    requestTransfer:self.requestTransfer
                                                   responseTransfer:self.responseTransfer];
}

@end
