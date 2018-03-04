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

typedef NS_ENUM(NSUInteger, BBKConnectionContextHTTPMethod) {
    BBKConnectionContextHTTPMethodHEAD,
    BBKConnectionContextHTTPMethodGET,
    BBKConnectionContextHTTPMethodPOST,
    BBKConnectionContextHTTPMethodPUT,
    BBKConnectionContextHTTPMethodPATCH,
    BBKConnectionContextHTTPMethodDELETE,
    BBKConnectionContextHTTPMethodOPTIONS
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
 Initializes a `BBKConnectionContext` object with given session preference configuration.
 
 @param preference Session preference regarding redirections, caching etc.
 */
- (instancetype _Nonnull)initWithSessionPreference:(BBKConnectionContextSessionPreference)preference NS_DESIGNATED_INITIALIZER;

/**
 Initializes a `BBKConnectionContext` object with default session preference configuration.
 */
- (instancetype _Nonnull)init;

/**
 @name Session Behavior
 */

/**
 Configuration object currently used by session.
 */
@property (nonatomic, weak, nullable, readonly) NSURLSessionConfiguration *configuration;

/**
 @name Making Connections
 */

/**
 Performs an HTTP connection to specified URL with a remote action.
 
 @param URL The URL to connect.
 @param action The action connection attempts to perform.
 */
- (void)performConnection:(NSURL * _Nonnull)URL
             remoteAction:(BBKConnectionContextRemoteAction)action;

/**
 Performs an HTTP connection to specified URL with given HTTP method.
 
 @param URL The URL to connect.
 @param method The HTTP method to be used.
 */
- (void)performConnection:(NSURL * _Nonnull)URL
               HTTPMethod:(BBKConnectionContextHTTPMethod)method;

/**
 Performs an HTTP connection to specified URL with given HTTP method as a raw string.
 
 @param URL The URL to connect.
 @param methodString The HTTP method as a string, (i.e. `@"GET"`).
 */
- (void)performConnection:(NSURL * _Nonnull)URL
             methodString:(NSString * _Nonnull)methodString;

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
