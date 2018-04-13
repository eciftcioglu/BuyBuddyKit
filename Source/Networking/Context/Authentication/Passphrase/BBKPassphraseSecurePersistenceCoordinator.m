//
//  BBKPassphraseSecurePersistenceCoordinator.m
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 12.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import "BBKPassphraseSecurePersistenceCoordinator.h"

#import "../BBKSecurePersistenceCoordination.h"

static NSString * const BBKPassphraseStorageKey = @"Passphrase";

@implementation BBKPassphraseSecurePersistenceCoordinator

#pragma mark - Instantiation

- (instancetype)initWithSecurePersistenceCoordinator:(id<BBKSecurePersistenceCoordination>)coordinator
{
    self = [super init];
    
    if (self) {
        self.securePersistenceCoordination = coordinator;
    }
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

#pragma mark - Passphrase persistence coordination conformance

- (void)persistPassphrase:(BBKPassphrase * _Nonnull)passphrase completionHandler:(void (^ _Nonnull)(NSError * _Nullable))handler
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:passphrase];
    
    [self.securePersistenceCoordination persistData:data
                                             ofType:BBKKeychainDataTypeCryptographicKey
                                             forKey:BBKPassphraseStorageKey
                                     withAttributes:@{}
                                  completionHandler:^(NSError * _Nullable error) {
                                      handler(error);
                                  }];
}

- (void)loadPassphraseWithCompletionHandler:(void (^_Nonnull)(BBKPassphrase * _Nullable, NSError * _Nullable))handler
{
    [self.securePersistenceCoordination loadDataForKey:BBKPassphraseStorageKey
                                                ofType:BBKKeychainDataTypeCryptographicKey
                                     completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
                                         BBKPassphrase *passphrase = nil;
                                         
                                         if (data) {
                                             passphrase = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                         }
                                         
                                         handler(passphrase, error);
                                     }];
}

- (void)removePassphraseWithCompletionHandler:(void (^_Nonnull)(NSError * _Nullable))handler
{
    [self.securePersistenceCoordination removeDataForKey:BBKPassphraseStorageKey
                                                  ofType:BBKKeychainDataTypeCryptographicKey
                                       completionHandler:^(NSError * _Nullable error) {
                                           handler(error);
                                       }];
}

@end
