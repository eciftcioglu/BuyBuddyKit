// BBKProduct+Metadata.h
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

@interface BBKProduct (Metadata)

/**
 @name Metadata
 */

/**
 Specifies the products name.
 */
@property (nonatomic, strong, nullable, readwrite) NSString *name;

/**
 Specifies the products description.
 */
@property (nonatomic, strong, nullable, readwrite) NSString *productDescription;

/**
 Specifies the products color.
 */
#if TARGET_OS_IOS
@property (nonatomic, strong, nullable, readonly) UIColor *color;
#elif TARGET_OS_OSX
@property (nonatomic, strong, nullable, readonly) NSColor *color;
#endif

/**
 Specifies the products size.
 */
@property (nonatomic, strong, nullable, readonly) NSString *size;

/**
 Specifies the products code.
 */
@property (nonatomic, strong, nullable, readonly) NSString *code;

/**
 Specifies the products image.
 */
#if TARGET_OS_IOS
@property (nonatomic, strong, nullable, readwrite) UIImage *image;
#elif TARGET_OS_OSX
@property (nonatomic, strong, nullable, readwrite) NSImage *image;
#endif

@end
