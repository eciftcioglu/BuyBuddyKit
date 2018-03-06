// BuyBuddyKit.h
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//               2016-2018 BuyBuddy Elektronik Güvenlik Bilişim Reklam Telekomünikasyon Sanayi ve Ticaret Limited Şirketi ( https://www.buybuddy.co/ )
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
#import <Availability.h>

//! Project version number for BuyBuddyKit.
FOUNDATION_EXPORT double BBKVersionNumber;

//! Project version string for BuyBuddyKit.
FOUNDATION_EXPORT const unsigned char BBKVersionString[];

#ifndef _BUYBUDDYKIT_
#define _BUYBUDDYKIT_

#import "Entities/User Management/BBKUser.h"
#import "Networking/Context/Authentication/Passphrase/BBKPassphrase.h"
#import "Serialization/BBKEntitySerialization.h"
#import "Networking/Context/Connection/Rate Limiting/BBKQuotaContext.h"
#import "Networking/Context/Connection/Reporting/BBKIOMetricsRepository.h"
#import "Networking/Context/Connection/BBKHTTPSessionManager.h"

#if !TARGET_OS_WATCH
#import "Networking/Reachability/BBKNetworkReachabilityManager.h"
#endif

#if !TARGET_OS_WATCH && !TARGET_OS_TVOS
#import "Networking/Context/Authentication/Keychain/BBKKeychainPersistenceCoordinator.h"
#endif

#endif
