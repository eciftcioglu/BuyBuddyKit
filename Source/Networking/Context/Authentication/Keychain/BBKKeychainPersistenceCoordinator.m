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
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCreationDate = @"BBKKeychainStorageAttribute.CreationDate";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeModificationDate = @"BBKKeychainStorageAttribute.ModificationDate";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCreator = @"BBKKeychainStorageAttribute.Creator";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeType = @"BBKKeychainStorageAttribute.Type";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeIsInvisible = @"BBKKeychainStorageAttribute.IsInvisible";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeIsNegative = @"BBKKeychainStorageAttribute.IsNegative";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeAccount = @"BBKKeychainStorageAttribute.Account";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeService = @"BBKKeychainStorageAttribute.Service";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeGeneric = @"BBKKeychainStorageAttribute.Generic";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSynchronizable = @"BBKKeychainStorageAttribute.Synchronizable";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSecurityDomain = @"BBKKeychainStorageAttribute.SecurityDomain";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeServer = @"BBKKeychainStorageAttribute.Server";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeProtocol = @"BBKKeychainStorageAttribute.Protocol";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeAuthenticationType = @"BBKKeychainStorageAttribute.AuthenticationType";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePort = @"BBKKeychainStorageAttribute.Port";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePath = @"BBKKeychainStorageAttribute.Path";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSubject = @"BBKKeychainStorageAttribute.Subject";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeIssuer = @"BBKKeychainStorageAttribute.Issuer";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSerialNumber = @"BBKKeychainStorageAttribute.SerialNumber";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSubjectKeyID = @"BBKKeychainStorageAttribute.SubjectKeyID";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePublicKeyHash = @"BBKKeychainStorageAttribute.PublicKeyHash";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCertificateType = @"BBKKeychainStorageAttribute.CertificateType";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCertificateEncoding = @"BBKKeychainStorageAttribute.CertificateEncoding";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeKeyClass = @"BBKKeychainStorageAttribute.KeyClass";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeApplicationLabel = @"BBKKeychainStorageAttribute.ApplicationLabel";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeApplicationTag = @"BBKKeychainStorageAttribute.ApplicationTag";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeKeyType = @"BBKKeychainStorageAttribute.KeyType";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributePRF = @"BBKKeychainStorageAttribute.PRF";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeSalt = @"BBKKeychainStorageAttribute.Salt";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeRounds = @"BBKKeychainStorageAttribute.Rounds";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeKeySizeInBits = @"BBKKeychainStorageAttribute.KeySizeInBits";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeEffectiveKeySize = @"BBKKeychainStorageAttribute.EffectiveKeySize";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeTokenID = @"BBKKeychainStorageAttribute.TokenID";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeIsPermanent = @"BBKKeychainStorageAttribute.IsPermanent";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCanEncrypt = @"BBKKeychainStorageAttribute.CanEncrypt";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCanDecrypt = @"BBKKeychainStorageAttribute.CanDecrypt";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCanDerive = @"BBKKeychainStorageAttribute.CanDerive";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCanSign = @"BBKKeychainStorageAttribute.CanSign";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCanVerify = @"BBKKeychainStorageAttribute.CanVerify";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCanWrap = @"BBKKeychainStorageAttribute.CanWrap";
BBKKeychainStorageAttributeKey const BBKKeychainStorageAttributeCanUnwrap = @"BBKKeychainStorageAttribute.CanUnwrap";

size_t const KeychainEntryKeySize = BUFSIZ;
#if TARGET_OS_MAC
NSString * const BBKKeychainStorageErrorUserInfoKey = @"SecCopyErrorMessageString";
#endif

static BOOL InjectAttributesToDictionary(BBKKeychainDataType type, NSDictionary *attributes, NSMutableDictionary *toDictionary, NSError * __autoreleasing _Nullable * _Nullable errPtr);
static id GetSecKeyAttrForAttributeKey(BBKKeychainStorageAttributeKey key);
static id SecClassForKeychainDataType(BBKKeychainDataType type);
static NSError * _Nullable MakeNSErrorForErrorOrThrow(const OSStatus * _Nonnull status);
static void ExecuteStaBlockAtomic(_Nonnull dispatch_block_t blk);

@interface BBKKeychainPersistenceCoordinator ()

@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *keychainData;
@property (nonatomic, strong, nonnull, readwrite) NSMutableDictionary *query;

@property (nonatomic, strong, nullable, readwrite) NSDate *lastWriteTimestamp;
@property (nonatomic, strong, nullable, readwrite) NSDate *lastReadTimestamp;

@end

@implementation BBKKeychainPersistenceCoordinator

#pragma mark - Persisting data

- (void)persistData:(NSData *)data
             ofType:(BBKKeychainDataType)type
             forKey:(NSString *)keyString
     withAttributes:(NSDictionary *)attributes
  completionHandler:(void (^)(NSError * _Nullable))handler
{
    [self loadDataForKey:keyString
                  ofType:type
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
               
               if (!InjectAttributesToDictionary(type, attributes, changeset, &injectionError)) {
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
               
               if (!InjectAttributesToDictionary(type, attributes, dictionary, &injectionError)) {
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

#pragma mark - Fetching data

- (void)loadDataForKey:(NSString *)keyString
                ofType:(BBKKeychainDataType)type
     completionHandler:(void (^)(NSData * _Nullable, NSError * _Nullable))handler
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    //  Query should include its type
    [dictionary setObject:SecClassForKeychainDataType(type)
                   forKey:(__bridge id)kSecClass];
    
    //  Query should return data
    [dictionary setObject:(__bridge id)kCFBooleanTrue
                   forKey:(__bridge id)kSecReturnData];
    
    //  Query should return attributes
    [dictionary setObject:(__bridge id)kCFBooleanTrue
                   forKey:(__bridge id)kSecReturnAttributes];
    
    //  Query should have a label
    [dictionary setObject:[self labelStringForKey:keyString]
                   forKey:(__bridge id)kSecAttrLabel];
    
    //  Query should limit results to one entry
    [dictionary setObject:(__bridge id)kSecMatchLimitOne
                   forKey:(__bridge id)kSecMatchLimit];
    
    CFDictionaryRef data = NULL;
    OSStatus keychainErr = errSecSuccess;
    
    keychainErr = SecItemCopyMatching((__bridge CFDictionaryRef)dictionary,
                                      (CFTypeRef *)&data);
    
    NSError *error = MakeNSErrorForErrorOrThrow(&keychainErr);
    
    if (error) {
        handler(nil, error);
    }
    
    NSDictionary *queryResult = (__bridge_transfer NSDictionary *)data;
    
    handler([queryResult objectForKey:(__bridge id)kSecValueData], nil);
    
    ExecuteStaBlockAtomic(^{
        self.lastReadTimestamp = [[NSDate alloc] init];
    });
}

- (NSData *)loadDataForKey:(NSString *)keyString
                    ofType:(BBKKeychainDataType)type
                     error:(NSError * _Nullable __autoreleasing *)errPtr
{
    __block dispatch_semaphore_t dsema = dispatch_semaphore_create(0LL);
    __block NSData *result = nil;
    
    [self loadDataForKey:keyString
                  ofType:type
       completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
           result = data;
           *errPtr = error;
           
           dispatch_semaphore_signal(dsema);
       }];
    
    dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
    
    return result;
}

#pragma mark - Removing data

- (BOOL)removeDataForKey:(NSString *)keyString
                  ofType:(BBKKeychainDataType)type
       completionHandler:(void (^)(NSError * _Nullable))handler
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    //  Query should include its type
    [dictionary setObject:SecClassForKeychainDataType(type)
                   forKey:(__bridge id)kSecClass];
    
    //  Query should return data
    [dictionary setObject:(__bridge id)kCFBooleanTrue
                   forKey:(__bridge id)kSecReturnData];
    
    //  Query should return attributes
    [dictionary setObject:(__bridge id)kCFBooleanTrue
                   forKey:(__bridge id)kSecReturnAttributes];
    
    //  Query should have a label
    [dictionary setObject:[self labelStringForKey:keyString]
                   forKey:(__bridge id)kSecAttrLabel];
    
    //  Query should limit results to one entry
    [dictionary setObject:(__bridge id)kSecMatchLimitOne
                   forKey:(__bridge id)kSecMatchLimit];
    
    OSStatus keychainErr = SecItemDelete((__bridge CFDictionaryRef)dictionary);
    NSError *error = MakeNSErrorForErrorOrThrow(&keychainErr);
    
    handler(error);
    
    ExecuteStaBlockAtomic(^{
        self.lastWriteTimestamp = [[NSDate alloc] init];
    });
    
    return error == nil;
}

- (BOOL)removeDataForKey:(NSString *)keyString
                  ofType:(BBKKeychainDataType)type
                   error:(NSError * _Nullable __autoreleasing * _Nullable)errPtr
{
    __block dispatch_semaphore_t dsema = dispatch_semaphore_create(0);
    
    [self removeDataForKey:keyString
                    ofType:type
         completionHandler:^(NSError * _Nullable error) {
             *errPtr = error;
             
             dispatch_semaphore_signal(dsema);
         }];
    
    dispatch_semaphore_wait(dsema, DISPATCH_TIME_FOREVER);
    
    return *errPtr == nil;
}

#pragma mark - Class helpers

- (NSString *)labelStringForKey:(NSString *)keyString
{
    return [NSString stringWithFormat:@"%@%@%@", BBKKeychainStorageKey, KeychainStorageKeyDelim, keyString];
}

@end

#pragma mark - Injectors & converters

static BOOL InjectAttributesToDictionary(BBKKeychainDataType type,
                                         NSDictionary *attributes,
                                         NSMutableDictionary *toDictionary,
                                         NSError * __autoreleasing _Nullable * _Nullable errPtr)
{
    NSMutableDictionary *filteredAttributes = [[NSMutableDictionary alloc] init];
    NSArray *availableKeys = BBKGetAvailableKeysForType(type);
    
    for (BBKKeychainStorageAttributeKey key in attributes) {
        if ([availableKeys containsObject:key]) {
            [filteredAttributes setObject:[attributes objectForKey:key] forKey:key];
        }
    }
    
    for (BBKKeychainStorageAttributeKey key in filteredAttributes) {
        id attr = GetSecKeyAttrForAttributeKey(key);
        
        if (attr) {
            [toDictionary setObject:[filteredAttributes objectForKey:key]
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
                                  ],
                          [NSNumber numberWithUnsignedInteger:BBKKeychainDataTypeCryptographicKey]: @[
                                  BBKKeychainStorageAttributeLabel,
                                  BBKKeychainStorageAttributeKeyClass,
                                  BBKKeychainStorageAttributeApplicationLabel,
                                  BBKKeychainStorageAttributeIsPermanent,
                                  BBKKeychainStorageAttributeApplicationTag,
                                  BBKKeychainStorageAttributeKeyType,
                                  BBKKeychainStorageAttributePRF,
                                  BBKKeychainStorageAttributeSalt,
                                  BBKKeychainStorageAttributeRounds,
                                  BBKKeychainStorageAttributeKeySizeInBits,
                                  BBKKeychainStorageAttributeEffectiveKeySize,
                                  BBKKeychainStorageAttributeCanEncrypt,
                                  BBKKeychainStorageAttributeCanDecrypt,
                                  BBKKeychainStorageAttributeCanDerive,
                                  BBKKeychainStorageAttributeCanSign,
                                  BBKKeychainStorageAttributeCanVerify,
                                  BBKKeychainStorageAttributeCanWrap,
                                  BBKKeychainStorageAttributeCanUnwrap,
                                  ],
                          [NSNumber numberWithUnsignedInteger:BBKKeychainDataTypeCertificate]: @[
                                  BBKKeychainStorageAttributeCertificateType,
                                  BBKKeychainStorageAttributeCertificateEncoding,
                                  BBKKeychainStorageAttributeSubject,
                                  BBKKeychainStorageAttributeIssuer,
                                  BBKKeychainStorageAttributeSerialNumber,
                                  BBKKeychainStorageAttributeSubjectKeyID,
                                  BBKKeychainStorageAttributePublicKeyHash,
                                  ],
                          };
    });
    
    return [availableKeys objectForKey:[NSNumber numberWithUnsignedInteger:type]];
}

#pragma mark - Error handling

static NSError *MakeNSErrorForErrorOrThrow(const OSStatus *status)
{
    NSCAssert(status != NULL, @"parameter status should not be NULL");
    
    if (*status == errSecSuccess || *status == errSecItemNotFound) {
        return nil;
    } else {
#if TARGET_OS_OSX
        NSDictionary *userInfo = @{BBKKeychainStorageErrorUserInfoKey: (__bridge NSString *)SecCopyErrorMessageString(*status, NULL)};
#else
        NSDictionary *userInfo = nil;
#endif
        NSError *error = [NSError errorWithDomain:NSOSStatusErrorDomain
                                             code:*status
                                         userInfo:userInfo];
        
        [NSException raise:NSInternalInconsistencyException
                    format:@"Keychain persistence coordinator encountered unexpected error %@.", error.description];
        
        return nil;
    }
}

#pragma mark - Atomic dispatch

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
