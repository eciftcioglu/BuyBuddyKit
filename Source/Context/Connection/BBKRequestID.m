// BBKRequestID.m
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

#import "BBKRequestID.h"

NSUInteger const BBKRequestIDStringLength = 32UL;
static CFDataRef BBKCreateRequestIDData();

@interface BBKRequestID ()

@property (nonatomic, strong, nonnull, readonly) NSData *requestIDData;

@end

@implementation BBKRequestID

+ (BBKRequestID *)requestID
{
    return [[[self class] alloc] init];
}

- (instancetype)initWithRequestIDBytes:(NSData *)bytes
{
    if ([bytes length] == BBKRequestIDStringLength) {
        self = [super init];
        
        if (self) {
            _requestIDData = bytes;
        }
        
        return self;
    } else {
        return nil;
    }
}

- (instancetype)init
{
    return [self initWithRequestIDBytes:(__bridge_transfer NSData * _Nonnull)BBKCreateRequestIDData()];
}

- (NSString *)requestIDString
{
    return [[NSString alloc] initWithData:self.requestIDData
                                 encoding:NSASCIIStringEncoding];
}

@end

static CFDataRef BBKCreateRequestIDData()
{
    uint8_t *output = malloc(sizeof(char) * BBKRequestIDStringLength);
    
    memset(output, 0, sizeof(char) * BBKRequestIDStringLength);
    
    for (NSUInteger i = 0; i < BBKRequestIDStringLength; ++i) {
        output[i] = (uint8_t)(arc4random() % 25) + 97;
    }
    
    CFDataRef data = CFDataCreate(CFAllocatorGetDefault(),
                                  output,
                                  BBKRequestIDStringLength);
    
    return data;
}













