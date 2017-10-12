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

NSString * const BBKConnectionContextDispatchQueueLabel = @"com.buybuddy.buybuddykit.connectionContextQueue";
BOOL BBKConnectionContextDispatchQueueForceConcurrent = NO;

/*
 Branch prediction helpers of LLVM Branch Weight Metadata.
 */
#define __likely(arg) __builtin_expect(!!(arg), 1)
#define __unlikely(arg) __builtin_expect(!!(arg), 0)

static dispatch_queue_t BBKGetConnectionDispatchQueue();

@interface BBKConnectionContext ()

@property (nonatomic, weak, nullable, readwrite) NSURLSessionConfiguration *configuration;
@property (nonatomic, strong, nullable, readwrite) NSOperationQueue *operationQueue;
@property (nonatomic, strong, nullable, readwrite) NSURLSession *managedSession;

@end

@interface BBKConnectionContext (Internals)

- (void)instantiateSessionObject;

@end

@implementation BBKConnectionContext

#pragma mark - Instantiation

+ (instancetype)connectionContextWithDefaultStorage
{
    static NSURLSessionConfiguration *defaultConfiguration = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    });
    
    return [[[self class] alloc] initWithConfiguration:defaultConfiguration];
}

+ (instancetype)connectionContextWithEphemeralStorage
{
    static NSURLSessionConfiguration *ephemeralConfiguration = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        ephemeralConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    });
    
    return [[[self class] alloc] initWithConfiguration:ephemeralConfiguration];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    
    if (self) {
        _configuration = configuration;
        _operationQueue = [[NSOperationQueue alloc] init];
        
        [_operationQueue setUnderlyingQueue:BBKGetConnectionDispatchQueue()];
        
        [self instantiateSessionObject];
    }
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

#pragma mark - NSURLSessionDelegate conformance

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error
{
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition,
                             NSURLCredential * _Nullable))completionHandler
{
    
}

@end

@implementation BBKConnectionContext (Internals)

- (void)instantiateSessionObject
{
    self.managedSession = [NSURLSession sessionWithConfiguration:self.configuration
                                                        delegate:self
                                                   delegateQueue:self.operationQueue];
}

@end

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















