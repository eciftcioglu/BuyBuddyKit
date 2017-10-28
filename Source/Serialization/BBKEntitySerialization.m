// BBKEntitySerialization.m
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

#import "BBKEntitySerialization.h"

@implementation BBKEntitySerialization

#pragma clang diagnostic push

+ (id)entityWithData:(NSData *)data
            keyClass:(Class)className
               error:(NSError * _Nullable __autoreleasing *)errorPtr
{
    NSAssert([className conformsToProtocol:@protocol(BBKSerialization)],
             @"class %@ does not conform to protocol: BBKSerialization", NSStringFromClass(className));
    
    NSError *ptr;
    
    id obj = [[self class] JSONObjectWithData:data
                                      options:0
                                        error:&ptr];

    if (ptr) {
        if (errorPtr) {
            *errorPtr = ptr;
        }
        
        return nil;
    }
    
    id<BBKSerialization> entity = [[className alloc] initWithDeserializedDictionary:obj];
    
    return entity;
}

#pragma clang diagnostic pop

+ (NSData *)dataWithEntity:(id<BBKSerialization>)entity
                   options:(NSJSONWritingOptions)options
                     error:(NSError * _Nullable __autoreleasing *)errorPtr
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [entity serializeToDictionary:dictionary];
    
    return [[self class] dataWithJSONObject:dictionary
                                    options:options
                                      error:errorPtr];
}

@end
