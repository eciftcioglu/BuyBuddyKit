// BBKKeychainPersistenceCoordinator.m
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

#import "BBKKeychainPersistenceCoordinator.h"

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Security/Security.h>

#if TARGET_OS_OSX
#import <CoreServices/CoreServices.h>
#elif TARGET_OS_IOS
#import <CFNetwork/CFNetwork.h>
#endif

UInt8 const BBKKeychainStorageKey[] = "com.buybuddy.buybuddykit.Keychain\0";
#if TARGET_OS_MAC
NSString * const BBKKeychainStorageErrorUserInfoKey = @"SecCopyErrorMessageString";
#endif
static void RaiseExceptionIfStatusIsAnError(const OSStatus *status);
static void ExecuteDynBlockAtomic(_Nonnull dispatch_block_t blk);
static void ExecuteStaBlockAtomic(_Nonnull dispatch_block_t blk);

@interface BBKKeychainPersistenceCoordinator ()

@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *keychainData;
@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *query;

@property (nonatomic, strong, nullable, readwrite) NSDate *lastWriteTimestamp;
@property (nonatomic, strong, nullable, readwrite) NSDate *lastReadTimestamp;

@end

@interface BBKKeychainPersistenceCoordinator (Internals)

//  The following two methods translate dictionaries between the format used by
//  the library (NSString *) and the Keychain Services API:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

- (void)writeToKeychain;

@end

@implementation BBKKeychainPersistenceCoordinator

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (BOOL)persistData:(NSData *)data
             ofType:(BBKKeychainDataType)type
             forKey:(NSString *)keyString
              error:(NSError * _Nullable __autoreleasing *)errPtr
{
    NSString * const BBKKeychainStorageItemLabel = @"BuyBuddy Credentials";
    NSString * const BBKKeychainStorageItemDescription = @"Stored user credentials to authenticate in BuyBuddy platform";
    NSString * const BBKKeychainStorageNullField = @"(null)";
    NSString * const BBKKeychainStorageComment = @"Stored credentials with username/email and password tuple.";
    NSString * const BBKKeychainStorageServiceName = @"BuyBuddy";
}

- (NSData *)loadDataForKey:(NSString *)keyString
                     error:(NSError * _Nullable __autoreleasing *)errPtr
{
    
}

@end

@implementation BBKKeychainPersistenceCoordinator (Internals)

#pragma mark - Conversion

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    //  Length of the unique key
    size_t stringLength = strlen((const char *)BBKKeychainStorageKey);
    NSData *keychainItemID = [NSData dataWithBytes:BBKKeychainStorageKey
                                            length:stringLength];
    
    //  Add the keychain item class and the generic attribute
    [returnDictionary setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword
                         forKey:(__bridge id)kSecClass];
    
    //  Convert the password NSString to NSData to fit the API paradigm
    NSString *passwordString = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
    
    [returnDictionary setObject:[passwordString dataUsingEncoding:NSUTF8StringEncoding]
                         forKey:(__bridge id)kSecValueData];
    
    return returnDictionary;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    //  CAVEAT
    //  This method must be called with a properly populated dictionary containing all the right
    //  key/value pairs for the keychain item.
    
    //  Create a return dictionary populated with the attributes
    NSMutableDictionary *returnDictionary = [dictionaryToConvert mutableCopy];
    
    //  To acquire the password data from the keychain item, first add the search key and class
    //  attribute required to obtain the password
    [returnDictionary setObject:(__bridge id)kCFBooleanTrue
                         forKey:(__bridge id)kSecReturnData];
    [returnDictionary setObject:(__bridge id)kSecClassGenericPassword
                         forKey:(__bridge id)kSecClass];
    [returnDictionary removeObjectForKey:(__bridge id)kSecAttrLabel];
    [returnDictionary removeObjectForKey:(__bridge id)kSecAttrModificationDate];
    [returnDictionary removeObjectForKey:(__bridge id)kSecAttrDescription];
    [returnDictionary removeObjectForKey:(__bridge id)kSecAttrComment];
    [returnDictionary removeObjectForKey:(__bridge id)kSecAttrService];
    [returnDictionary removeObjectForKey:(__bridge id)kSecAttrCreationDate];
    
    ExecuteDynBlockAtomic(^{
        //  Then call Keychain Services to get the password
        CFDataRef passwordData = NULL;
        
        OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary,
                                                   (CFTypeRef *)&passwordData);
        
        //  Remove the data return key, we don't need it anymore
        [returnDictionary removeObjectForKey:(__bridge id)kSecReturnData];
        
        //  Convert the password to an NSString and add it to the return dictionary
        NSString *password = [[NSString alloc] initWithBytes:[(__bridge NSData * _Nonnull)passwordData bytes]
                                                      length:[(__bridge NSData * _Nonnull)passwordData length]
                                                    encoding:NSUTF8StringEncoding];
        
        [returnDictionary setObject:password
                             forKey:(__bridge id)kSecValueData];
        
        //  Release password data if it exists to ensure strong exception guarantee
        if (passwordData) {
            CFRelease(passwordData);
        }
        
        RaiseExceptionIfStatusIsAnError(&keychainErr);
    });
    
    ExecuteStaBlockAtomic(^{
        self.lastReadTimestamp = [[NSDate alloc] init];
    });
    
    return returnDictionary;
}

- (void)writeToKeychain
{
    CFMutableDictionaryRef attributes = NULL;
    NSMutableDictionary *updateItem = nil;
    
    __block OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)self.query,
                                                       (CFTypeRef *)&attributes);
    
    //  If the keychain item does not exist, add it
    if (keychainErr == errSecItemNotFound) {
        //  No previous item found, add the new item.
        //
        //  The new value was added to the keychainData dictionary in the
        //  persistPassphraseWithSuccess:failure: routine, and the other values were added to the
        //  keychainData dictionary previously.
        //
        //  No pointer to the newly-added items is needed, so pass NULL for the second parameter
        NSMutableDictionary *persistedDict = [[self dictionaryToSecItemFormat:self.keychainData] mutableCopy];
        
        [persistedDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        [persistedDict removeObjectForKey:(__bridge id)kSecAttrComment];
        [persistedDict removeObjectForKey:(__bridge id)kSecAttrService];
        [persistedDict removeObjectForKey:(__bridge id)kSecAttrDescription];
        
        //  Execute operation atomically
        ExecuteDynBlockAtomic(^{
            //  Passing NULL as result is not required
            keychainErr = SecItemAdd((__bridge CFDictionaryRef)persistedDict, nil);
            
            RaiseExceptionIfStatusIsAnError(&keychainErr);
        });
        
        ExecuteStaBlockAtomic(^{
            self.lastWriteTimestamp = [[NSDate alloc] init];
            self.lastReadTimestamp = [[NSDate alloc] init];
        });
    } else {
        RaiseExceptionIfStatusIsAnError(&keychainErr);
        
        updateItem = [NSMutableDictionary dictionaryWithDictionary:(__bridge_transfer NSDictionary * _Nonnull)attributes];
        
        //  First, get the attributes returned from the keychain and add them to the dictionary
        //  that controls the update
        [updateItem setObject:[self.query objectForKey:(__bridge id)kSecClass]
                       forKey:(__bridge id)kSecClass];
        
        //  Finally, set up the dictionary that contains new values for the attributes
        NSMutableDictionary *tempCheck = [self dictionaryToSecItemFormat:self.keychainData];
        
        //  Remove the class, it's not a keychain attribute
        [tempCheck removeObjectForKey:(__bridge id)kSecClass];
        
        //  Execute operation atomically
        ExecuteDynBlockAtomic(^{
            //  You can update only a single keychain item at a time
            keychainErr = SecItemUpdate((__bridge CFDictionaryRef)updateItem,
                                        (__bridge CFDictionaryRef)tempCheck);
            
            RaiseExceptionIfStatusIsAnError(&keychainErr);
        });
        
        ExecuteStaBlockAtomic(^{
            self.lastWriteTimestamp = [[NSDate alloc] init];
            self.lastReadTimestamp = [[NSDate alloc] init];
        });
    }
}

@end

static id SecClassForKeychainDataType(BBKKeychainDataType type)
{
    switch (type) {
        case BBKKeychainDataTypeGenericPassword:
            return (__bridge id)kSecClassGenericPassword;

        case BBKKeychainDataTypeCryptographicKey:
            return (__bridge id)kSecClassKey;
            
        case BBKKeychainDataTypeCertificate:
            return (__bridge id)kSecClassCertificate;
    }
}

static void RaiseExceptionIfStatusIsAnError(const OSStatus *status)
{
    NSCAssert(status != NULL, @"parameter status should not be NULL");
    
    if (*status != noErr) {
#if TARGET_OS_OSX
        NSDictionary *userInfo = @{BBKKeychainStorageErrorUserInfoKey: (__bridge NSString *)SecCopyErrorMessageString(*status, NULL)};
#else
        NSDictionary *userInfo = nil;
#endif
        
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                             code:*status
                                         userInfo:userInfo];
        
        [NSException raise:NSInternalInconsistencyException
                    format:@"Persistence coordinator encountered an error: %@", error.description];
        
        return;
    }
}

static void ExecuteDynBlockSync(_Nonnull dispatch_block_t blk,
                                NSLock * _Nonnull lock)
{
    NSCAssert(blk != NULL, @"parameter blk should not be NULL");
    NSCAssert(lock != nil, @"parameter lck should not be nil");
    
    [lock lock];
    @try {
        blk();
    } @finally {
        [lock unlock];
    }
}

static void ExecuteDynBlockAtomic(_Nonnull dispatch_block_t blk)
{
    NSCAssert(blk != NULL, @"parameter blk should not be NULL");
    
    static NSLock *mutex = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        mutex = [[NSLock alloc] init];
    });
    
    ExecuteDynBlockSync(blk, mutex);
}

static void ExecuteStaBlockSync(_Nonnull dispatch_block_t blk,
                                _Nonnull dispatch_semaphore_t dsema)
{
    NSCAssert(blk != NULL, @"parameter blk should not be NULL");
    NSCAssert(dsema != NULL, @"parameter dsema should not be NULL");
    
    dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
    @try {
        blk();
    } @finally {
        dispatch_semaphore_signal(dsema);
    }
}

static void ExecuteStaBlockAtomic(_Nonnull dispatch_block_t blk)
{
    NSCAssert(blk != NULL, @"parameter blk should not be NULL");
    
    static dispatch_semaphore_t semaphore;
    static dispatch_once_t onceToken;
    
    //  Lazily initialize the mutex if not initialized
    dispatch_once(&onceToken, ^{
        semaphore = dispatch_semaphore_create(1ULL);
    });
    
    ExecuteStaBlockSync(blk, semaphore);
}
