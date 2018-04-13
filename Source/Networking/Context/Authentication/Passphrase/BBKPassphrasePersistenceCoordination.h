//
//  BBKPersistenceCoordination.h
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 12.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBKPassphrase;

/**
 `BBKPassphrasePersistenceCoordination` coordinates the persistence of a provided user passphrase.
 */
@protocol BBKPassphrasePersistenceCoordination <NSObject>

@optional
/**
Persists the provided passphrase.
 
@param passphrase The session passphrase which will be persisted.
 */
- (void)persistPassphrase:(BBKPassphrase * _Nonnull)passphrase;

@optional
/**
 The Async-invariant of the persistPassphrase method whcih includes a completionHandler.
 
 @param passphrase The session passphrase which will be persisted.
 @param handler The completion handler which will inform the user when the persisting process is completed.
 */
- (void)persistPassphrase:(BBKPassphrase * _Nonnull)passphrase completionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@optional
/**
Loads the persisted passphrase for the current session.
 */
- (BBKPassphrase *)loadPassphrase;

/**
 The Async-invariant of the loadPassphrase method whcih includes a completionHandler.
 
 @param handler The completion handler which will inform the user when the loading process is completed.
 */
@optional
- (void)loadPassphraseWithCompletionHandler:(void (^_Nonnull)(BBKPassphrase * _Nullable, NSError * _Nullable))handler;

/**
 Removes the current passphrase for the session.
 
 @warning When this method is called the passphrase will be lost and there will be no way to retreieve it. A new passphrase will have to be created by providing user credentials.
 */
@optional
- (void)removePassphrase;

/**
 The Async-invariant of the removePassphrase method whcih includes a completionHandler.

 @warning When this method is called the passphrase will be lost and there will be no way to retreieve it. A new passphrase will have to be created by providing user credentials.
 */
@optional
- (void)removePassphraseWithCompletionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@end
