// BBKNetworkReachabilityManager.m
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

#import "BBKNetworkReachabilityManager.h"

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#ifndef CLANG_INLINE_NEXT
#define CLANG_INLINE_NEXT
#endif

#ifndef NIL_FLAG
#define NIL_FLAG 0
#endif

#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
#define BBK_INET_V6_AVAILABLE
#elif (defined(BBK_INET_V6_AVAILABLE))
#undef BBK_INET_V6_AVAILABLE
#endif

NSString * const BBKNetworkingReachabilityDidChangeNotification = @"com.buybuddy.networking.reachability.change";
NSString * const BBKNetworkingReachabilityNotificationStatusItem = @"BBKNetworkingReachabilityNotificationStatusItem";

typedef void (^BBKNetworkReachabilityStatusBlock)(BBKNetworkReachabilityStatus status);

NSString * _Nonnull BBKStringFromNetworkReachabilityStatus(BBKNetworkReachabilityStatus status);
static BBKNetworkReachabilityStatus BBKNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags);
static void BBKPostReachabilityStatusChange(SCNetworkReachabilityFlags flags,
                                            BBKNetworkReachabilityStatusBlock block);
static void BBKNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target,
                                           SCNetworkReachabilityFlags flags,
                                           void *info);
static const void * BBKNetworkReachabilityRetainCallback(const void *info);
static void BBKNetworkReachabilityReleaseCallback(const void *info);

@interface BBKNetworkReachabilityManager ()

@property (nonatomic, assign, readonly, nonnull) SCNetworkReachabilityRef reachability;
@property (nonatomic, assign, readwrite) BBKNetworkReachabilityStatus networkReachabilityStatus;
@property (nonatomic, copy, readwrite) BBKNetworkReachabilityStatusBlock networkReachabilityStatusBlock;

@end

@implementation BBKNetworkReachabilityManager

+ (id)sharedManager
{
    static BBKNetworkReachabilityManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

#pragma mark - Object lifecycle

- (instancetype)init
{
    self = [super init];
    
    if (self) {
#ifdef BBK_INET_V6_AVAILABLE
        struct sockaddr_in6 address;
        bzero(&address, sizeof(address));
        address.sin6_len = sizeof(address);
        address.sin6_family = AF_INET6;
#else
        struct sockaddr_in address;
        bzero(&address, sizeof(address));
        address.sin_len = sizeof(address);
        address.sin_family = AF_INET;
#endif
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&address);
        _reachability = CFRetain(reachability);
        self.networkReachabilityStatus = BBKNetworkReachabilityStatusUnknown;
    }
    
    return self;
}

- (void)dealloc
{
    [self stopPolling];
    
    if (_reachability != NULL) {
        CFRelease(_reachability);
    }
}

#pragma mark - Polling

- (void)startPolling
{
    [self stopPolling];
    
    if (self.reachability) {
        __weak __typeof(self) weakRef = self;
        
        BBKNetworkReachabilityStatusBlock blk = ^(BBKNetworkReachabilityStatus status) {
            __strong __typeof(weakRef) strongRef = weakRef;
            
            strongRef.networkReachabilityStatus = status;
            
            if (strongRef.networkReachabilityStatusBlock) CLANG_INLINE_NEXT {
                strongRef.networkReachabilityStatusBlock(status);
            }
        };
        
        SCNetworkReachabilityContext ctx = {0, (__bridge void *)blk, BBKNetworkReachabilityRetainCallback, BBKNetworkReachabilityReleaseCallback, NULL};
        SCNetworkReachabilitySetCallback(self.reachability, BBKNetworkReachabilityCallback, &ctx);
        SCNetworkReachabilityScheduleWithRunLoop(self.reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NIL_FLAG), ^{
            SCNetworkReachabilityFlags flags;
            
            if (SCNetworkReachabilityGetFlags(self.reachability, &flags)) {
                BBKPostReachabilityStatusChange(flags, blk);
            }
        });
    }
}

- (void)stopPolling
{
    if (self.reachability != NULL) {
        SCNetworkReachabilityUnscheduleFromRunLoop(self.reachability, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    }
}

#pragma mark - Localization

- (NSString *)localizedNetworkReachabilityStatusString
{
    return BBKStringFromNetworkReachabilityStatus(self.networkReachabilityStatus);
}


#pragma mark - Accessors & mutators
- (void)setReachabilityStatusChangeBlock:(void (^)(BBKNetworkReachabilityStatus status))blk
{
    self.networkReachabilityStatusBlock = blk;
}

- (BOOL)isReachable
{
    return [self isReachableViaWWAN] || [self isReachableViaWiFi];
}

- (BOOL)isReachableViaWWAN
{
    return self.networkReachabilityStatus == BBKNetworkReachabilityStatusReachableViaWWAN;
}

- (BOOL)isReachableViaWLAN
{
    return self.networkReachabilityStatus == BBKNetworkReachabilityStatusReachableViaWLAN;
}

@end

NSString * _Nonnull BBKStringFromNetworkReachabilityStatus(BBKNetworkReachabilityStatus status)
{
    switch (status) {
        case BBKNetworkReachabilityStatusNotReachable:
            return NSLocalizedStringFromTable(@"Not Reachable", @"AFNetworking", nil);
        case BBKNetworkReachabilityStatusReachableViaWWAN:
            return NSLocalizedStringFromTable(@"Reachable via WWAN", @"AFNetworking", nil);
        case BBKNetworkReachabilityStatusReachableViaWLAN:
            return NSLocalizedStringFromTable(@"Reachable via WiFi", @"AFNetworking", nil);
        case BBKNetworkReachabilityStatusUnknown:
        default:
            return NSLocalizedStringFromTable(@"Unknown", @"AFNetworking", nil);
    }
}

static BBKNetworkReachabilityStatus BBKNetworkReachabilityStatusForFlags(SCNetworkReachabilityFlags flags)
{
    BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkReachabilityFlagsConnectionRequired) != 0);
    BOOL canConnectionAutomatically = (((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) || ((flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0));
    BOOL canConnectWithoutUserInteraction = (canConnectionAutomatically && (flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0);
    BOOL isNetworkReachable = (isReachable && (!needsConnection || canConnectWithoutUserInteraction));
    
    BBKNetworkReachabilityStatus status = BBKNetworkReachabilityStatusUnknown;
    if (isNetworkReachable == NO) {
        status = BBKNetworkReachabilityStatusNotReachable;
    }
#if	TARGET_OS_IPHONE
    else if ((flags & kSCNetworkReachabilityFlagsIsWWAN) != 0) {
        status = BBKNetworkReachabilityStatusReachableViaWWAN;
    }
#endif
    else {
        status = BBKNetworkReachabilityStatusReachableViaWLAN;
    }
    
    return status;
}

/**
 * Queue a status change notification for the main thread.
 *
 * This is done to ensure that the notifications are received in the same order
 * as they are sent. If notifications are sent directly, it is possible that
 * a queued notification (for an earlier status condition) is processed after
 * the later update, resulting in the listener being left in the wrong state.
 */
static void BBKPostReachabilityStatusChange(SCNetworkReachabilityFlags flags,
                                            BBKNetworkReachabilityStatusBlock block)
{
    BBKNetworkReachabilityStatus status = BBKNetworkReachabilityStatusForFlags(flags);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) {
            block(status);
        }
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        NSDictionary *userInfo = @{ BBKNetworkingReachabilityNotificationStatusItem: @(status) };
        
        [notificationCenter postNotificationName:BBKNetworkingReachabilityDidChangeNotification
                                          object:nil
                                        userInfo:userInfo];
    });
}

static void BBKNetworkReachabilityCallback(SCNetworkReachabilityRef __unused target,
                                           SCNetworkReachabilityFlags flags,
                                           void *info)
{
    BBKPostReachabilityStatusChange(flags, (__bridge BBKNetworkReachabilityStatusBlock)info);
}

static const void *BBKNetworkReachabilityRetainCallback(const void *info)
{
    return Block_copy(info);
}

static void BBKNetworkReachabilityReleaseCallback(const void *info)
{
    if (info) {
        Block_release(info);
    }
}
