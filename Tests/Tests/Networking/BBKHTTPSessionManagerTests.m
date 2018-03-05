// BBKHTTPSessionManagerTests.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
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

#import "BBKNetworkingTestCase.h"

#import "BBKHTTPSessionManager.h"
#import "BBKSecurityPolicy.h"

@interface BBKHTTPSessionManagerTests : BBKNetworkingTestCase
@property (readwrite, nonatomic, strong) BBKHTTPSessionManager *manager;
@end

@implementation BBKHTTPSessionManagerTests

- (void)setUp {
    [super setUp];
    self.manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:self.baseURL];
}

- (void)tearDown {
    [self.manager invalidateSessionCancelingTasks:YES];
    [super tearDown];
}

#pragma mark - init
- (void)testSharedManagerIsNotEqualToInitdManager {
    XCTAssertFalse([[BBKHTTPSessionManager manager] isEqual:self.manager]);
}

#pragma mark - misc

- (void)testThatOperationInvokesCompletionHandlerWithResponseObjectOnSuccess {
    __block id blockResponseObject = nil;
    __block id blockError = nil;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/get" relativeToURL:self.baseURL]];
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil
                                                 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        blockResponseObject = responseObject;
        blockError = error;
        [expectation fulfill];
    }];

    [task resume];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];

    XCTAssertTrue(task.state == NSURLSessionTaskStateCompleted);
    XCTAssertNil(blockError);
    XCTAssertNotNil(blockResponseObject);
}

- (void)testThatOperationInvokesFailureCompletionBlockWithErrorOnFailure {
    __block id blockError = nil;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/status/404" relativeToURL:self.baseURL]];
    NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil
                                                 completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        blockError = error;
        [expectation fulfill];
    }];

    [task resume];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];

    XCTAssertTrue(task.state == NSURLSessionTaskStateCompleted);
    XCTAssertNotNil(blockError);
}

- (void)testThatRedirectBlockIsCalledWhen302IsEncountered {
    __block BOOL success;
    __block NSError *blockError = nil;

    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    NSURLRequest *redirectRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"/redirect/1" relativeToURL:self.baseURL]];
    NSURLSessionDataTask *redirectTask = [self.manager dataTaskWithRequest:redirectRequest uploadProgress:nil downloadProgress:nil
                                                         completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        blockError = error;
        [expectation fulfill];
    }];

    [self.manager setTaskWillPerformHTTPRedirectionBlock:^NSURLRequest *(NSURLSession *session, NSURLSessionTask *task, NSURLResponse *response, NSURLRequest *request) {
        if (response) {
            success = YES;
        }

        return request;
    }];

    [redirectTask resume];

    [self waitForExpectationsWithTimeout:10.0 handler:nil];

    XCTAssertTrue(redirectTask.state == NSURLSessionTaskStateCompleted);
    XCTAssertNil(blockError);
    XCTAssertTrue(success);
}

- (void)testDownloadFileCompletionSpecifiesURLInCompletionWithManagerDidFinishBlock {
    __block BOOL managerDownloadFinishedBlockExecuted = NO;
    __block BOOL completionBlockExecuted = NO;
    __block NSURL *downloadFilePath = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    [self.manager setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
        managerDownloadFinishedBlockExecuted = YES;
        NSURL *dirURL  = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        return [dirURL URLByAppendingPathComponent:@"t1.file"];
    }];

    NSURLSessionDownloadTask *downloadTask;
    downloadTask = [self.manager
                    downloadTaskWithRequest:[NSURLRequest requestWithURL:self.baseURL]
                    progress:nil
                    destination:nil
                    completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                        downloadFilePath = filePath;
                        completionBlockExecuted = YES;
                        [expectation fulfill];
                    }];
    [downloadTask resume];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertTrue(completionBlockExecuted);
    XCTAssertTrue(managerDownloadFinishedBlockExecuted);
    XCTAssertNotNil(downloadFilePath);
}

- (void)testDownloadFileCompletionSpecifiesURLInCompletionBlock {
    __block BOOL destinationBlockExecuted = NO;
    __block BOOL completionBlockExecuted = NO;
    __block NSURL *downloadFilePath = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];

    NSURLSessionDownloadTask *downloadTask = [self.manager downloadTaskWithRequest:[NSURLRequest requestWithURL:self.baseURL]
                                                                          progress:nil
                                                                       destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                           destinationBlockExecuted = YES;
                                                                           NSURL *dirURL  = [[[NSFileManager defaultManager] URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
                                                                           return [dirURL URLByAppendingPathComponent:@"t1.file"];
                                                                       }
                                                                 completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                                                                     downloadFilePath = filePath;
                                                                     completionBlockExecuted = YES;
                                                                     [expectation fulfill];
                                                                 }];
    [downloadTask resume];
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
    XCTAssertTrue(completionBlockExecuted);
    XCTAssertTrue(destinationBlockExecuted);
    XCTAssertNotNil(downloadFilePath);
}

- (void)testThatSerializationErrorGeneratesErrorAndNullTaskForGET {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Serialization should fail"];

    [self.manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:@"Custom" code:-1 userInfo:nil];
        }
        return @"";
    }];

    NSURLSessionTask *nilTask;
    nilTask = [self.manager
               GET:@"test"
               parameters:@{@"key":@"value"}
               progress:nil
               success:nil
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   XCTAssertNil(task);
                   [expectation fulfill];
               }];
    XCTAssertNil(nilTask);
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

#pragma mark - NSCoding

- (void)testSupportsSecureCoding {
    XCTAssertTrue([BBKHTTPSessionManager supportsSecureCoding]);
}

- (void)testCanBeEncoded {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.manager];
    XCTAssertNotNil(data);
}

- (void)testCanBeDecoded {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.manager];
    BBKHTTPSessionManager *newManager = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(newManager.securityPolicy);
    XCTAssertNotNil(newManager.requestSerializer);
    XCTAssertNotNil(newManager.responseSerializer);
    XCTAssertNotNil(newManager.baseURL);
    XCTAssertNotNil(newManager.session);
    XCTAssertNotNil(newManager.session.configuration);
}

#pragma mark - NSCopying 

- (void)testCanBeCopied {
    BBKHTTPSessionManager *copyManager = [self.manager copy];
    XCTAssertNotNil(copyManager);
}

#pragma mark - Progress

- (void)testDownloadProgressIsReportedForGET {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Progress Should equal 1.0"];
    [self.manager
     GET:@"image"
     parameters:nil
     progress:^(NSProgress * _Nonnull downloadProgress) {
         if (downloadProgress.fractionCompleted == 1.0) {
             [expectation fulfill];
         }
     }
     success:nil
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testUploadProgressIsReportedForPOST {
    NSMutableString *payload = [NSMutableString stringWithString:@"BBKNetworking"];
    while ([payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < 20000) {
        [payload appendString:@"BBKNetworking"];
    }

    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Progress Should equal 1.0"];

    [self.manager
     POST:@"post"
     parameters:payload
     progress:^(NSProgress * _Nonnull uploadProgress) {
         if (uploadProgress.fractionCompleted == 1.0) {
             [expectation fulfill];
         }
     }
     success:nil
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testUploadProgressIsReportedForStreamingPost {
    NSMutableString *payload = [NSMutableString stringWithString:@"BBKNetworking"];
    while ([payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < 20000) {
        [payload appendString:@"BBKNetworking"];
    }

    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Progress Should equal 1.0"];

    [self.manager
     POST:@"post"
     parameters:nil
     constructingBodyWithBlock:^(id<BBKMultipartFormData>  _Nonnull formData) {
         [formData appendPartWithFileData:[payload dataUsingEncoding:NSUTF8StringEncoding] name:@"BBKNetworking" fileName:@"BBKNetworking" mimeType:@"text/html"];
     }
     progress:^(NSProgress * _Nonnull uploadProgress) {
         if (uploadProgress.fractionCompleted == 1.0) {
             [expectation fulfill];
         }
     }
     success:nil
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

# pragma mark - HTTP Status Codes

- (void)testThatSuccessBlockIsCalledFor200 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     GET:@"status/200"
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testThatFailureBlockIsCalledFor404 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     GET:@"status/404"
     parameters:nil
     progress:nil
     success:nil
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
         [expectation fulfill];
     }];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testThatResponseObjectIsEmptyFor204 {
    __block id urlResponseObject = nil;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     GET:@"status/204"
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         urlResponseObject = responseObject;
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
    XCTAssertNil(urlResponseObject);
}

#pragma mark - Rest Interface 

- (void)testGET {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     GET:@"get"
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertNotNil(responseObject);
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testHEAD {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     HEAD:@"get"
     parameters:nil
     success:^(NSURLSessionDataTask * _Nonnull task) {
         XCTAssertNotNil(task);
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testPOST {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     POST:@"post"
     parameters:@{@"key":@"value"}
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertTrue([responseObject[@"form"][@"key"] isEqualToString:@"value"]);
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testPOSTWithConstructingBody {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     POST:@"post"
     parameters:@{@"key":@"value"}
     constructingBodyWithBlock:^(id<BBKMultipartFormData>  _Nonnull formData) {
         [formData appendPartWithFileData:[@"Data" dataUsingEncoding:NSUTF8StringEncoding]
                                     name:@"DataName"
                                 fileName:@"DataFileName"
                                 mimeType:@"data"];
     }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertTrue([responseObject[@"files"][@"DataName"] isEqualToString:@"Data"]);
         XCTAssertTrue([responseObject[@"form"][@"key"] isEqualToString:@"value"]);
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testPUT {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     PUT:@"put"
     parameters:@{@"key":@"value"}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertTrue([responseObject[@"form"][@"key"] isEqualToString:@"value"]);
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testDELETE {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     DELETE:@"delete"
     parameters:@{@"key":@"value"}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertTrue([responseObject[@"args"][@"key"] isEqualToString:@"value"]);
         [expectation fulfill];
     }
     failure:nil];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testPATCH {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
    [self.manager
     PATCH:@"patch"
     parameters:@{@"key":@"value"}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertTrue([responseObject[@"form"][@"key"] isEqualToString:@"value"]);
         [expectation fulfill];
     }
     failure:nil];

    [self waitForExpectationsWithCommonTimeout];
}

#pragma mark - Deprecated Rest Interface

- (void)testDeprecatedGET {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.manager
     GET:@"get"
     parameters:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertNotNil(responseObject);
         [expectation fulfill];
     }
     failure:nil];
#pragma clang diagnostic pop
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testDeprecatedPOST {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.manager
     POST:@"post"
     parameters:@{@"key":@"value"}
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertTrue([responseObject[@"form"][@"key"] isEqualToString:@"value"]);
         [expectation fulfill];
     }
     failure:nil];
#pragma clang diagnostic pop
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testDeprecatedPOSTWithConstructingBody {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should succeed"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.manager
     POST:@"post"
     parameters:@{@"key":@"value"}
     constructingBodyWithBlock:^(id<BBKMultipartFormData>  _Nonnull formData) {
         [formData appendPartWithFileData:[@"Data" dataUsingEncoding:NSUTF8StringEncoding]
                                     name:@"DataName"
                                 fileName:@"DataFileName"
                                 mimeType:@"data"];
     }
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTAssertTrue([responseObject[@"files"][@"DataName"] isEqualToString:@"Data"]);
         XCTAssertTrue([responseObject[@"form"][@"key"] isEqualToString:@"value"]);
         [expectation fulfill];
     }
     failure:nil];
#pragma clang diagnostic pop    
    [self waitForExpectationsWithCommonTimeout];
}

#pragma mark - Auth

- (void)testHiddenBasicAuthentication {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Request should finish"];
    [self.manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"user" password:@"password"];
    [self.manager
     GET:@"hidden-basic-auth/user/password"
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [expectation fulfill];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         XCTFail(@"Request should succeed");
         [expectation fulfill];
     }];
    [self waitForExpectationsWithCommonTimeout];
}

# pragma mark - Security Policy

- (void)testValidSecureNoPinningSecurityPolicy {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://example.com"]];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeNone];
    XCTAssertNoThrow(manager.securityPolicy = securityPolicy);
}

- (void)testValidInsecureNoPinningSecurityPolicy {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://example.com"]];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeNone];
    XCTAssertNoThrow(manager.securityPolicy = securityPolicy);
}

- (void)testValidCertificatePinningSecurityPolicy {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://example.com"]];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    XCTAssertNoThrow(manager.securityPolicy = securityPolicy);
}

- (void)testInvalidCertificatePinningSecurityPolicy {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://example.com"]];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    XCTAssertThrowsSpecificNamed(manager.securityPolicy = securityPolicy, NSException, @"Invalid Security Policy");
}

- (void)testValidPublicKeyPinningSecurityPolicy {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://example.com"]];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    XCTAssertNoThrow(manager.securityPolicy = securityPolicy);
}

- (void)testInvalidPublicKeyPinningSecurityPolicy {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://example.com"]];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    XCTAssertThrowsSpecificNamed(manager.securityPolicy = securityPolicy, NSException, @"Invalid Security Policy");
}

- (void)testInvalidCertificatePinningSecurityPolicyWithoutBaseURL {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] init];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    XCTAssertThrowsSpecificNamed(manager.securityPolicy = securityPolicy, NSException, @"Invalid Security Policy");
}

- (void)testInvalidPublicKeyPinningSecurityPolicyWithoutBaseURL {
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] init];
    BBKSecurityPolicy *securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    XCTAssertThrowsSpecificNamed(manager.securityPolicy = securityPolicy, NSException, @"Invalid Security Policy");
}

# pragma mark - Server Trust

- (void)testInvalidServerTrustProducesCorrectErrorForCertificatePinning {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Request should fail"];
    NSURL *googleCertificateURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"google.com" withExtension:@"cer"];
    NSData *googleCertificateData = [NSData dataWithContentsOfURL:googleCertificateURL];
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://apple.com/"]];
    [manager setResponseSerializer:[BBKHTTPResponseSerializer serializer]];
    manager.securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate withPinnedCertificates:[NSSet setWithObject:googleCertificateData]];
    [manager
     GET:@""
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTFail(@"Request should fail");
         [expectation fulfill];
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
         XCTAssertEqual(error.code, NSURLErrorCancelled);
         [expectation fulfill];
     }];
    [self waitForExpectationsWithCommonTimeout];
    [manager invalidateSessionCancelingTasks:YES];
}

- (void)testInvalidServerTrustProducesCorrectErrorForPublicKeyPinning {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Request should fail"];
    NSURL *googleCertificateURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"google.com" withExtension:@"cer"];
    NSData *googleCertificateData = [NSData dataWithContentsOfURL:googleCertificateURL];
    BBKHTTPSessionManager *manager = [[BBKHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://apple.com/"]];
    [manager setResponseSerializer:[BBKHTTPResponseSerializer serializer]];
    manager.securityPolicy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey withPinnedCertificates:[NSSet setWithObject:googleCertificateData]];
    [manager
     GET:@""
     parameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         XCTFail(@"Request should fail");
         [expectation fulfill];
     }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         XCTAssertEqualObjects(error.domain, NSURLErrorDomain);
         XCTAssertEqual(error.code, NSURLErrorCancelled);
         [expectation fulfill];
     }];
    [self waitForExpectationsWithCommonTimeout];
    [manager invalidateSessionCancelingTasks:YES];
}

@end
