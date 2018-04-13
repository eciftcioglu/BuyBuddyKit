//
//  BBKCredentialsPersistenceCoordination.h
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 13.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBKCredentials;

/**
 `BBKPassphrasePersistenceCoordination` coordinates the persistence of a provided user credentials.
 */
@protocol BBKCredentialsPersistenceCoordination <NSObject>

@optional
/**
 Persists the provided credentials.
 
 @param credentials The session credentials which will be persisted.
 */
- (void)persistCredentials:(BBKCredentials * _Nonnull)credentials;

@optional
/**
 The Async-invariant of the persistCredentials method whcih includes a completionHandler.
 
 @param credentials The session credentials which will be persisted.
 @param handler The completion handler which will inform the user when the persisting process is completed.
 */
- (void)persistCredentials:(BBKCredentials * _Nonnull)credentials completionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@optional
/**
 Loads the persisted credentials for the current session.
 */
- (BBKCredentials *)loadCredentials;

/**
 The Async-invariant of the loadCredentials method whcih includes a completionHandler.
 
 @param handler The completion handler which will inform the user when the loading process is completed.
 */
@optional
- (void)loadCredentialsWithCompletionHandler:(void (^_Nonnull)(BBKCredentials * _Nullable, NSError * _Nullable))handler;

/**
 Removes the current credentials for the session.
 
 @warning When this method is called the credentials will be lost and there will be no way to retreieve it.
 */
@optional
- (void)removeCredentials;

/**
 The Async-invariant of the removeCredentials method whcih includes a completionHandler.
 
 @warning When this method is called the credentials will be lost and there will be no way to retreieve it.
 */
@optional
- (void)removeCredentialsWithCompletionHandler:(void (^_Nonnull)(NSError * _Nullable))handler;

@end
