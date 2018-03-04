// BBKTransactionHandle.m
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

#import "BBKTransactionHandle.h"

@interface BBKTransactionHandle ()

@property (nonatomic, strong, readwrite, nonnull) NSURL *URL;
@property (nonatomic, strong, readwrite, nonnull) NSURLSession *URLSession;
@property (nonatomic, strong, readwrite, nonnull) NSMutableURLRequest *request;

@end

@implementation BBKTransactionHandle

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    
    if (self) {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        self.URL = URL;
        self.URLSession = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                        delegate:self
                                                   delegateQueue:nil];
        
        self.request = [NSMutableURLRequest requestWithURL:self.URL];
        self.request.HTTPMethod = @"GET";
    }
    
    return self;
}

- (void)run
{
    NSURLSessionDataTask *task = [self.URLSession dataTaskWithRequest:self.request];
    
    [task resume];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    NSDate *domainResolutionStartDate = [[[metrics transactionMetrics] objectAtIndex:0] domainLookupStartDate];
    NSDate *domainResolutionEndDate = [[[metrics transactionMetrics] objectAtIndex:0] domainLookupEndDate];
    
    NSTimeInterval interval = [domainResolutionEndDate timeIntervalSinceDate:domainResolutionStartDate];
    
    NSLog(@"%f", interval);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    NSString *body = [[task response] debugDescription];
    
    NSLog(@"%@", body);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
