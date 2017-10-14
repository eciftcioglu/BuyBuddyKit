// BBKConnectionContext.m
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

#import "BBKConnectionContext.h"
#import "BBKRequestID.h"

#pragma mark - Exported symbols

NSString * const BBKConnectionContextRequestIDHeaderLabel = @"X-BuyBuddy-Request-ID";
NSString * const BBKConnectionContextDispatchQueueLabel = @"com.buybuddy.buybuddykit.connectionContextQueue";
BOOL BBKConnectionContextDispatchQueueForceConcurrent = NO;

static dispatch_queue_t BBKGetConnectionDispatchQueue();
static NSURLSessionConfiguration *BBKGetConfigurationWithPreference(BBKConnectionContextSessionPreference preference);
static void BBKScaffoldConfigurationObject(NSURLSessionConfiguration *configuration);

/*
 Branch prediction helpers of LLVM Branch Weight Metadata.
 */
#define __likely(arg) __builtin_expect(!!(arg), 1)
#define __unlikely(arg) __builtin_expect(!!(arg), 0)

#pragma mark - Class interfaces

@interface BBKConnectionContext ()

@property (nonatomic, weak, nullable, readwrite) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong, nullable, readwrite) NSOperationQueue *operationQueue;
@property (nonatomic, strong, nullable, readwrite) NSURLSession *managedSession;
@property (nonatomic, readwrite) BBKConnectionContextRemoteAction remoteAction;

- (NSString * _Nullable)HTTPMethod;

@end

@interface BBKConnectionContext (Internals)

+ (NSURLSessionConfiguration *)defaultSessionConfiguration;
+ (NSURLSessionConfiguration *)secureEphemeralSessionConfiguration;
+ (NSURLSessionConfiguration *)insecureEphemeralSessionConfiguration;

@end

@implementation BBKConnectionContext

#pragma mark - Instantiation

- (instancetype)initWithURL:(NSURL *)URL
               remoteAction:(BBKConnectionContextRemoteAction)action
          sessionPreference:(BBKConnectionContextSessionPreference)preference
{
    self = [super init];
    
    if (self) {
        //  Initialization of the ivars
        _configuration = BBKGetConfigurationWithPreference(preference);
        _operationQueue = [[NSOperationQueue alloc] init];
        _managedSession = [NSURLSession sessionWithConfiguration:self.configuration
                                                        delegate:self
                                                   delegateQueue:self.operationQueue];
        _URL = URL;
        _remoteAction = action;
        
        //  Specialization of the ivars
        [_operationQueue setUnderlyingQueue:BBKGetConnectionDispatchQueue()];
    }
    
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL
               remoteAction:(BBKConnectionContextRemoteAction)action
{
    return [self initWithURL:URL
                remoteAction:action
           sessionPreference:BBKConnectionContextSessionPreferenceDefault];
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

#pragma mark - NSURLSessionDelegate conformance

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error
{
#warning Not implemented.
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition,
                             NSURLCredential * _Nullable))completionHandler
{
#warning Not implemented.
}

#pragma mark - Accessors / mutators

- (NSString *)HTTPMethod
{
    return BBKHTTPMethodNSStringFromRemoteAction(self.remoteAction);
}

@end

@implementation BBKConnectionContext (Internals)

#pragma mark - Flyweight implementations

+ (NSURLSessionConfiguration *)defaultSessionConfiguration
{
    static NSURLSessionConfiguration *defaultConfiguration = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    });
    
    BBKScaffoldConfigurationObject(defaultConfiguration);
    
    return defaultConfiguration;
}

+ (NSURLSessionConfiguration *)secureEphemeralSessionConfiguration
{
    static NSURLSessionConfiguration *ephemeralConfiguration = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        ephemeralConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    });
    
    BBKScaffoldConfigurationObject(ephemeralConfiguration);
    
    return ephemeralConfiguration;
}

+ (NSURLSessionConfiguration *)insecureEphemeralSessionConfiguration
{
    static NSURLSessionConfiguration *ephemeralConfiguration = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        ephemeralConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    });
    
    BBKScaffoldConfigurationObject(ephemeralConfiguration);
    
    return ephemeralConfiguration;
}

@end

#pragma mark - Dispatch queue handling

static dispatch_queue_t BBKGetConnectionDispatchQueue()
{
    static dispatch_queue_t dispQueue;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dispatch_queue_attr_t attr;
    
        if (__unlikely(BBKConnectionContextDispatchQueueForceConcurrent)) {
            attr = DISPATCH_QUEUE_CONCURRENT;
        } else {
            attr = DISPATCH_QUEUE_SERIAL;
        }
        
        dispQueue = dispatch_queue_create([BBKConnectionContextDispatchQueueLabel cStringUsingEncoding:NSASCIIStringEncoding], attr);
    });
    
    return dispQueue;
}

static NSURLSessionConfiguration *BBKGetConfigurationWithPreference(BBKConnectionContextSessionPreference preference)
{
    switch (preference) {
        case BBKConnectionContextSessionPreferenceDefault:
            return [BBKConnectionContext defaultSessionConfiguration];
        case BBKConnectionContextSessionPreferenceSecureEphemeral:
            return [BBKConnectionContext secureEphemeralSessionConfiguration];
        case BBKConnectionContextSessionPreferenceInsecureEphemeral:
            return [BBKConnectionContext insecureEphemeralSessionConfiguration];
    }
}

static void BBKScaffoldConfigurationObject(NSURLSessionConfiguration *configuration)
{
    NSMutableDictionary *commonHeaders = [[NSMutableDictionary alloc] init];
    BBKRequestID *requestID = [BBKRequestID requestID];
    
    [commonHeaders setObject:[requestID requestIDString]
                      forKey:BBKConnectionContextRequestIDHeaderLabel];
    
    [configuration setHTTPAdditionalHeaders:commonHeaders];
}















