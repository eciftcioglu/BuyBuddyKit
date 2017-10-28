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

#import "BBKPrice.h"

@implementation BBKPrice

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

- (instancetype)initWithcurrentPrice:(float)currentPrice
                       discountPrice:(float)discountPrice
                            oldPrice:(float)oldPrice
                       discountRatio:(float)discountRatio
                       campaignPrice:(float)campaignPrice
                             taxRate:(float)taxRate
                            taxPrice:(float)taxPrice
                    taxExcludedPrice:(float)taxExcludedPrice
{
    self = [super init];
    
    if (self) {
        _currentPrice = currentPrice;
        _discountPrice = discountPrice;
        _oldPrice = oldPrice;
        _discountRatio = discountRatio;
        _campaignPrice = campaignPrice;
        _taxRate = taxRate;
        _taxPrice = taxPrice;
        _taxExcludedPrice = taxExcludedPrice;
    }
    
    return self;
}


- (instancetype)initWithDeserializedDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    
    return [self initWithcurrentPrice:[[dictionary objectForKey:@"current_price"]floatValue] discountPrice:[[dictionary objectForKey:@"discount_price"]floatValue] oldPrice:[[dictionary objectForKey:@"old_price"]floatValue] discountRatio:[[dictionary objectForKey:@"discount_ratio"]floatValue] campaignPrice:[[dictionary objectForKey:@"campaign_price"]floatValue] taxRate:[[dictionary objectForKey:@"tax_rate"]floatValue] taxPrice:[[dictionary objectForKey:@"tax_price"]floatValue] taxExcludedPrice:[[dictionary objectForKey:@"tax_excluded_price"]floatValue]];
    
}

- (void)serializeToDictionary:(NSMutableDictionary<NSString *,id<NSSecureCoding>> *)dictionary
{
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.currentPrice]
                   forKey:@"current_price"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.discountPrice]
                   forKey:@"discount_price"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.oldPrice]
                   forKey:@"old_price"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.discountRatio]
                   forKey:@"discount_ratio"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.campaignPrice]
                   forKey:@"campaign_price"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.taxRate]
                   forKey:@"tax_rate"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.taxPrice]
                   forKey:@"tax_price"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.taxExcludedPrice]
                   forKey:@"tax_excluded_price"];
}

@end
