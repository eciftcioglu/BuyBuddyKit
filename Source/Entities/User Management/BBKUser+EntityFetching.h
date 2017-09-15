// BBKUser+EntityFetching.h
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

#import "BBKUser.h"
#import "BBKEntityFetching.h"

/**
 A bitmask enumeration for fetching various properties of a user from platform.
 
 `ID` and `email` properties are default and non-null in all `BBKUser` instances.
 */
typedef NS_OPTIONS(NSUInteger, BBKUserFetchingOptions) {
    BBKUserFetchName = 1 << 0,
    BBKUserFetchDateOfBirth = 1 << 1,
    BBKUserFetchAffiliateEmployment = 1 << 2,
    BBKUserFetchBrandEmployment = 1 << 3,
    BBKUserFetchStoreEmployment = 1 << 4,
    BBKUserFetchDepartmentEmployment = 1 << 5,
    BBKUserFetchAffiliateRegistrations = 1 << 6,
    BBKUserFetchBrandRegistrations = 1 << 7,
    BBKUserFetchStoreRegistrations = 1 << 8,
    BBKUserFetchDepartmentRegistrations = 1 << 9,
    BBKUserFetchProductRegistrations = 1 << 10,
    BBKUserFetchDelegateRegistrations = 1 << 11,
    BBKUserFetchRegistrationInformation = 1 << 12
};

@interface BBKUser (EntityFetching) <BBKEntityFetching>

/**
 @name Entity Fetching
 */

/**
 Fetches specified property groups of a `BBKUser` object asynchronously.
 */
- (void)performFetchToObject:(BBKUser * _Nonnull)object
                 withOptions:(BBKUserFetchingOptions)options
                     success:(nullable void (^)(BBKUser * _Nonnull responseObject))success
                     failure:(nullable void (^)(NSError * _Nonnull error))failure;

@end
