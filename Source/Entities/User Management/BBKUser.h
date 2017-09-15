// BBKUser.h
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

NS_ASSUME_NONNULL_BEGIN

/**
 The `BBKUser` model class represents a user registered to the platform.
 
 Every single user in the platform could be represented as instances of this class, directly.
 There is no distriction between different types of platform users (i.e. customers, managers,
 administrators), all belong to the same class.
 
 ### Identification of a user
 
 Since `BBKUser` objects provided by this software development kit are proxies of the objects found
 in platform, you might need to fetch the same user repeatedly in various contexts.
 Sometimes those contexts might concur with each other, ultimately you might have two instances
 proxying representation of the same entity in the platform.
 You may compare two instances with their instance method `-isEqualToUser:`, which will provide you a
 identifier-based comparison.
 This ensures that those two objects refer to the same entity in the platform, however it does not
 guarantee the validity of the information.
 
 ### Permissions
 
 Due to the nature of the APIs, you will need to perform operations on the platform and every 
 operation is performed on behalf of our web services, hence it is tested against an access
 control system.
 
 Every user might be bound to a permission set, or not. Users without permission sets are not able
 to pass any authorization check on our APIs. Users with permission sets are challenged to be
 eligible to access & mutate some entity, by resolving their *permission*s.
 
 Operations failed due to the access control layer raise `NSException` instances and you should not
 try to catch those exceptions, since they will happen regardless of the time, unless you are not
 being granted a new permission set.
 */
@interface BBKUser : NSObject

/**
 @name Identification
 */

/**
 Specifies database identifier of the user.
 */
@property (nonatomic, strong, nonnull, readonly) NSNumber *ID;

/**
 Specifies email of the user. This field refers to 'BuyBuddy ID' in most of the documentation.
 */
@property (nonatomic, strong, nonnull, readonly) NSString *email;

/**
 Context of the user if it is bound.
 */
@property (nonatomic, weak, nullable, readonly) id boundContext;

/// :nodoc:
- (instancetype _Nonnull)initWithID:(NSNumber * _Nonnull)ID
                              email:(NSString * _Nonnull)email
                      bindToContext:(id _Nullable)context NS_DESIGNATED_INITIALIZER;

/// :nodoc:
- (instancetype _Nonnull)initWithID:(NSNumber * _Nonnull)ID
                              email:(NSString * _Nonnull)email;

@end

NS_ASSUME_NONNULL_END

#import "BBKUser+FoundationConformance.h"
#import "BBKUser+RegistrationInformation.h"
#import "BBKUser+PersonalInformation.h"
#import "BBKUser+EmploymentInformation.h"
#import "BBKUser+EmploymentRegistry.h"
#import "BBKUser+AccessControl.h"
#import "BBKUser+Delegation.h"
#import "BBKUser+DelegationRegistry.h"
#import "BBKUser+AuthenticationPreferences.h"
#import "BBKUser+EntityFetching.h"
