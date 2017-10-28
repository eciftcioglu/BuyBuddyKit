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
#import <BBKProductMetaData.h>
#import <BBKPrice.h>
#import <UIKit/UIKit.h>
#import <BBKSerialization.h>

/**
 `BBKProduct` object represents the response model which should be used to represent either a product returned from the BuyBuddy platform or a product which will be uploaded to the BuyBuddy platform.
 
 */
@interface BBKProduct : NSObject <BBKSerialization>

/**
 Specifies the Hitag compiled identifier matched with this product in the *BuyBuddy* platform.
 */
@property (nonatomic, strong, nullable, readwrite) NSString *hitagCompiledId;

/**
 Specifies the Hitag identifier matched with this product in the *BuyBuddy* platform.
 */
@property (nonatomic, readwrite) NSInteger hitagId;

/**
 Specifies the campaign identities applied to the product in the *BuyBuddy* platform.
 */
@property (nonatomic, strong, nullable, readwrite) NSArray *appliedCampaignIds;

/**
 Specifies the products name.
 */
@property (nonatomic, strong, nullable, readwrite) NSString *name;

/**
 Specifies the BBKProduct identity in the *BuyBuddy* platform.
 */
@property (nonatomic, readwrite) NSInteger productId;

/**
 Specifies the products metadata which is a custom data type containing multiple properties.For more info on this type inspect BBKProductMetaData interface.
 */
@property (nonatomic, strong, nullable, readwrite) BBKProductMetaData *metaData;

/**
 Specifies the url where the product image can be fetched.
 */
@property (nonatomic, strong, nullable, readwrite) NSString *imageURL;

/**
 Specifies the products actual image retrieved from the previous property imageURL.
 */
@property (nonatomic, strong, nullable,readwrite) UIImage *realImage;

/**
 Specifies the products description.
 */
@property (nonatomic, strong, nullable, readwrite) NSString *productDescription;

/**
 Specifies the products price which is a custom data type containing multiple properties.For more info on this type inspect
 BBKProductMetaData interface.
 */
@property (nonatomic, strong, nullable, readwrite) BBKPrice *price;


- (instancetype _Nullable )initWithhitagCompiledId:(NSString * _Nullable)hitagCompiledId
                                           hitagId:(NSInteger)hitagId
                                              name:(NSString *_Nullable)name
                                         productId:(NSInteger)productId
                                          metaData:(BBKProductMetaData *_Nullable)metaData
                                          imageURL:(NSString *_Nullable)imageURL
                                productDescription:(NSString *_Nullable)productDescription
                                             price:(BBKPrice *_Nullable)price;

@end
