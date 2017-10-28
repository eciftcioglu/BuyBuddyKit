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
#import <Foundation/Foundation.h>
#import <BBKSerialization.h>

/**
 `BBKPrice` object represents the response model which should be used to represent the price object contained inside the BBKProduct object.
 
 */
@interface BBKPrice : NSObject <BBKSerialization>

/**
 Specifies the current price of the product.
 */
@property (nonatomic, readwrite) float currentPrice;

/**
 Specifies the price after a discount occurs on the originial price of the product.
 */
@property (nonatomic, readwrite) float discountPrice;

/**
 Specifies the price of the product before a discount had occured.
 */
@property (nonatomic, readwrite) float oldPrice;

/**
 Specifies the ratio of the discount made on the initial price of the product.
 */
@property (nonatomic, readwrite) float discountRatio;

/**
 Specifies the campaign price of the product.If this property is not nil,It means the product is currently included in a campaign.
 */
@property (nonatomic, readwrite) float campaignPrice;

/**
 Specifies the tax rate of the product.
 */
@property (nonatomic, readwrite) float taxRate;

/**
 Specifies the tax price of the product.
 */
@property (nonatomic, readwrite) float taxPrice;

/**
 Specifies the price of the product without the taxes.
 */
@property (nonatomic, readwrite) float taxExcludedPrice;

- (instancetype _Nullable )initWithcurrentPrice:(float)currentPrice
                                  discountPrice:(float)discountPrice
                                       oldPrice:(float)oldPrice
                                  discountRatio:(float)discountRatio
                                  campaignPrice:(float)campaignPrice
                                        taxRate:(float)taxRate
                                       taxPrice:(float)taxPrice
                               taxExcludedPrice:(float)taxExcludedPrice;

@end
