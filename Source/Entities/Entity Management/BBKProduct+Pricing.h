// BBKProduct+Pricing.h
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
#import "BBKTax.h"

@interface BBKProduct (Pricing)

/**
 @name Pricing
 */

/**
 Specifies the current price of the product.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *currentPrice;

/**
 Specifies the price after a discount occurs on the original price
 of that particular product.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *discountedPrice;

/**
 Specifies the price of the product before a discount had occured.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *originalPrice;

/**
 Specifies the ratio of the discount made on the initial price of the product.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *discountRatio;

/**
 Specifies the campaign price of the product.
 If this property is not `nil`, it means the product is currently included
 in a campaign.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *campaignPrice;

/**
 Specifies tax rate applied to the product.
 */
@property (nonatomic, strong, nullable, readonly) BBKTax *tax;

/**
 Specifies the tax price of the product.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *taxPrice;

@end
