// BBKConnectionCoordinator.h
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

#import <Foundation/Foundation.h>

#import "BBKPassphrase.h"
#import "BBKCredentials.h"
#import "BBKHTTPSessionManager.h"

@class BBKOneTimeCode;
@class BBKTwoFactorAuthenticationStrategy;
@class BBKSMSAuthenticationMetadata;
@class BBKEmailAuthenticationMetadata;
@class BBKExternalAuthenticationMetadata;

@protocol BBKConnectionCoordinatorDelegate;
@protocol BBKCredentialsPersistenceCoordination;
@protocol BBKPassphrasePersistenceCoordination;

NS_ASSUME_NONNULL_BEGIN

/**
 `BBKConnectionCoordinator` creates and manages a user session by fetching a user session token using the provided user credentials or passphrase.
 */
@interface BBKConnectionCoordinator : NSObject

/**
 A boolean value determining wether the current session has expired or not.
 */
@property (readonly, nonatomic, assign, getter = isExpired) BOOL expired;

/**
 The `BBKConnectionCoordinatorDelegate` delegate object.
 */
@property (nonatomic, readwrite, retain) id<BBKConnectionCoordinatorDelegate> _Nonnull delegate;

/**
 The `BBKCredentialsPersistenceCoordination` delegate object.
 */
@property (nonatomic, readwrite, retain) id<BBKCredentialsPersistenceCoordination> _Nonnull credentialsCoordinator;

/**
 The `BBKPassphrasePersistenceCoordination` delegate object.
 */
@property (nonatomic, readwrite, retain) id<BBKPassphrasePersistenceCoordination> _Nonnull passphraseCoordinator;

/**
 Initializes a `BBKConnectionCoordinator` object with the provided delegate.
 
 @param delegate The delegate object which has to be provided to receive required `BBKConnectionCoordinatorDelegate` callbacks.
 */
- (instancetype)initWithDelegate:(id<BBKConnectionCoordinatorDelegate>) delegate;

/**
 Remakes the current session using an existing passphrase.
 
 @param passphrase The `BBKPassphrase` object used for the remake of the session.
 */
- (void)remakeWithPassphrase:(BBKPassphrase * _Nonnull)passphrase;

/**
 Opens a session with the provided credentials.
 
 @param credentials The `BBKCredentials` object used for the creation of the session.
 */
- (void)openWithCredentials:(BBKCredentials * _Nonnull)credentials;

/**
 Persists the current session with the current credentials and passphrase.
 */
- (void)saveImmediately;

/**
 Submits the one time code provided by the user if a two factor authentication challenge was received.
 
 @param oneTimeCode OnetimeCode
 */
- (void)submitOneTimeCode:(BBKOneTimeCode * _Nonnull)oneTimeCode;

@end

NS_ASSUME_NONNULL_END

/**
 `BBKConnectionCoordinatorDelegate` informs the user about the current session status and an encountered two factor authentication challenge.
 */
@protocol BBKConnectionCoordinatorDelegate <NSObject>

@optional
/**
 Called when connection coordinator receives a further action request for the two-factor authentication yielding SMS artifact.
 
 @param coordinator The `BBKConnectionCoordinator` object in context.
 @param SMSAuthenticationMetadata The `BBKExternalAuthenticationMetadata` object which carries information about the current two factor authentication challenge.
 */
- (void)connectionCoordinator:(BBKConnectionCoordinator * _Nonnull)coordinator requiresSMSAuthenticationWithMetadata:(BBKSMSAuthenticationMetadata * _Nonnull)SMSAuthenticationMetadata;

@optional
/**
 Called when connection coordinator receives a further action request for the two-factor authentication yielding Email artifact.
 
 @param coordinator The `BBKConnectionCoordinator` object in context.
 @param emailAuthenticationMetadata The `BBKEmailAuthenticationMetadata` object which carries information about the current two factor authentication challenge.
 */
- (void)connectionCoordinator:(BBKConnectionCoordinator * _Nonnull)coordinator requiresEmailAuthenticationWithMetadata:(BBKEmailAuthenticationMetadata * _Nonnull)emailAuthenticationMetadata;

@optional
/**
 Called when connection coordinator receives a further action request for the two-factor authentication yielding External artifact.
 
 @param coordinator The `BBKConnectionCoordinator` object in context.
 @param externalAuthenticationMetadata The `BBKExternalAuthenticationMetadata` object which carries information about the current two factor authentication challenge.
 */
- (void)connectionCoordinator:(BBKConnectionCoordinator * _Nonnull)coordinator requiresExternalAuthenticationWithMetadata:(BBKExternalAuthenticationMetadata * _Nonnull)externalAuthenticationMetadata;

@optional
/**
 Called when connection coordinator receives a further action request for a provided two-factor authentication strategy.
 
 @param coordinator The `BBKConnectionCoordinator` object in context.
 @param strategy The `BBKTwoFactorAuthenticationStrategy` which needs to be followed.
 */
- (void)connectionCoordinator:(BBKConnectionCoordinator * _Nonnull)coordinator didReceiveTwoFactorAuthenticationStrategy:(BBKTwoFactorAuthenticationStrategy * _Nonnull)strategy;

@required
/**
 Called when connection coordinator succesfuly completes an authentication task.
 
 @param coordinator The `BBKConnectionCoordinator` object in context.
 */
- (void)connectionCoordinatorDidPromoteToComplete:(BBKConnectionCoordinator * _Nonnull)coordinator;

@required
/**
 Called when connection coordinator fails to completes an authentication task.
 
 @param coordinator The `BBKConnectionCoordinator` object in context.
 @param error The finalization error received during the task.
 */
- (void)connectionCoordinator:(BBKConnectionCoordinator * _Nonnull)coordinator didReceiveFinalizationError:(NSError * _Nonnull)error;

@end
