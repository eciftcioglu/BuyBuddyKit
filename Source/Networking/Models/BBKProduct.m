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

#import "BBKProduct.h"

@implementation BBKProduct


- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (instancetype)initWithhitagCompiledId:(NSString *)hitagCompiledId
                                hitagId:(NSInteger)hitagId
                                   name:(NSString *)name
                              productId:(NSInteger)productId
                               metaData:(BBKProductMetaData *)metaData
                               imageURL:(NSString *)imageURL
                     productDescription:(NSString *)productDescription
                                  price:(BBKPrice *)price
{
    self = [super init];
    
    if (self) {
        
        _hitagCompiledId = hitagCompiledId;
        _hitagId = hitagId;
        _name = name;
        _productId = productId;
        _metaData = metaData;
        _imageURL = imageURL;
        _productDescription = productDescription;
        _price = price;
    }
    
    return self;
}

- (instancetype)initWithDeserializedDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    return [self initWithhitagCompiledId:[dictionary objectForKey:@"hitag_compiled_id"] hitagId:[[dictionary objectForKey:@"h_id"] intValue] name:[dictionary objectForKey:@"name"] productId:[[dictionary objectForKey:@"id"] intValue] metaData:[dictionary objectForKey:@"metadata"] imageURL:[dictionary objectForKey:@"image"] productDescription:[dictionary objectForKey:@"description"] price:[dictionary objectForKey:@"price"]];
}

- (void)serializeToDictionary:(NSMutableDictionary<NSString *,id<NSSecureCoding>> *)dictionary
{
    NSData *encodedMetaDataObject = [NSKeyedArchiver archivedDataWithRootObject:self.metaData];
    NSData *encodedPriceObject = [NSKeyedArchiver archivedDataWithRootObject:self.price];
    
    
    [dictionary setObject:self.hitagCompiledId
                   forKey:@"hitag_compiled_id"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.hitagId]
                   forKey:@"h_id"];
    [dictionary setObject:self.name
                   forKey:@"name"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.productId]
                   forKey:@"id"];
    [dictionary setObject:encodedMetaDataObject
                   forKey:@"metadata"];
    [dictionary setObject:self.imageURL
                   forKey:@"image"];
    [dictionary setObject:self.description
                   forKey:@"description"];
    [dictionary setObject:encodedPriceObject
                   forKey:@"price"];
}

@end
