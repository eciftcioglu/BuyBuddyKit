// BBKEntitySerialization.h
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
#import "BBKSerialization.h"

/**
 Performs serialization of entity object to JSON and deserialization of JSON
 to entity objects back.
 */
@interface BBKEntitySerialization : NSJSONSerialization

/**
 @name Creating Entity with JSON Data
 */

/**
 Returns the entity object from given JSON data.
 
 @param data The JSON data to deserialize.
 @param className The struct representing class of the entity.
 @param errorPtr A pointer to `NSError *`, which is set when error occurred.
 */
+ (id _Nullable)entityWithData:(NSData * _Nonnull)data
                      keyClass:(Class _Nonnull)className
                         error:(NSError * __autoreleasing _Nullable * _Nullable)errorPtr;

/**
 @name Creating JSON Data
 */

/**
 Returns JSON data from given entity object.
 
 @param entity The entity object to serialize.
 @param options Options of serialization.
 @param errorPtr A pointer to `NSError *`, which is set when error occurred.
 */
+ (NSData * _Nullable)dataWithEntity:(id<BBKSerialization> _Nonnull)entity
                             options:(NSJSONWritingOptions)options
                               error:(NSError * __autoreleasing _Nullable * _Nullable)errorPtr;

@end
