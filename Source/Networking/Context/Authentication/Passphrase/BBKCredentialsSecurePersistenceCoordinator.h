//
//  BBKCredentialsSecurePersistenceCoordinator.h
//  BuyBuddyKit (iOS)
//
//  Created by Emir Çiftçioğlu on 13.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBKCredentialsPersistenceCoordination.h"

@protocol BBKSecurePersistenceCoordination;

@interface BBKCredentialsSecurePersistenceCoordinator : NSObject<BBKCredentialsPersistenceCoordination>

/**
 The `BBKSecurePersistenceCoordination` protocol.
 */
@property (atomic, weak, readwrite, nullable) id<BBKSecurePersistenceCoordination> securePersistenceCoordination;

/**
 Initializes a `BBKPassphraseSecurePersistenceCoordinator` object with the provided delegate.
 
 @param coordinator The `BBKSecurePersistenceCoordination` object which has to be provided to receive required callbacks.
 */
- (instancetype _Nonnull)initWithSecurePersistenceCoordinator:(id<BBKSecurePersistenceCoordination>)coordinator NS_DESIGNATED_INITIALIZER;

@end
