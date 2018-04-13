//
//  BBKPassphraseSecurePersistenceCoordinator.h
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 12.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBKPassphrasePersistenceCoordination.h"

@protocol BBKSecurePersistenceCoordination;

NS_ASSUME_NONNULL_BEGIN

/**
 
 */
@interface BBKPassphraseSecurePersistenceCoordinator : NSObject <BBKPassphrasePersistenceCoordination>

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

NS_ASSUME_NONNULL_END
