//
//  BBKDefaultConnectionCoordinator.m
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 12.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import "BBKDefaultConnectionCoordinator.h"

#import "BBKPassphraseSecurePersistenceCoordinator.h"
#import "BBKCredentialsSecurePersistenceCoordinator.h"
#import "BBKKeychainPersistenceCoordinator.h"

@protocol BBKSecurePersistenceCoordination;

NS_ASSUME_NONNULL_BEGIN

@interface BBKDefaultConnectionCoordinator ()

@property (nonatomic, strong, readwrite, nonnull) id<BBKSecurePersistenceCoordination> securePersistenceCoordinator;

@end

NS_ASSUME_NONNULL_END

@implementation BBKDefaultConnectionCoordinator

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        BBKKeychainPersistenceCoordinator *kpc = [[BBKKeychainPersistenceCoordinator alloc] init];
        
        [self setCredentialsCoordinator:[[BBKCredentialsSecurePersistenceCoordinator alloc] initWithSecurePersistenceCoordinator:kpc] ];
        [self setPassphraseCoordinator:[[BBKPassphraseSecurePersistenceCoordinator alloc] initWithSecurePersistenceCoordinator:kpc]];
    }
    
    return self;
}

@end
