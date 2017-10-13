// BBKCredentialsKeychainPersistenceCoordinator.m
// Copyright (c) 2003-2016 Apple LLC
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

#import "BBKCredentialsKeychainPersistenceCoordinator.h"
#import "BBKCredentials.h"
#import "BBKErrorDomain.h"

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Security/Security.h>

#if TARGET_OS_OSX
#import <CoreServices/CoreServices.h>
#elif TARGET_OS_IOS
#import <CFNetwork/CFNetwork.h>
#endif

UInt8 const BBKCredentialsKeychainStorageKey[] = "com.buybuddy.buybuddykit.Keychain\0";
#if TARGET_OS_MAC
NSString * const BBKCredentialsKeychainStorageErrorUserInfoKey = @"SecCopyErrorMessageString";
#endif
NSString * const BBKCredentialsKeychainStorageItemLabel = @"BuyBuddy Credentials";
NSString * const BBKCredentialsKeychainStorageItemDescription = @"Stored user credentials to authenticate in BuyBuddy platform";
NSString * const BBKCredentialsKeychainStorageNullField = @"(null)";
NSString * const BBKCredentialsKeychainStorageComment = @"Stored credentials with email-password tuple.";
NSString * const BBKCredentialsKeychainStorageServiceName = @"BuyBuddy";
static void RaiseExceptionIfStatusIsAnError(const OSStatus *status);
static void ExecuteDynBlockAtomic(_Nonnull dispatch_block_t blk);
static void ExecuteStaBlockAtomic(_Nonnull dispatch_block_t blk);

NS_ASSUME_NONNULL_BEGIN

@interface BBKCredentialsKeychainPersistenceCoordinator ()

@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *keychainData;
@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *genericPasswordQuery;

@property (nonatomic, strong, nullable, readwrite) NSDate *lastWriteTimestamp;
@property (nonatomic, strong, nullable, readwrite) NSDate *lastReadTimestamp;

@end

@interface BBKCredentialsKeychainPersistenceCoordinator (Internals)

//  The following two methods translate dictionaries between the format used by
//  the library (NSString *) and the Keychain Services API:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

- (void)writeToKeychain;

@end

NS_ASSUME_NONNULL_END

@implementation BBKCredentialsKeychainPersistenceCoordinator

#pragma mark Instantiation

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        //  Initialize keychain search dictionary
        self.genericPasswordQuery = [[NSMutableDictionary alloc] init];
        
        //  Keychain item is a generic password
        [self.genericPasswordQuery setObject:(__bridge id)kSecClassGenericPassword
                                      forKey:(__bridge id)kSecClass];
        
        //  Length of the unique key
        size_t stringLength = strlen((const char *)BBKCredentialsKeychainStorageKey);
        
        //  kSecAttrGeneric attribute is used to store a unique string that is used
        //  to easily identify and find this keychain item. The string is first
        //  converted to an NSData object
        NSData *keychainItemID = [NSData dataWithBytes:BBKCredentialsKeychainStorageKey
                                                length:stringLength];
        
        [self.genericPasswordQuery setObject:keychainItemID
                                      forKey:(__bridge id)kSecAttrGeneric];
        
        //  Return the attributes of the first match only
        [self.genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne
                                      forKey:(__bridge id)kSecMatchLimit];
        
        //  Return the attributes of the keychain item (the password is acquired in
        //  the secItemFormatToDictionary: method)
        [self.genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue
                                      forKey:(__bridge id)kSecReturnAttributes];
        
        //  Initialize the dictionary used to hold return data from the keychain
        CFMutableDictionaryRef outDictionary = NULL;
        
        //  If the keychain item exists, return the attributes of the item
        OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)self.genericPasswordQuery,
                                                   (CFTypeRef *)&outDictionary);
        
        if (keychainErr == noErr) {
            //  Convert the data dictionary into the format used by the library
            self.keychainData = [self secItemFormatToDictionary:(__bridge_transfer NSMutableDictionary *)outDictionary];
        } else if (keychainErr == errSecItemNotFound) {
            [self resetKeychainItem];
            
            //  Release the dictionary if exists
            if (outDictionary) {
                CFRelease(outDictionary);
            }
        } else {
            //  Release the dictionary before raising exception to ensure strong exception-guarantee
            if (outDictionary) {
                CFRelease(outDictionary);
            }
            
            RaiseExceptionIfStatusIsAnError(&keychainErr);
        }
        
        ExecuteStaBlockAtomic(^{
            self.lastReadTimestamp = [[NSDate alloc] init];
        });
    }
    
    return self;
}

#pragma mark - Keychain management

- (void)resetKeychainItem
{
    if (!self.keychainData) {
        //  There is no keychain data, initialize it
        self.keychainData = [[NSMutableDictionary alloc] init];
    } else {
        //  There is keychain data, convert it to the format needed for a query
        NSMutableDictionary *temporaryDictionary = [self dictionaryToSecItemFormat:self.keychainData];
        
        OSStatus keychainErr = SecItemDelete((__bridge CFDictionaryRef)temporaryDictionary);
        
        RaiseExceptionIfStatusIsAnError(&keychainErr);
    }
    
    [self.keychainData setObject:BBKCredentialsKeychainStorageItemLabel
                          forKey:(__bridge id)kSecAttrLabel];
    
    [self.keychainData setObject:BBKCredentialsKeychainStorageItemDescription
                          forKey:(__bridge id)kSecAttrDescription];
    
    [self.keychainData setObject:BBKCredentialsKeychainStorageNullField
                          forKey:(__bridge id)kSecAttrAccount];
    
    [self.keychainData setObject:BBKCredentialsKeychainStorageServiceName
                          forKey:(__bridge id)kSecAttrService];
    
    [self.keychainData setObject:BBKCredentialsKeychainStorageComment
                          forKey:(__bridge id)kSecAttrComment];
    
    [self.keychainData setObject:BBKCredentialsKeychainStorageNullField
                          forKey:(__bridge id)kSecValueData];
}

#pragma mark - Credentials persistence coordination conformance

- (void)persistCredentials:(BBKCredentials *)credentials
                   success:(void (^)(BBKCredentials * _Nonnull))success
                   failure:(void (^)(NSError * _Nonnull))failure
{
    NSAssert(credentials != nil, @"credentials parameter should not be nil");
    
    id password = [self.keychainData objectForKey:(__bridge id)kSecValueData];
    
    if (![password isEqual:credentials.password]) {
        [self.keychainData setObject:credentials.email forKey:(__bridge id)kSecAttrAccount];
        [self.keychainData setObject:credentials.password forKey:(__bridge id)kSecValueData];
        
        [self writeToKeychain];
    }
    
    if (success) success(credentials);
}

- (void)loadCredentialsWithCompletion:(void (^)(BBKCredentials * _Nullable, NSError * _Nullable))completion
{
    NSString *password = [self.keychainData objectForKey:(__bridge id)kSecValueData];
    NSString *email = [self.keychainData objectForKey:(__bridge id)kSecValueData];
    
    if (password) {
        if (completion) completion([[BBKCredentials alloc] initWithEmail:email password:password], nil);
    } else {
        NSError *error = [NSError errorWithDomain:BBKErrorDomain
                                             code:BBKCredentialsKeychainPersistenceCredentialsDoesNotExist
                                         userInfo:nil];
        
        if (completion) completion(nil, error);
    }
}

@end

@implementation BBKCredentialsKeychainPersistenceCoordinator (Internals)

#pragma mark - Conversion

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    //  Length of the unique key
    size_t stringLength = strlen((const char *)BBKCredentialsKeychainStorageKey);
    NSData *keychainItemID = [NSData dataWithBytes:BBKCredentialsKeychainStorageKey
                                            length:stringLength];
    
    //  Add the keychain item class and the generic attribute
    [returnDictionary setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    [returnDictionary setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    
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
    
    __block OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)self.genericPasswordQuery,
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
        NSDictionary *persistedDict = [self dictionaryToSecItemFormat:self.keychainData];
        
        //  Execute operation atomically
        ExecuteDynBlockAtomic(^{
            //  Passing NULL as result is not required
            keychainErr = SecItemAdd((__bridge  CFDictionaryRef)persistedDict, NULL);
            
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
        [updateItem setObject:[self.genericPasswordQuery objectForKey:(__bridge id)kSecClass]
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

static void RaiseExceptionIfStatusIsAnError(const OSStatus *status)
{
    NSCAssert(status != NULL, @"parameter status should not be NULL");
    
    if (*status != noErr) {
#if TARGET_OS_OSX
        NSDictionary *userInfo = @{BBKCredentialsKeychainStorageErrorUserInfoKey: (__bridge NSString *)SecCopyErrorMessageString(*status, NULL)};
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

























