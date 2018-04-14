// BBKCredentialsSecurePersistenceCoordinator.m
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
