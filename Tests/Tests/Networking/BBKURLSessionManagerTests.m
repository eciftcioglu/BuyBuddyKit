// BBKURLSessionManagerTests.m
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

#import <objc/runtime.h>

#import "BBKNetworkingTestCase.h"

#import "BBKURLSessionManager.h"

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
#define NSFoundationVersionNumber_With_Fixed_28588583_bug 0.0
#else
#define NSFoundationVersionNumber_With_Fixed_28588583_bug DBL_MAX
#endif


@interface BBKURLSessionManagerTests : BBKNetworkingTestCase
@property (readwrite, nonatomic, strong) BBKURLSessionManager *localManager;
@property (readwrite, nonatomic, strong) BBKURLSessionManager *backgroundManager;
@end

@implementation BBKURLSessionManagerTests

- (NSURLRequest *)bigImageURLRequest {
    NSURL *url = [NSURL URLWithString:@"http://scitechdaily.com/images/New-Image-of-the-Galaxy-Messier-94-also-Known-as-NGC-4736.jpg"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    return request;
}

- (void)setUp {
    [super setUp];
    self.localManager = [[BBKURLSessionManager alloc] init];
    [self.localManager.session.configuration.URLCache removeAllCachedResponses];

    //It was discovered that background sessions were hanging the test target
    //on iOS 10 and Xcode 8.
    //
    //rdar://28588583
    //
    //For now, we'll disable the unit tests for background managers until that can
    //be resolved
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_With_Fixed_28588583_bug) {
        NSString *identifier = [NSString stringWithFormat:@"com.buybuddy.tests.urlsession.%@", [[NSUUID UUID] UUIDString]];
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        self.backgroundManager = [[BBKURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    else {
        self.backgroundManager = nil;
    }
}

- (void)tearDown {
    [super tearDown];
    [self.localManager.session.configuration.URLCache removeAllCachedResponses];
    [self.localManager invalidateSessionCancelingTasks:YES];
    self.localManager = nil;
    
    [self.backgroundManager invalidateSessionCancelingTasks:YES];
    self.backgroundManager = nil;
}

#pragma mark Progress -

- (void)testDataTaskDoesReportDownloadProgress {
    NSURLSessionDataTask *task;

    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Progress should equal 1.0"];
    task = [self.localManager
            dataTaskWithRequest:[self bigImageURLRequest]
            uploadProgress:nil
            downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
                if (downloadProgress.fractionCompleted == 1.0) {
                    [expectation fulfill];
                }
            }
            completionHandler:nil];
    
    [task resume];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testDataTaskDownloadProgressCanBeKVOd {
    NSURLSessionDataTask *task;

    task = [self.localManager
            dataTaskWithRequest:[self bigImageURLRequest]
            uploadProgress:nil
            downloadProgress:nil
            completionHandler:nil];

        NSProgress *progress = [self.localManager downloadProgressForTask:task];
        [self keyValueObservingExpectationForObject:progress keyPath:@"fractionCompleted"
                                            handler:^BOOL(NSProgress  *observedProgress, NSDictionary * _Nonnull change) {
                                                double new = [change[@"new"] doubleValue];
                                                double old = [change[@"old"] doubleValue];
                                                return new == 1.0 && old != 0.0;
                                            }];
    [task resume];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testDownloadTaskDoesReportProgress {
    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Progress should equal 1.0"];
    NSURLSessionTask *task;
    task = [self.localManager
            downloadTaskWithRequest:[self bigImageURLRequest]
            progress:^(NSProgress * _Nonnull downloadProgress) {
                if (downloadProgress.fractionCompleted == 1.0) {
                    [expectation fulfill];
                }
            }
            destination:nil
            completionHandler:nil];
    [task resume];
    [self waitForExpectationsWithCommonTimeout];
}

// iOS 7 has a bug that may return nil for a session. To simulate that, nil out the
// session and it will return nil itself.
- (void)testFileUploadTaskReturnsNilWithBug {
    [self.localManager setValue:nil forKey:@"session"];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
    XCTAssertNil([self.localManager uploadTaskWithRequest:[NSURLRequest requestWithURL:self.baseURL]
                                                 fromFile:nil
                                                 progress:NULL
                                        completionHandler:NULL],
                 @"Upload task should be nil.");
#pragma GCC diagnostic pop
}

- (void)testUploadTaskDoesReportProgress {
    NSMutableString *payload = [NSMutableString stringWithString:@"BBKNetworking"];
    while ([payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < 20000) {
        [payload appendString:@"BBKNetworking"];
    }

    NSURL *url = [NSURL URLWithString:[[self.baseURL absoluteString] stringByAppendingString:@"/post"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];

    __weak XCTestExpectation *expectation = [self expectationWithDescription:@"Progress should equal 1.0"];

    NSURLSessionTask *task;
    task = [self.localManager
            uploadTaskWithRequest:request
            fromData:[payload dataUsingEncoding:NSUTF8StringEncoding]
            progress:^(NSProgress * _Nonnull uploadProgress) {
                NSLog(@"%@", uploadProgress.localizedDescription);
                if (uploadProgress.fractionCompleted == 1.0) {
                    [expectation fulfill];
                }
            }
            completionHandler:nil];
    [task resume];
    [self waitForExpectationsWithCommonTimeout];
}

- (void)testUploadProgressCanBeKVOd {
    NSMutableString *payload = [NSMutableString stringWithString:@"BBKNetworking"];
    while ([payload lengthOfBytesUsingEncoding:NSUTF8StringEncoding] < 20000) {
        [payload appendString:@"BBKNetworking"];
    }

    NSURL *url = [NSURL URLWithString:[[self.baseURL absoluteString] stringByAppendingString:@"/post"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];

    NSURLSessionTask *task;
    task = [self.localManager
            uploadTaskWithRequest:request
            fromData:[payload dataUsingEncoding:NSUTF8StringEncoding]
            progress:nil
            completionHandler:nil];

    NSProgress *uploadProgress = [self.localManager uploadProgressForTask:task];
    [self keyValueObservingExpectationForObject:uploadProgress keyPath:NSStringFromSelector(@selector(fractionCompleted)) expectedValue:@(1.0)];

    [task resume];
    [self waitForExpectationsWithCommonTimeout];
}

#pragma mark - rdar://17029580

- (void)testRDAR17029580IsFixed {
    //https://github.com/BBKNetworking/BBKNetworking/issues/2093
    //https://github.com/BBKNetworking/BBKNetworking/pull/3205
    //http://openradar.appspot.com/radar?id=5871104061079552
    dispatch_queue_t serial_queue = dispatch_queue_create("com.alamofire.networking.test.RDAR17029580", DISPATCH_QUEUE_SERIAL);
    NSMutableArray *taskIDs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 100; i++) {
        XCTestExpectation *expectation = [self expectationWithDescription:@"Wait for task creation"];
        __block NSURLSessionTask *task;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            task = [self.localManager
                    dataTaskWithRequest:[NSURLRequest requestWithURL:self.baseURL]
                    uploadProgress:nil
                    downloadProgress:nil
                    completionHandler:nil];
            dispatch_sync(serial_queue, ^{
                XCTAssertFalse([taskIDs containsObject:@(task.taskIdentifier)]);
                [taskIDs addObject:@(task.taskIdentifier)];
            });
            [task cancel];
            [expectation fulfill];
        });
    }
    [self waitForExpectationsWithCommonTimeout];
}

#pragma mark - Issue #2702 Tests
// The following tests are all releated to issue #2702

- (void)testDidResumeNotificationIsReceivedByLocalDataTaskAfterResume {
    NSURLSessionDataTask *task = [self.localManager dataTaskWithRequest:[self _delayURLRequest]
                                                         uploadProgress:nil
                                                       downloadProgress:nil
                                                      completionHandler:nil];
    [self _testResumeNotificationForTask:task];
}

- (void)testDidSuspendNotificationIsReceivedByLocalDataTaskAfterSuspend {
    NSURLSessionDataTask *task = [self.localManager dataTaskWithRequest:[self _delayURLRequest]
                                                         uploadProgress:nil
                                                       downloadProgress:nil
                                                      completionHandler:nil];
    [self _testSuspendNotificationForTask:task];
}

- (void)testDidResumeNotificationIsReceivedByBackgroundDataTaskAfterResume {
    if (self.backgroundManager) {
        NSURLSessionDataTask *task = [self.backgroundManager dataTaskWithRequest:[self _delayURLRequest]
                                                                  uploadProgress:nil
                                                                downloadProgress:nil
                                                               completionHandler:nil];
        [self _testResumeNotificationForTask:task];
    }
}

- (void)testDidSuspendNotificationIsReceivedByBackgroundDataTaskAfterSuspend {
    if (self.backgroundManager) {
        NSURLSessionDataTask *task = [self.backgroundManager dataTaskWithRequest:[self _delayURLRequest]
                                                                  uploadProgress:nil
                                                                downloadProgress:nil
                                                               completionHandler:nil];
        [self _testSuspendNotificationForTask:task];
    }
}

- (void)testDidResumeNotificationIsReceivedByLocalUploadTaskAfterResume {
    NSURLSessionUploadTask *task = [self.localManager uploadTaskWithRequest:[self _delayURLRequest]
                                                                   fromData:[NSData data]
                                                                   progress:nil
                                                          completionHandler:nil];
    [self _testResumeNotificationForTask:task];
}

- (void)testDidSuspendNotificationIsReceivedByLocalUploadTaskAfterSuspend {
    NSURLSessionUploadTask *task = [self.localManager uploadTaskWithRequest:[self _delayURLRequest]
                                                                   fromData:[NSData data]
                                                                   progress:nil
                                                          completionHandler:nil];
    [self _testSuspendNotificationForTask:task];
}

- (void)testDidResumeNotificationIsReceivedByBackgroundUploadTaskAfterResume {
    if (self.backgroundManager) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
        NSURLSessionUploadTask *task = [self.backgroundManager uploadTaskWithRequest:[self _delayURLRequest]
                                                                            fromFile:nil
                                                                            progress:nil
                                                                   completionHandler:nil];
#pragma clang diagnostic pop
        [self _testResumeNotificationForTask:task];
    }
}

- (void)testDidSuspendNotificationIsReceivedByBackgroundUploadTaskAfterSuspend {
    if (self.backgroundManager) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
        NSURLSessionUploadTask *task = [self.backgroundManager uploadTaskWithRequest:[self _delayURLRequest]
                                                                            fromFile:nil
                                                                            progress:nil
                                                                   completionHandler:nil];
#pragma clang diagnostic pop
        [self _testSuspendNotificationForTask:task];
    }
}

- (void)testDidResumeNotificationIsReceivedByLocalDownloadTaskAfterResume {
    NSURLSessionDownloadTask *task = [self.localManager downloadTaskWithRequest:[self _delayURLRequest]
                                                                progress:nil
                                                             destination:nil
                                                       completionHandler:nil];
    [self _testResumeNotificationForTask:task];
}

- (void)testDidSuspendNotificationIsReceivedByLocalDownloadTaskAfterSuspend {
    NSURLSessionDownloadTask *task = [self.localManager downloadTaskWithRequest:[self _delayURLRequest]
                                                                progress:nil
                                                             destination:nil
                                                       completionHandler:nil];
    [self _testSuspendNotificationForTask:task];
}

- (void)testDidResumeNotificationIsReceivedByBackgroundDownloadTaskAfterResume {
    if (self.backgroundManager) {
        NSURLSessionDownloadTask *task = [self.backgroundManager downloadTaskWithRequest:[self _delayURLRequest]
                                                                                progress:nil
                                                                             destination:nil
                                                                       completionHandler:nil];
        [self _testResumeNotificationForTask:task];
    }
}

- (void)testDidSuspendNotificationIsReceivedByBackgroundDownloadTaskAfterSuspend {
    if (self.backgroundManager) {
        NSURLSessionDownloadTask *task = [self.backgroundManager downloadTaskWithRequest:[self _delayURLRequest]
                                                                                progress:nil
                                                                             destination:nil
                                                                       completionHandler:nil];
        [self _testSuspendNotificationForTask:task];
    }
}

- (void)testSwizzlingIsProperlyConfiguredForDummyClass {
    IMP originalBBKResumeIMP = [self _originalBBKResumeImplementation];
    IMP originalBBKSuspendIMP = [self _originalBBKSuspendImplementation];
    XCTAssert(originalBBKResumeIMP, @"Swizzled af_resume Method Not Found");
    XCTAssert(originalBBKSuspendIMP, @"Swizzled af_suspend Method Not Found");
    XCTAssertNotEqual(originalBBKResumeIMP, originalBBKSuspendIMP, @"af_resume and af_suspend should not be equal");
}

- (void)testSwizzlingIsWorkingAsExpectedForForegroundDataTask {
    NSURLSessionTask *task = [self.localManager dataTaskWithRequest:[self _delayURLRequest]
                                                     uploadProgress:nil
                                                   downloadProgress:nil
                                                  completionHandler:nil];
    [self _testSwizzlingForTask:task];
    [task cancel];
}

- (void)testSwizzlingIsWorkingAsExpectedForForegroundUpload {
    NSURLSessionTask *task = [self.localManager uploadTaskWithRequest:[self _delayURLRequest]
                                                        fromData:[NSData data]
                                                        progress:nil
                                               completionHandler:nil];
    [self _testSwizzlingForTask:task];
    [task cancel];
}

- (void)testSwizzlingIsWorkingAsExpectedForForegroundDownload {
    NSURLSessionTask *task = [self.localManager downloadTaskWithRequest:[self _delayURLRequest]
                                                          progress:nil
                                                       destination:nil
                                                 completionHandler:nil];
    [self _testSwizzlingForTask:task];
    [task cancel];
}

- (void)testSwizzlingIsWorkingAsExpectedForBackgroundDataTask {
    //iOS 7 doesn't let us use a background manager in these tests, so reference these
    //classes directly. There are tests below to confirm background manager continues
    //to return the exepcted classes going forward. If those fail in a future iOS version,
    //it should point us to a problem here.
    [self _testSwizzlingForTaskClass:NSClassFromString(@"__NSCFBackgroundDataTask")];
}

- (void)testSwizzlingIsWorkingAsExpectedForBackgroundUploadTask {
    //iOS 7 doesn't let us use a background manager in these tests, so reference these
    //classes directly. There are tests below to confirm background manager continues
    //to return the exepcted classes going forward. If those fail in a future iOS version,
    //it should point us to a problem here.
    [self _testSwizzlingForTaskClass:NSClassFromString(@"__NSCFBackgroundUploadTask")];
}

- (void)testSwizzlingIsWorkingAsExpectedForBackgroundDownloadTask {
    //iOS 7 doesn't let us use a background manager in these tests, so reference these
    //classes directly. There are tests below to confirm background manager continues
    //to return the exepcted classes going forward. If those fail in a future iOS version,
    //it should point us to a problem here.
    [self _testSwizzlingForTaskClass:NSClassFromString(@"__NSCFBackgroundDownloadTask")];
}

- (void)testBackgroundManagerReturnsExpectedClassForDataTask {
    if (self.backgroundManager) {
        NSURLSessionTask *task = [self.backgroundManager dataTaskWithRequest:[self _delayURLRequest]
                                                              uploadProgress:nil
                                                            downloadProgress:nil
                                                           completionHandler:nil];
        XCTAssert([NSStringFromClass([task class]) isEqualToString:@"__NSCFBackgroundDataTask"]);
        [task cancel];
    } else {
        NSLog(@"Unable to run %@ because self.backgroundManager is nil", NSStringFromSelector(_cmd));
    }
}

- (void)testBackgroundManagerReturnsExpectedClassForUploadTask {
    if (self.backgroundManager) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
        NSURLSessionTask *task = [self.backgroundManager uploadTaskWithRequest:[self _delayURLRequest]
                                                                      fromFile:nil
                                                                      progress:nil
                                                             completionHandler:nil];
#pragma clang diagnostic pop
        XCTAssert([NSStringFromClass([task class]) isEqualToString:@"__NSCFBackgroundUploadTask"]);
        [task cancel];
    } else {
        NSLog(@"Unable to run %@ because self.backgroundManager is nil", NSStringFromSelector(_cmd));
    }
}

- (void)testBackgroundManagerReturnsExpectedClassForDownloadTask {
    if (self.backgroundManager) {
        NSURLSessionTask *task = [self.backgroundManager downloadTaskWithRequest:[self _delayURLRequest]
                                                                        progress:nil
                                                                     destination:nil
                                                               completionHandler:nil];
        XCTAssert([NSStringFromClass([task class]) isEqualToString:@"__NSCFBackgroundDownloadTask"]);
        [task cancel];
    } else {
        NSLog(@"Unable to run %@ because self.backgroundManager is nil", NSStringFromSelector(_cmd));
    }
}

#pragma mark - private

- (void)_testResumeNotificationForTask:(NSURLSessionTask *)task {
    [self expectationForNotification:BBKNetworkingTaskDidResumeNotification
                              object:nil
                             handler:nil];
    [task resume];
    [task suspend];
    [task resume];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    [task cancel];
}

- (void)_testSuspendNotificationForTask:(NSURLSessionTask *)task {
    [self expectationForNotification:BBKNetworkingTaskDidSuspendNotification
                              object:nil
                             handler:nil];
    [task resume];
    [task suspend];
    [task resume];
    [self waitForExpectationsWithTimeout:2.0 handler:nil];
    [task cancel];
}

- (NSURLRequest *)_delayURLRequest {
    return [NSURLRequest requestWithURL:self.delayURL];
}

- (IMP)_implementationForTask:(NSURLSessionTask  *)task selector:(SEL)selector {
    return [self _implementationForClass:[task class] selector:selector];
}

- (IMP)_implementationForClass:(Class)class selector:(SEL)selector {
    return method_getImplementation(class_getInstanceMethod(class, selector));
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
- (IMP)_originalBBKResumeImplementation {
    return method_getImplementation(class_getInstanceMethod(NSClassFromString(@"_BBKURLSessionTaskSwizzling"), @selector(BBKURLSessionResumeSwizzled)));
}

- (IMP)_originalBBKSuspendImplementation {
    return method_getImplementation(class_getInstanceMethod(NSClassFromString(@"_BBKURLSessionTaskSwizzling"), @selector(BBKURLSessionSuspendSwizzled)));
}

- (void)_testSwizzlingForTask:(NSURLSessionTask *)task {
    [self _testSwizzlingForTaskClass:[task class]];
}

- (void)_testSwizzlingForTaskClass:(Class)class {
    IMP originalBBKResumeIMP = [self _originalBBKResumeImplementation];
    IMP originalBBKSuspendIMP = [self _originalBBKSuspendImplementation];
    
    IMP taskResumeImp = [self _implementationForClass:class selector:@selector(resume)];
    IMP taskSuspendImp = [self _implementationForClass:class selector:@selector(suspend)];
    XCTAssertEqual(originalBBKResumeIMP, taskResumeImp, @"resume has not been properly swizzled for %@", NSStringFromClass(class));
    XCTAssertEqual(originalBBKSuspendIMP, taskSuspendImp, @"suspend has not been properly swizzled for %@", NSStringFromClass(class));
    
    IMP taskBBKResumeImp = [self _implementationForClass:class selector:@selector(BBKURLSessionResumeSwizzled)];
    IMP taskBBKSuspendImp = [self _implementationForClass:class selector:@selector(BBKURLSessionSuspendSwizzled)];
    XCTAssert(taskBBKResumeImp != NULL, @"af_resume is nil. Something has not been been swizzled right for %@", NSStringFromClass(class));
    XCTAssertNotEqual(taskBBKResumeImp, taskResumeImp, @"af_resume has not been properly swizzled for %@", NSStringFromClass(class));
    XCTAssert(taskBBKSuspendImp != NULL, @"af_suspend is nil. Something has not been been swizzled right for %@", NSStringFromClass(class));
    XCTAssertNotEqual(taskBBKSuspendImp, taskSuspendImp, @"af_suspend has not been properly swizzled for %@", NSStringFromClass(class));
}
#pragma clang diagnostic pop

@end
