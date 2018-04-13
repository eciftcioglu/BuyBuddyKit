// BBKConnectionCoordinator.m
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

#import "BBKConnectionCoordinator.h"

typedef void (^BBKSignUpCompletionHandler)(BBKPassphrase * _Nullable, NSError * _Nullable);
typedef void (^BBKRetrieveTokenCompletionHandler)(NSObject * _Nullable, NSError * _Nullable);

NS_ASSUME_NONNULL_BEGIN

@interface BBKConnectionCoordinator ()

@property (nonatomic, readwrite, weak) BBKHTTPSessionManager *manager;

- (void)signUp:(BBKCredentials * _Nonnull)credentials
completionHandler:(BBKSignUpCompletionHandler _Nonnull)handler;

- (void)retrieveToken:(BBKPassphrase * _Nonnull)passphrase
    completionHandler:(BBKRetrieveTokenCompletionHandler _Nonnull)handler;

@end

NS_ASSUME_NONNULL_END

@implementation BBKConnectionCoordinator

- (instancetype)initWithDelegate:(id<BBKConnectionCoordinatorDelegate>)delegate
{
    self = [super init];
    
    if (self) {
        self.manager = [BBKHTTPSessionManager manager];
        self.delegate = delegate;
    }
    
    return self;
}

- (void)openWithCredentials:(BBKCredentials *)credentials
{
    [self signUp:credentials completionHandler:^(BBKPassphrase * _Nullable passphrase, NSError * _Nullable error) {
        if (error) {
            [self.delegate connectionCoordinator:self didReceiveFinalizationError:error];
            switch ([error code]) {
                case 1/* SMS 2fa */:
                    if (![self.delegate respondsToSelector:@selector(connectionCoordinator:requiresSMSAuthenticationWithMetadata:)]) {
                        NSError *error = nil;
                        [self.delegate connectionCoordinator:self didReceiveFinalizationError:error];
                    }
                    [self.delegate connectionCoordinator:self requiresSMSAuthenticationWithMetadata:nil];
                    break;
                case 2/*Email 2fa*/:
                    if (![self.delegate respondsToSelector:@selector(connectionCoordinator:requiresEmailAuthenticationWithMetadata:)]) {
                        NSError *error = nil;
                        [self.delegate connectionCoordinator:self requiresEmailAuthenticationWithMetadata:nil];
                    }
                    break;
                case 3/*External 2fa*/:
                    if (![self.delegate respondsToSelector:@selector(connectionCoordinator:requiresExternalAuthenticationWithMetadata:)]) {
                        NSError *error = nil;
                        [self.delegate connectionCoordinator:self requiresExternalAuthenticationWithMetadata:nil];
                    }
                    break;
                default:
                    
                    break;
            }
        } else {
                NSError *error = nil;
                [self.delegate connectionCoordinatorDidPromoteToComplete:nil];
        }
    }];
}

- (void)remakeWithPassphrase:(BBKPassphrase *)passphrase
{
    [self retrieveToken:passphrase completionHandler:^(NSObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            [self.delegate connectionCoordinator:self didReceiveFinalizationError:error];
        } else {
            [self.delegate connectionCoordinatorDidPromoteToComplete:nil];
        }
    }];
}

- (void)saveImmediately
{
    
}

- (void)submitOneTimeCode:(BBKOneTimeCode *)oneTimeCode
{
    
}

- (BOOL)isExpired
{
    return YES;
}

- (void)signUp:(BBKCredentials *)credentials
completionHandler:(BBKSignUpCompletionHandler)handler
{
    NSURL *baseURL = [NSURL URLWithString:@"asdasd"];
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL: baseURL];
    
    [manager POST:@"post" parameters:@{@"key":credentials} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  ...
        handler(nil, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //  ...
        handler(nil, error);
    }];
}

- (void)retrieveToken:(BBKPassphrase * _Nonnull)passphrase
    completionHandler:(BBKRetrieveTokenCompletionHandler)handler
{
    NSURL *baseURL = [NSURL URLWithString:@"asdasd"];
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL: baseURL];
    
    [manager POST:@"post" parameters:@{@"key":passphrase} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //  ...
        handler(nil, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //  ...
        handler(nil, error);
    }];
}

@end
