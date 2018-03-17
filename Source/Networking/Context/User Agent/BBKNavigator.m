// BBKNavigator.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
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

#import "BBKNavigator.h"

#import "BBKUserAgent.h"
#import "BBKCarrier.h"

@interface BBKNavigator ()

@property (nonatomic, strong, nullable, readwrite) BBKUserAgent *userAgent;
@property (nonatomic, strong, nullable, readwrite) BBKCarrier *carrier;

@end

@implementation BBKNavigator

- (BBKUserAgent *)userAgent
{
    static BBKUserAgent *agent = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        agent = [[BBKUserAgent alloc] init];
    });
    
    return agent;
}

- (BBKCarrier *)carrier
{
    return [BBKCarrier new];
}

- (NSTimeZone *)currentTimeZone
{
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];

    return timeZone;
}

#if TARGET_OS_IPHONE
- (NSString *)AAID
{
    static NSString *aaid = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        aaid = [[[ASIdentifierManager  sharedManager] advertisingIdentifier] UUIDString];
    });
    
    return aaid;
}
#endif

- (NSString *)UUID
{
#if TARGET_OS_OSX
    io_service_t platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault,
                                                              IOServiceMatching("IOPlatformExpertDevice"));
    
    if (!platformExpert) {
        return nil;
    }
    
    CFTypeRef serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert,
                                                                       CFSTR(kIOPlatformUUIDKey),
                                                                       kCFAllocatorDefault,
                                                                       0);
    IOObjectRelease(platformExpert);
    
    if (!serialNumberAsCFString) {
        return nil;
    }
    
    return (__bridge NSString *)(serialNumberAsCFString);
#else
    static NSString *uuid = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    });
    
    return uuid;
#endif
}

@end
