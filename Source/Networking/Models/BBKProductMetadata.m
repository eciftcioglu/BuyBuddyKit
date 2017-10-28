// BBKSerialization.h
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

#import "BBKProductMetadata.h"

@implementation BBKProductMetadata

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (instancetype)initWithcolor:(NSString *)color
                         size:(NSString *)size
                         code:(NSInteger)code
{
    self = [super init];
    
    if (self) {
        _color = color;
        _size = size;
        _code = code;
    }
    
    return self;
}


- (instancetype)initWithDeserializedDictionary:(NSDictionary<NSString *, id> *)dictionary
{
        return [self initWithcolor:[dictionary objectForKey:@"color"] size:[dictionary objectForKey:@"size"] code:[[dictionary objectForKey:@"code"] intValue] ];
}

- (void)serializeToDictionary:(NSMutableDictionary<NSString *,id<NSSecureCoding>> *)dictionary
{
    [dictionary setObject:self.color
                   forKey:@"color"];
    [dictionary setObject:self.size
                   forKey:@"size"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.code]
                   forKey:@"code"];
}

@end
