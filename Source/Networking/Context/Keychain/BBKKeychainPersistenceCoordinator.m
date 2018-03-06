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

#import "BBKErrorDomain.h"

#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>
#import <Security/Security.h>

#if TARGET_OS_OSX
#import <CoreServices/CoreServices.h>
#elif TARGET_OS_IOS
#import <CFNetwork/CFNetwork.h>
#endif

NSString * const BBKKeychainStorageKey = @"BuyBuddy Türk Anonim Şirketi";
NSString * const KeychainStorageKeyDelim = @": ";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeLabel = @"BBKKeychainStorageAttribute.Label";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeDescription = @"BBKKeychainStorageAttribute.Description";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeComment = @"BBKKeychainStorageAttribute.Comment";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCreationDate = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeModificationDate = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCreator = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeType = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeIsInvisible = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeIsNegative = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeAccount = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeService = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeGeneric = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSynchronizable = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSecurityDomain = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeServer = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeProtocol = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeAuthenticationType = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePort = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePath = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSubject = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeIssuer = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSerialNumber = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSubjectKeyID = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePublicKeyHash = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCertificateType = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCertificateEncoding = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeKeyClass = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeApplicationLabel = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeApplicationTag = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeKeyType = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePRF = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSalt = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeRounds = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeKeySizeInBits = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeEffectiveKeySize = @"BBKKeychainStorageAttribute.";

BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeTokenID = @"BBKKeychainStorageAttribute.";

size_t const KeychainEntryKeySize = BUFSIZ;
#if TARGET_OS_MAC
NSString * const BBKKeychainStorageErrorUserInfoKey = @"SecCopyErrorMessageString";
#endif

static BOOL InjectAttributesToDictionary(NSDictionary *attributes, NSMutableDictionary *toDictionary, NSError * __autoreleasing _Nullable * _Nullable errPtr);
static id GetSecKeyAttrForAttributeKey(BBKKeychainStorageAttributeKey key);
static id SecClassForKeychainDataType(BBKKeychainDataType type);
static NSError * _Nullable MakeNSErrorForErrorOrThrow(const OSStatus * _Nonnull status);
static void RaiseExceptionIfStatusIsAnError(const OSStatus * _Nonnull status);
static void ExecuteDynBlockAtomic(_Nonnull dispatch_block_t blk);
static void ExecuteStaBlockAtomic(_Nonnull dispatch_block_t blk);

@interface BBKKeychainPersistenceCoordinator ()

@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *keychainData;
@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *query;

@property (nonatomic, strong, nullable, readwrite) NSDate *lastWriteTimestamp;
@property (nonatomic, strong, nullable, readwrite) NSDate *lastReadTimestamp;

@end

@implementation BBKKeychainPersistenceCoordinator

- (void)persistData:(NSData *)data
             ofType:(BBKKeychainDataType)type
             forKey:(NSString *)keyString
     withAttributes:(NSDictionary *)attributes
  completionHandler:(void (^)(NSError * _Nullable))handler
{
    [self loadDataForKey:keyString
       completionHandler:^(NSData * _Nullable retrievedData, NSError * _Nullable loadError) {
           __block OSStatus keychainErr = errSecInternalError;
           
           if (loadError) {
               if (handler) handler(loadError);
           } else if (retrievedData) {
               NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
               NSMutableDictionary *changeset = [[NSMutableDictionary alloc] init];
               
               //  Class of the keychain entry
               [dictionary setObject:SecClassForKeychainDataType(type)
                              forKey:(__bridge id)kSecClass];
               
               //  Key of the keychain entry
               [dictionary setObject:[self labelStringForKey:keyString]
                              forKey:(__bridge id)kSecAttrLabel];
               
               NSError *injectionError = nil;
               
               if (!InjectAttributesToDictionary(attributes, changeset, &injectionError)) {
                   if (handler) handler(injectionError);
                   
                   return;
               }
               
               //  Value of the keychain entry
               [changeset setObject:data
                             forKey:(__bridge id)kSecValueData];
               
               keychainErr = SecItemUpdate((__bridge CFDictionaryRef)dictionary,
                                           (__bridge CFDictionaryRef)changeset);
           } else {
               NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
               
               //  Class of the keychain entry
               [dictionary setObject:SecClassForKeychainDataType(type)
                              forKey:(__bridge id)kSecClass];
               
               //  Key of the keychain entry
               [dictionary setObject:[self labelStringForKey:keyString]
                              forKey:(__bridge id)kSecAttrLabel];
               
               NSError *injectionError = nil;
               
               if (!InjectAttributesToDictionary(attributes, dictionary, &injectionError)) {
                   if (handler) handler(injectionError);
                   
                   return;
               }
               
               //  Value of the keychain entry
               [dictionary setObject:data
                              forKey:(__bridge id)kSecValueData];
               
               //  Passing NULL as result is not required
               keychainErr = SecItemAdd((__bridge CFDictionaryRef)dictionary, nil);
           }
           
           NSError *error = MakeNSErrorForErrorOrThrow(&keychainErr);
           
           if (handler) {
               handler(error);
           }
           
           if (!error) {
               ExecuteStaBlockAtomic(^{
                   self.lastWriteTimestamp = [[NSDate alloc] init];
               });
           }
       }];
}

- (BOOL)persistData:(NSData *)data
             ofType:(BBKKeychainDataType)type
             forKey:(NSString *)keyString
     withAttributes:(NSDictionary *)attributes
              error:(NSError * _Nullable __autoreleasing *)errPtr
{
    __block dispatch_semaphore_t dsema = dispatch_semaphore_create(0LL);
    
    [self persistData:data
               ofType:type
               forKey:keyString
       withAttributes:attributes
    completionHandler:^(NSError * _Nullable error) {
        *errPtr = error;
        
        dispatch_semaphore_signal(dsema);
    }];
    
    dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
    
    return errPtr == nil;
}

- (void)loadDataForKey:(NSString *)keyString
     completionHandler:(void (^)(NSData * _Nullable, NSError * _Nullable))handler
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    //  Query should return data
    [dictionary setObject:(__bridge id)kCFBooleanTrue
                   forKey:(__bridge id)kSecReturnData];
    
    [dictionary setObject:[self labelStringForKey:keyString]
                   forKey:(__bridge id)kSecAttrLabel];
    
    CFDataRef data = NULL;
    OSStatus keychainErr = errSecSuccess;
    
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictionary,
                                      (CFTypeRef *)&data);
    
    NSError *error = MakeNSErrorForErrorOrThrow(&keychainErr);
    
    handler((__bridge_transfer NSData * _Nonnull)data, error);
    
    ExecuteStaBlockAtomic(^{
        self.lastReadTimestamp = [[NSDate alloc] init];
    });
}

- (NSData *)loadDataForKey:(NSString *)keyString
                     error:(NSError * _Nullable __autoreleasing *)errPtr
{
    __block dispatch_semaphore_t dsema = dispatch_semaphore_create(0LL);
    __block NSData *result = nil;
    
    [self loadDataForKey:keyString
       completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
           result = data;
           *errPtr = error;
           
           dispatch_semaphore_signal(dsema);
       }];
    
    return result;
}

- (NSString *)labelStringForKey:(NSString *)keyString
{
    return [NSString stringWithFormat:@"%@%@%@", BBKKeychainStorageKey, KeychainStorageKeyDelim, keyString];
}

@end

static BOOL InjectAttributesToDictionary(NSDictionary *attributes, NSMutableDictionary *toDictionary, NSError * __autoreleasing _Nullable * _Nullable errPtr)
{
    for (BBKKeychainStorageAttributeKey key in attributes) {
        id attr = GetSecKeyAttrForAttributeKey(key);
        
        if (attr) {
            [toDictionary setObject:[attributes objectForKey:key]
                             forKey:attr];
        } else {
            *errPtr = [NSError errorWithDomain:BBKErrorDomain
                                          code:BBKKeychainStorageAttributeNotAvailableForStorageType
                                      userInfo:@{@"reason": @"An invalid attribute supplied to the entry registration order."}];
            
            return NO;
        }
    }
    
    return YES;
}

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

static NSError *MakeNSErrorForErrorOrThrow(const OSStatus *status)
{
    NSCAssert(status != NULL, @"parameter status should not be NULL");
    
    if (status == errSecSuccess) {
        return nil;
    } else {
        return nil;
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

static id GetSecKeyAttrForAttributeKey(BBKKeychainStorageAttributeKey key)
{
    static NSDictionary *keyAttributes = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        keyAttributes = @{
            BBKKeychainStorageAttributeLabel: (__bridge id)kSecAttrLabel,
            BBKKeychainStorageAttributeDescription: (__bridge id)kSecAttrDescription,
            BBKKeychainStorageAttributeComment: (__bridge id)kSecAttrComment,
            BBKKeychainStorageAttributeCreationDate: (__bridge id)kSecAttrCreationDate,
            BBKKeychainStorageAttributeModificationDate: (__bridge id)kSecAttrModificationDate,
            BBKKeychainStorageAttributeCreator: (__bridge id)kSecAttrCreator,
            BBKKeychainStorageAttributeType:(__bridge id)kSecAttrType,
            BBKKeychainStorageAttributeIsInvisible:(__bridge id)kSecAttrIsInvisible,
            BBKKeychainStorageAttributeIsNegative:(__bridge id)kSecAttrIsNegative,
            BBKKeychainStorageAttributeAccount:(__bridge id)kSecAttrAccount,
            BBKKeychainStorageAttributeService:(__bridge id)kSecAttrService,
            BBKKeychainStorageAttributeGeneric:(__bridge id)kSecAttrGeneric,
            BBKKeychainStorageAttributeSynchronizable:(__bridge id)kSecAttrSynchronizable,
            BBKKeychainStorageAttributeSecurityDomain:(__bridge id)kSecAttrSecurityDomain,
            BBKKeychainStorageAttributeServer:(__bridge id)kSecAttrServer,
            BBKKeychainStorageAttributeProtocol:(__bridge id)kSecAttrProtocol,
            BBKKeychainStorageAttributeAuthenticationType:(__bridge id)kSecAttrAuthenticationType,
        };
    });
    
    return [keyAttributes objectForKey:key];
}

NSArray<BBKKeychainStorageAttributeKey> *BBKGetAvailableKeysForType(BBKKeychainDataType type)
{
    static NSDictionary *availableKeys = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        availableKeys = @{
            [NSNumber numberWithUnsignedInteger:BBKKeychainDataTypeGenericPassword]: @[
                BBKKeychainStorageAttributeDescription,
                BBKKeychainStorageAttributeComment,
                BBKKeychainStorageAttributeCreationDate,
                BBKKeychainStorageAttributeModificationDate,
                BBKKeychainStorageAttributeCreator,
                BBKKeychainStorageAttributeIsInvisible,
                BBKKeychainStorageAttributeIsNegative,
                BBKKeychainStorageAttributeAccount,
                BBKKeychainStorageAttributeService,
                BBKKeychainStorageAttributeSynchronizable,
            ],
            [NSNumber numberWithUnsignedInt:BBKKeychainDataTypeCryptographicKey]: @[
                
            ],
            [NSNumber numberWithUnsignedInt:BBKKeychainDataTypeCertificate]: @[
            ],
        };
    });
    
    return [availableKeys objectForKey:[NSNumber numberWithUnsignedInteger:type]];
}
