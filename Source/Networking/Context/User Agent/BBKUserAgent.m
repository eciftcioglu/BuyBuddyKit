// BBKUserAgent.m
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

#import "BBKUserAgent.h"

#include "BuyBuddyKit.h"
#include <sys/utsname.h>
#import <sys/sysctl.h>

#if TARGET_OS_OSX
static const char *SysInfoTypeSpecifier = "hw.model";

static NSString *GetSysInfoByName(const char *typeSpecifier);
#endif

@implementation BBKUserAgent

- (NSString *)engineName
{
    static NSString *engineName = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        engineName = [NSString stringWithCString:BBKLibraryName
                                        encoding:NSUTF8StringEncoding];
    });
    
    return engineName;
}

- (NSString *)engineVersion
{
    static NSString *engineVersion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        engineVersion = [NSString stringWithCString:(const char *)BBKVersionString
                                           encoding:NSUTF8StringEncoding];
    });
    
    return engineVersion;
}

- (NSString *)engineSystemVersion
{
    static NSString *engineSystemVersion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
#if TARGET_OS_OSX
        engineSystemVersion = [NSProcessInfo processInfo].operatingSystemVersionString;
#elif TARGET_OS_WATCH
        engineSystemVersion = [[WKInterfaceDevice currentDevice] systemVersion];
#else
        engineSystemVersion = [[UIDevice currentDevice] systemVersion];
#endif
    });
    
    return engineSystemVersion;
}

- (NSString *)engineSystemName
{
    static NSString *engineSystemName = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
#if TARGET_OS_OSX
        engineSystemName = @"macOS";
#elif TARGET_OS_WATCH
        engineSystemName = [[WKInterfaceDevice currentDevice] systemName];
#else
        engineSystemName =  [[UIDevice currentDevice] systemName];
#endif
    });
    
    return engineSystemName;
}

- (NSString*)appVersion
{
    static NSString *appVersion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        
        if (!appVersion) {
            appVersion = @"(null)";
        }
    });
    
    return appVersion;
}

- (NSString*)appName
{
    static NSString *appName = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
        
        if (!appName) {
            appName = @"(null)";
        }
    });

    return appName;
}

- (NSString *)model
{
    static NSString *model = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
#if TARGET_OS_OSX
        model = self.deviceFamily;
#elif TARGET_OS_WATCH
        model = [[WKInterfaceDevice currentDevice] model];
#else
        model = [[UIDevice currentDevice] model];
#endif
    });
    
    return model;
}

- (NSString *)networkVersion
{
    static NSString *networkVersion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        networkVersion = [NSString stringWithFormat:@"CFNetwork/%@", [NSBundle bundleWithIdentifier:@"com.apple.CFNetwork"].infoDictionary[@"CFBundleShortVersionString"]];
    });
    
    return networkVersion;
}

- (NSString *)darwinVersion
{
    static NSString *darwinVersion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        struct utsname u;
        int err;
        
        err = uname(&u);
        
        if (err != EXIT_SUCCESS) {
            perror("cannot fetch system information");
            
            abort();
        }
        
        darwinVersion = [NSString stringWithFormat:@"Darwin/%@", [NSString stringWithUTF8String:u.release]];
    });
    
    return darwinVersion;
}

- (NSString *)userAgentString
{
    return [NSString stringWithFormat:@"%@/%@ %@/%@ %@/%@ %@ %@", [self appName], [self appVersion], [self engineName], [self engineVersion], [self engineSystemName], [self engineSystemVersion], [self networkVersion], [self darwinVersion]];
}

#if TARGET_OS_OSX

#pragma mark sysctlbyname utils
- (NSString *)deviceFamily
{
    NSString *hardwareModelValue = [self hardwareModel];
    
    if ([hardwareModelValue hasPrefix:@"Macmini"]) {
        return @"Macmini";
    } else if ([hardwareModelValue hasPrefix:@"MacBookAir"]) {
        return @"MacBookAir";
    } else if ([hardwareModelValue hasPrefix:@"MacBookPro"]) {
        return @"MacBookPro";
    } else if ([hardwareModelValue hasPrefix:@"MacPro"]) {
        return @"MacPro";
    } else if ([hardwareModelValue hasPrefix:@"iMac"]) {
        return @"iMac";
    } else if ([hardwareModelValue hasPrefix:@"MacBook"]) {
        return @"MacBook";
    }
    
    return  @"Unknown";
}

- (NSString *)hardwareModel
{
    return GetSysInfoByName(SysInfoTypeSpecifier);
}

#endif

@end

#if TARGET_OS_OSX

static NSString *GetSysInfoByName(const char *typeSpecifier)
{
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

#endif
