// BBKUser+AuthenticationPreferences.h
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

@interface BBKUser (AuthenticationPreferences)

/**
 @name Authentication Preferences
 */

/**
 Specifies the two-factor authentication preference of the user as a boolean value.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *usesTwoFactorAuthentication;

/**
 A boolean value indicating preference of a user to authenticate every time, without storing 
 passphrase information.
 
 ## Caveat
 
 If this property is a truthy value, the underlying connection context will store the passphrase 
 as encrypted in memory, but it will not persist the data in the keychain.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber *requiresLoginEverytime;

@end
