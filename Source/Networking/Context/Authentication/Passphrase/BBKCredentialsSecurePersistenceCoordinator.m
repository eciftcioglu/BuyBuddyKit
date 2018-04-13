//
//  BBKCredentialsSecurePersistenceCoordinator.m
//  BuyBuddyKit (iOS)
//
//  Created by Emir Çiftçioğlu on 13.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import "BBKCredentialsSecurePersistenceCoordinator.h"

#import "../BBKSecurePersistenceCoordination.h"

static NSString * const BBKCredentialsStorageKey = @"Credentials";

@implementation BBKCredentialsSecurePersistenceCoordinator
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
- (void)persistCredentials:(BBKCredentials *)credentials completionHandler:(void (^)(NSError * _Nullable))handler
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:credentials];
    
    [self.securePersistenceCoordination persistData:data
                                             ofType:BBKKeychainDataTypeCryptographicKey
                                             forKey:BBKCredentialsStorageKey
                                     withAttributes:@{}
                                  completionHandler:^(NSError * _Nullable error) {
                                      handler(error);
                                  }];
}

- (void)loadCredentialsWithCompletionHandler:(void (^)(BBKCredentials * _Nullable, NSError * _Nullable))handler
{
    [self.securePersistenceCoordination loadDataForKey:BBKCredentialsStorageKey
                                                ofType:BBKKeychainDataTypeCryptographicKey
                                     completionHandler:^(NSData * _Nullable data, NSError * _Nullable error) {
                                         BBKCredentials *credentials = nil;
                                         
                                         if (data) {
                                             credentials = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                         }
                                         
                                         handler(credentials, error);
                                     }];
}
- (void)removeCredentialsWithCompletionHandler:(void (^)(NSError * _Nullable))handler
{
    [self.securePersistenceCoordination removeDataForKey:BBKCredentialsStorageKey
                                                  ofType:BBKKeychainDataTypeCryptographicKey
                                       completionHandler:^(NSError * _Nullable error) {
                                           handler(error);
                                       }];
}
@end
