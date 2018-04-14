// BBKPassphraseSecurePersistenceCoordinator.m
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
