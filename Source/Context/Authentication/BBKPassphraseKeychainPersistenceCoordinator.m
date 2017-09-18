// BBKPassphraseKeychainPersistenceCoordinator.m
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

#import "BBKPassphraseKeychainPersistenceCoordinator.h"
#import "BBKPassphrase.h"
#import "BBKErrorDomain.h"

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Security/Security.h>

#if TARGET_OS_MAC
#import <CoreServices/CoreServices.h>
#elif TARGET_OS_IOS
#import <CFNetwork/CFNetwork.h>
#endif

UInt8 const BBKPassphraseKeychainStorageKey[] = "com.buybuddy.buybuddykit.Keychain\0";
#if TARGET_OS_MAC
NSString * const BBKPassphraseKeychainStorageErrorUserInfoKey = @"SecCopyErrorMessageString";
#endif
NSString * const BBKPassphraseKeychainStorageItemLabel = @"BuyBuddy stored passphrase";
NSString * const BBKPassphraseKeychainStorageItemDescription = @"An access token to authenticate to BuyBuddy services.";
static void RaiseExceptionIfStatusIsAnError(const OSStatus *status);
static void ExecuteDynBlockAtomic(_Nonnull dispatch_block_t blk);
static void ExecuteStaBlockAtomic(_Nonnull dispatch_block_t blk);

NS_ASSUME_NONNULL_BEGIN

@interface BBKPassphraseKeychainPersistenceCoordinator ()

@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *keychainData;
@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *genericPasswordQuery;

@property (nonatomic, strong, nullable, readwrite) NSDate *lastWriteTimestamp;
@property (nonatomic, strong, nullable, readwrite) NSDate *lastReadTimestamp;

@end

@interface BBKPassphraseKeychainPersistenceCoordinator (Internals)

//  The following two methods translate dictionaries between the format used by
//  the library (NSString *) and the Keychain Services API:
- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert;
- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert;

- (void)writeToKeychain;

@end

NS_ASSUME_NONNULL_END

@implementation BBKPassphraseKeychainPersistenceCoordinator

#pragma mark Instantiation

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        //  Initialize keychain search dictionary
        self.genericPasswordQuery = [[NSMutableDictionary alloc] init];
        
        //  Keychain item is a cryptographic key
        [self.genericPasswordQuery setObject:(__bridge id)kSecClassKey
                                      forKey:(__bridge id)kSecClass];
        
        //  Length of the unique key
        size_t stringLength = strlen((const char *)BBKPassphraseKeychainStorageKey);
        
        //  kSecAttrGeneric attribute is used to store a unique string that is used
        //  to easily identify and find this keychain item. The string is first
        //  converted to an NSData object
        NSData *keychainItemID = [NSData dataWithBytes:BBKPassphraseKeychainStorageKey
                                                length:stringLength];
        
        [self.genericPasswordQuery setObject:keychainItemID
                                      forKey:(__bridge id)kSecAttrGeneric];
        
        //  Return the attributes of the first match only
        [self.genericPasswordQuery setObject:(__bridge id)kSecMatchLimitOne
                                      forKey:(__bridge id)kSecReturnAttributes];
        
        //  Return the attributes of the keychain item (the password is acquired in
        //  the secItemFormatToDictionary: method)
        [self.genericPasswordQuery setObject:(__bridge id)kCFBooleanTrue
                                      forKey:(__bridge id)kSecReturnAttributes];
        
        ExecuteDynBlockAtomic(^{
            //  Initialize the dictionary used to hold return data from the keychain
            CFMutableDictionaryRef outDictionary = nil;
            
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
        });
        
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
        self.keychainData = [[NSMutableDictionary alloc] init];
    } else {
        NSMutableDictionary *tmpDictionary = [self dictionaryToSecItemFormat:self.keychainData];
        
        OSStatus keychainErr = SecItemDelete((__bridge CFDictionaryRef)tmpDictionary);
        
        RaiseExceptionIfStatusIsAnError(&keychainErr);
        
        //  Set values for proper keys
        [self.keychainData setObject:BBKPassphraseKeychainStorageItemLabel
                              forKey:(__bridge id)kSecAttrLabel];
        [self.keychainData setObject:BBKPassphraseKeychainStorageItemDescription
                              forKey:(__bridge id)kSecAttrDescription];
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrCanDecrypt];
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrCanEncrypt];
        [self.keychainData setObject:(__bridge id)kCFBooleanTrue
                              forKey:(__bridge id)kSecAttrCanDerive];
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrCanSign];
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrCanVerify];
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrCanWrap];
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrCanUnwrap];
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrIsPermanent];
#if TARGET_OS_MACOS
        [self.keychainData setObject:(__bridge id)kCFBooleanFalse
                              forKey:(__bridge id)kSecAttrAccess];
#elif TARGET_OS_IOS
        
#endif
        [self.keychainData setObject:[NSData new]
                              forKey:(__bridge id)kSecValueData];
    }
}

#pragma mark - Passphrase persistence coordination conformance

- (void)persistPassphrase:(BBKPassphrase *)passphrase
                  success:(void (^)(BBKPassphrase * _Nonnull))success
                  failure:(void (^)(NSError * _Nonnull))failure
{
    //  Create the archive
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:passphrase];
    
    //  Alter the data
    [self.keychainData setObject:archive
                          forKey:(__bridge id)kSecValueData];
    
    //  Persist in the keychain
    [self writeToKeychain];
    
    //  Fire the callback
    success(passphrase);
}

- (void)loadPassphraseWithCompletion:(void (^)(BBKPassphrase * _Nullable,
                                               NSError * _Nullable))completion
{
    //  Fetch the archive
    NSData *archive = [self.keychainData objectForKey:(__bridge id)kSecValueData];
    
    if (!archive || [archive length] == 0) {
        completion(nil, [NSError errorWithDomain:BBKErrorDomain
                                            code:BBKPassphraseKeychainPersistencePassphraseDoesNotExist
                                        userInfo:nil]);
        
        return;
    }
    
    //  Unmarshall it to a passphrase
    BBKPassphrase *passphrase = (BBKPassphrase *)[NSKeyedUnarchiver unarchiveObjectWithData:archive];
    
    completion(passphrase, nil);
}

@end

@implementation BBKPassphraseKeychainPersistenceCoordinator (Internals)

- (NSMutableDictionary *)dictionaryToSecItemFormat:(NSDictionary *)dictionaryToConvert
{
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    //  Length of the unique key
    size_t stringLength = strlen((const char *)BBKPassphraseKeychainStorageKey);
    NSData *keychainItemID = [NSData dataWithBytes:BBKPassphraseKeychainStorageKey
                                            length:stringLength];
    
    //  Add the keychain item class and the generic attribute
    [returnDictionary setObject:keychainItemID forKey:(__bridge id)kSecAttrGeneric];
    [returnDictionary setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    
    //  Convert the password NSString to NSData to fit the API paradigm
    NSString *passphraseString = [dictionaryToConvert objectForKey:(__bridge id)kSecValueData];
    [returnDictionary setObject:[passphraseString dataUsingEncoding:NSUTF8StringEncoding]
                         forKey:(__bridge id)kSecValueData];
    
    return returnDictionary;
}

- (NSMutableDictionary *)secItemFormatToDictionary:(NSDictionary *)dictionaryToConvert
{
    //  CAVEAT
    //  This method must be called with a properly populated dictionary containing all the right
    //  key/value pairs for the keychain item.
    
    //  Create a return dictionary populated with the attributes
    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionaryToConvert];
    
    //  To acquire the password data from the keychain item, first add the search key and class
    //  attribute required to obtain the password
    [returnDictionary setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [returnDictionary setObject:(__bridge id)kSecClassKey forKey:(__bridge id)kSecClass];
    
    ExecuteDynBlockAtomic(^{
        //  Then call Keychain Services to get the password
        CFDataRef passwordData = NULL;
        
        OSStatus keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)returnDictionary,
                                                   (CFTypeRef *)&passwordData);
        
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
    CFDictionaryRef attributes = nil;
    NSMutableDictionary *updateItem = nil;
    
    //  If the keychain item already exists, modify it
    if (SecItemCopyMatching((__bridge CFDictionaryRef)self.genericPasswordQuery,
                            (CFTypeRef *)&attributes)) {
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
            OSStatus keychainErr = SecItemUpdate((__bridge CFDictionaryRef)updateItem,
                                                 (__bridge CFDictionaryRef)tempCheck);
            
            RaiseExceptionIfStatusIsAnError(&keychainErr);
        });
    } else {
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
            OSStatus keychainErr = SecItemAdd((__bridge CFDictionaryRef)persistedDict, NULL);
            
            //  Release if attributes exists
            if (attributes) {
                CFRelease(attributes);
            }
            
            RaiseExceptionIfStatusIsAnError(&keychainErr);
        });
    }
    
    ExecuteStaBlockAtomic(^{
        self.lastWriteTimestamp = [[NSDate alloc] init];
        self.lastReadTimestamp = [[NSDate alloc] init];
    });
}

@end

static void RaiseExceptionIfStatusIsAnError(const OSStatus *status)
{
    NSCAssert(status != NULL, @"parameter status should not be NULL");
    
    if (*status != noErr) {
#if TARGET_OS_MAC
        NSDictionary *userInfo = @{BBKPassphraseKeychainStorageErrorUserInfoKey: (__bridge NSString *)SecCopyErrorMessageString(*status, NULL)};
#elif TARGET_OS_IOS
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

























