// BBKConnectionContext.h
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

typedef NS_ENUM(NSUInteger, BBKConnectionContextSessionPreference) {
    BBKConnectionContextSessionPreferenceDefault,
    BBKConnectionContextSessionPreferenceSecureEphemeral,
    BBKConnectionContextSessionPreferenceInsecureEphemeral
};

typedef NS_ENUM(NSUInteger, BBKConnectionContextRemoteAction) {
    BBKConnectionContextRemoteActionIndex,
    BBKConnectionContextRemoteActionShow,
    BBKConnectionContextRemoteActionCreate,
    BBKConnectionContextRemoteActionUpdate,
    BBKConnectionContextRemoteActionDelete
};

NS_ASSUME_NONNULL_BEGIN

/**
 A `BBKConnectionContext` object handles data transfer operation performed with
 HTTP connection established to platform services.
 */
@interface BBKConnectionContext : NSObject <NSURLSessionDelegate>

/**
 @name Instantiation
 */

/**
 Initializes a `BBKConnectionContext` object with the given URL, action and
 session preferences.
 
 @param URL The URL to connect.
 @param action The action connection attempts to perform.
 @param preference Session preference regarding redirections, caching etc.
 */
- (instancetype _Nonnull)initWithURL:(NSURL * _Nonnull)URL
                        remoteAction:(BBKConnectionContextRemoteAction)action
                   sessionPreference:(BBKConnectionContextSessionPreference)preference NS_DESIGNATED_INITIALIZER;

/**
 Initializes a `BBKConnectionContext` object with given URL, action and
 default session preferences.
 
 @param URL The URL to connect.
 @param action The action connection attempts to perform.
 */
- (instancetype _Nonnull)initWithURL:(NSURL * _Nonnull)URL
                        remoteAction:(BBKConnectionContextRemoteAction)action;

/**
 @name Session Behavior
 */

/**
 Configuration object currently used by session.
 */
@property (nonatomic, weak, nullable, readonly) NSURLSessionConfiguration *configuration;

/**
 @name Connection Properties
 */

/**
 The `NSURL` object the underlying `NSURLSession` instance connects to.
 */
@property (nonatomic, strong, nullable, readonly) NSURL *URL;

@end

/**
 @name Constants
 */

/**
 Label of the intrinsic dispatch queue used by `BBKConnectionContext` objects.
 */
FOUNDATION_EXPORT NSString * const BBKConnectionContextDispatchQueueLabel;

/**
 The label of the HTTP request header carrying a client-side identifiable
 random request identifier.
 */
FOUNDATION_EXPORT NSString * const BBKConnectionContextRequestIDHeaderLabel;

/**
 A boolean value determining whether underlying dispatch queue of the connection
 context is going to be concurrent or not.
 
 Defaults to `NO`.
 Do not change the value unless you really know what you are doing.
 */
FOUNDATION_EXPORT BOOL BBKConnectionContextDispatchQueueForceConcurrent;

NS_ASSUME_NONNULL_END

#include "BBKConnectionContext+DataDelegate.h"
#include "BBKConnectionContext+DownloadDelegate.h"
#include "BBKConnectionContext+RemoteAction.h"
