// BBKSecurityPolicyTests.m
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
#import "BBKSecurityPolicy.h"

@interface BBKSecurityPolicyTests : BBKNetworkingTestCase

@end

static SecTrustRef BBKUTTrustChainForCertsInDirectory(NSString *directoryPath) {
    NSArray *certFileNames = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directoryPath error:nil];
    NSMutableArray *certs  = [NSMutableArray arrayWithCapacity:[certFileNames count]];
    for (NSString *path in certFileNames) {
        NSData *certData = [NSData dataWithContentsOfFile:[directoryPath stringByAppendingPathComponent:path]];
        SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
        [certs addObject:(__bridge_transfer id)(cert)];
    }

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    SecTrustCreateWithCertificates((__bridge CFTypeRef)(certs), policy, &trust);
    CFRelease(policy);

    return trust;
}

static SecTrustRef BBKUTHTTPBinOrgServerTrust() {
    NSString *bundlePath = [[NSBundle bundleForClass:[BBKSecurityPolicyTests class]] resourcePath];
    NSString *serverCertDirectoryPath = [bundlePath stringByAppendingPathComponent:@"HTTPBinOrgServerTrustChain"];

    return BBKUTTrustChainForCertsInDirectory(serverCertDirectoryPath);
}

static SecTrustRef BBKUTADNNetServerTrust() {
    NSString *bundlePath = [[NSBundle bundleForClass:[BBKSecurityPolicyTests class]] resourcePath];
    NSString *serverCertDirectoryPath = [bundlePath stringByAppendingPathComponent:@"ADNNetServerTrustChain"];

    return BBKUTTrustChainForCertsInDirectory(serverCertDirectoryPath);
}

static SecCertificateRef BBKUTHTTPBinOrgCertificate() {
    NSString *certPath = [[NSBundle bundleForClass:[BBKSecurityPolicyTests class]] pathForResource:@"httpbinorg_04112018" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef BBKUTLetsEncryptAuthorityCertificate() {
    NSString *certPath = [[NSBundle bundleForClass:NSClassFromString(@"BBKSecurityPolicyTests")] pathForResource:@"Let's Encrypt Authority X3" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];
    
    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef BBKUTDSTRootCertificate() {
    NSString *certPath = [[NSBundle bundleForClass:NSClassFromString(@"BBKSecurityPolicyTests")] pathForResource:@"DST Root CA X3" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];
    
    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef BBKUTSelfSignedCertificateWithoutDomain() {
    NSString *certPath = [[NSBundle bundleForClass:[BBKSecurityPolicyTests class]] pathForResource:@"NoDomains" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef BBKUTSelfSignedCertificateWithCommonNameDomain() {
    NSString *certPath = [[NSBundle bundleForClass:[BBKSecurityPolicyTests class]] pathForResource:@"foobar.com" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecCertificateRef BBKUTSelfSignedCertificateWithDNSNameDomain() {
    NSString *certPath = [[NSBundle bundleForClass:[BBKSecurityPolicyTests class]] pathForResource:@"AltName" ofType:@"cer"];
    NSCAssert(certPath != nil, @"Path for certificate should not be nil");
    NSData *certData = [NSData dataWithContentsOfFile:certPath];

    return SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(certData));
}

static SecTrustRef BBKUTTrustWithCertificate(SecCertificateRef certificate) {
    NSArray *certs  = @[(__bridge id)(certificate)];

    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust = NULL;
    SecTrustCreateWithCertificates((__bridge CFTypeRef)(certs), policy, &trust);
    CFRelease(policy);

    return trust;
}

@implementation BBKSecurityPolicyTests

#pragma mark - Default Policy Tests
#pragma mark Default Values Test

- (void)testDefaultPolicyPinningModeIsSetToNone {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    XCTAssertTrue(policy.SSLPinningMode == BBKSSLPinningModeNone, @"Pinning Mode should be set to by default");
}

- (void)testDefaultPolicyHasInvalidCertificatesAreDisabledByDefault {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    XCTAssertFalse(policy.allowInvalidCertificates, @"Invalid Certificates Should Be Disabled by Default");
}

- (void)testDefaultPolicyHasDomainNamesAreValidatedByDefault {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    XCTAssertTrue(policy.validatesDomainName, @"Domain names should be validated by default");
}

- (void)testDefaultPolicyHasNoPinnedCertificates {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    XCTAssertTrue(policy.pinnedCertificates.count == 0, @"The default policy should not have any pinned certificates");
}

#pragma mark Positive Server Trust Evaluation Tests

- (void)testDefaultPolicyDoesAllowHTTPBinOrgCertificate {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    SecTrustRef trust = BBKUTHTTPBinOrgServerTrust();
    XCTAssertTrue([policy evaluateServerTrust:trust forDomain:nil], @"Valid Certificate should be allowed by default.");
}

- (void)testDefaultPolicyDoesAllowHTTPBinOrgCertificateForValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    SecTrustRef trust = BBKUTHTTPBinOrgServerTrust();
    XCTAssertTrue([policy evaluateServerTrust:trust forDomain:@"httpbin.org"], @"Valid Certificate should be allowed by default.");
}

#pragma mark Negative Server Trust Evaluation Tests

- (void)testDefaultPolicyDoesNotAllowInvalidCertificate {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithoutDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);
    XCTAssertFalse([policy evaluateServerTrust:trust forDomain:nil], @"Invalid Certificates should not be allowed");
}

- (void)testDefaultPolicyDoesNotAllowCertificateWithInvalidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    SecTrustRef trust = BBKUTHTTPBinOrgServerTrust();
    XCTAssertFalse([policy evaluateServerTrust:trust forDomain:@"apple.com"], @"Certificate should not be allowed because the domain names do not match.");
}

#pragma mark - Public Key Pinning Tests
#pragma mark Default Values Tests

- (void)testPolicyWithPublicKeyPinningModeHasPinnedCertificates {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    XCTAssertTrue(policy.pinnedCertificates > 0, @"Policy should contain default pinned certificates");
}

- (void)testPolicyWithPublicKeyPinningModeHasHTTPBinOrgPinnedCertificate {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey withPinnedCertificates:[BBKSecurityPolicy certificatesInBundle:bundle]];

    SecCertificateRef cert = BBKUTHTTPBinOrgCertificate();
    NSData *certData = (__bridge NSData *)(SecCertificateCopyData(cert));
    CFRelease(cert);
    NSSet *set = [policy.pinnedCertificates objectsPassingTest:^BOOL(NSData *data, BOOL *stop) {
        return [data isEqualToData:certData];
    }];

    XCTAssertEqual(set.count, 1U, @"HTTPBin.org certificate not found in the default certificates");
}

#pragma mark Positive Server Trust Evaluation Tests
- (void)testPolicyWithPublicKeyPinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgLeafCertificatePinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];

    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow server trust");
}

- (void)testPolicyWithPublicKeyPinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgIntermediateCertificatePinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    
    SecCertificateRef certificate = BBKUTLetsEncryptAuthorityCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow server trust");
}

- (void)testPolicyWithPublicKeyPinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgRootCertificatePinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    
    SecCertificateRef certificate = BBKUTDSTRootCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow server trust");
}

- (void)testPolicyWithPublicKeyPinningAllowsHTTPBinOrgServerTrustWithEntireCertificateChainPinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    
    SecCertificateRef httpBinCertificate = BBKUTHTTPBinOrgCertificate();
    SecCertificateRef intermediateCertificate = BBKUTLetsEncryptAuthorityCertificate();
    SecCertificateRef rootCertificate = BBKUTDSTRootCertificate();
    [policy setPinnedCertificates:[NSSet setWithObjects:(__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate),
                                   (__bridge_transfer NSData *)SecCertificateCopyData(intermediateCertificate),
                                   (__bridge_transfer NSData *)SecCertificateCopyData(rootCertificate), nil]];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow HTTPBinOrg server trust because at least one of the pinned certificates is valid");
    
}

- (void)testPolicyWithPublicKeyPinningAllowsHTTPBirnOrgServerTrustWithHTTPbinOrgPinnedCertificateAndAdditionalPinnedCertificates {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    
    SecCertificateRef httpBinCertificate = BBKUTHTTPBinOrgCertificate();
    SecCertificateRef selfSignedCertificate = BBKUTSelfSignedCertificateWithCommonNameDomain();
    [policy setPinnedCertificates:[NSSet setWithObjects:(__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate),
                                   (__bridge_transfer NSData *)SecCertificateCopyData(selfSignedCertificate), nil]];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow HTTPBinOrg server trust because at least one of the pinned certificates is valid");
}

- (void)testPolicyWithPublicKeyPinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgLeafCertificatePinnedAndValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    
    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:@"httpbin.org"], @"Policy should allow server trust");
}

#pragma mark Negative Server Trust Evaluation Tests

- (void)testPolicyWithPublicKeyPinningAndNoPinnedCertificatesDoesNotAllowHTTPBinOrgServerTrust {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    policy.pinnedCertificates = [NSSet set];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should not allow server trust because the policy is set to public key pinning and it does not contain any pinned certificates.");
}

- (void)testPolicyWithPublicKeyPinningDoesNotAllowADNServerTrustWithHTTPBinOrgPinnedCertificate {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];

    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTADNNetServerTrust() forDomain:nil], @"Policy should not allow ADN server trust for pinned HTTPBin.org certificate");
}

- (void)testPolicyWithPublicKeyPinningDoesNotAllowHTTPBinOrgServerTrustWithHTTPBinOrgLeafCertificatePinnedAndInvalidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];

    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:@"invaliddomainname.com"], @"Policy should not allow server trust");
}

- (void)testPolicyWithPublicKeyPinningDoesNotAllowADNServerTrustWithMultipleInvalidPinnedCertificates {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];

    SecCertificateRef httpBinCertificate = BBKUTHTTPBinOrgCertificate();
    SecCertificateRef selfSignedCertificate = BBKUTSelfSignedCertificateWithCommonNameDomain();
    [policy setPinnedCertificates:[NSSet setWithObjects:(__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate),
                                                        (__bridge_transfer NSData *)SecCertificateCopyData(selfSignedCertificate), nil]];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTADNNetServerTrust() forDomain:nil], @"Policy should not allow ADN server trust because there are no matching pinned certificates");
}

#pragma mark - Certificate Pinning Tests
#pragma mark Default Values Tests

- (void)testPolicyWithCertificatePinningModeHasPinnedCertificates {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    XCTAssertTrue(policy.pinnedCertificates > 0, @"Policy should contain default pinned certificates");
}

- (void)testPolicyWithCertificatePinningModeHasHTTPBinOrgPinnedCertificate {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate withPinnedCertificates:[BBKSecurityPolicy certificatesInBundle:bundle]];

    SecCertificateRef cert = BBKUTHTTPBinOrgCertificate();
    NSData *certData = (__bridge NSData *)(SecCertificateCopyData(cert));
    CFRelease(cert);
    NSSet *set = [policy.pinnedCertificates objectsPassingTest:^BOOL(NSData *data, BOOL *stop) {
        return [data isEqualToData:certData];
    }];

    XCTAssertEqual(set.count, 1U, @"HTTPBin.org certificate not found in the default certificates");
}

#pragma mark Positive Server Trust Evaluation Tests
- (void)testPolicyWithCertificatePinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgLeafCertificatePinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];

    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow server trust");
}

- (void)testPolicyWithCertificatePinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgIntermediateCertificatePinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    
    SecCertificateRef certificate = BBKUTLetsEncryptAuthorityCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow server trust");
}

- (void)testPolicyWithCertificatePinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgRootCertificatePinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    
    SecCertificateRef certificate = BBKUTDSTRootCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow server trust");
}

- (void)testPolicyWithCertificatePinningAllowsHTTPBinOrgServerTrustWithEntireCertificateChainPinned {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    
    SecCertificateRef httpBinCertificate = BBKUTHTTPBinOrgCertificate();
    SecCertificateRef intermediateCertificate = BBKUTLetsEncryptAuthorityCertificate();
    SecCertificateRef rootCertificate = BBKUTDSTRootCertificate();
    [policy setPinnedCertificates:[NSSet setWithObjects:(__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate),
                                   (__bridge_transfer NSData *)SecCertificateCopyData(intermediateCertificate),
                                   (__bridge_transfer NSData *)SecCertificateCopyData(rootCertificate), nil]];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow HTTPBinOrg server trust because at least one of the pinned certificates is valid");
    
}

- (void)testPolicyWithCertificatePinningAllowsHTTPBirnOrgServerTrustWithHTTPbinOrgPinnedCertificateAndAdditionalPinnedCertificates {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    
    SecCertificateRef httpBinCertificate = BBKUTHTTPBinOrgCertificate();
    SecCertificateRef selfSignedCertificate = BBKUTSelfSignedCertificateWithCommonNameDomain();
    [policy setPinnedCertificates:[NSSet setWithObjects:(__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate),
                                   (__bridge_transfer NSData *)SecCertificateCopyData(selfSignedCertificate), nil]];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should allow HTTPBinOrg server trust because at least one of the pinned certificates is valid");
}

- (void)testPolicyWithCertificatePinningAllowsHTTPBinOrgServerTrustWithHTTPBinOrgLeafCertificatePinnedAndValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    
    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:@"httpbin.org"], @"Policy should allow server trust");
}

#pragma mark Negative Server Trust Evaluation Tests

- (void)testPolicyWithCertificatePinningAndNoPinnedCertificatesDoesNotAllowHTTPBinOrgServerTrust {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    policy.pinnedCertificates = [NSSet set];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:nil], @"Policy should not allow server trust because the policy does not contain any pinned certificates.");
}

- (void)testPolicyWithCertificatePinningDoesNotAllowADNServerTrustWithHTTPBinOrgPinnedCertificate {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];

    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTADNNetServerTrust() forDomain:nil], @"Policy should not allow ADN server trust for pinned HTTPBin.org certificate");
}

- (void)testPolicyWithCertificatePinningDoesNotAllowHTTPBinOrgServerTrustWithHTTPBinOrgLeafCertificatePinnedAndInvalidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];

    SecCertificateRef certificate = BBKUTHTTPBinOrgCertificate();
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(certificate)];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:@"invaliddomainname.com"], @"Policy should not allow server trust");
}

- (void)testPolicyWithCertificatePinningDoesNotAllowADNServerTrustWithMultipleInvalidPinnedCertificates {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];

    SecCertificateRef httpBinCertificate = BBKUTHTTPBinOrgCertificate();
    SecCertificateRef selfSignedCertificate = BBKUTSelfSignedCertificateWithCommonNameDomain();
    [policy setPinnedCertificates:[NSSet setWithObjects:(__bridge_transfer NSData *)SecCertificateCopyData(httpBinCertificate),
                                                        (__bridge_transfer NSData *)SecCertificateCopyData(selfSignedCertificate), nil]];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTADNNetServerTrust() forDomain:nil], @"Policy should not allow ADN server trust because there are no matching pinned certificates");
}

#pragma mark - Domain Name Validation Tests
#pragma mark Positive Evaluation Tests

- (void)testThatPolicyWithoutDomainNameValidationAllowsServerTrustWithInvalidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    [policy setValidatesDomainName:NO];
    XCTAssertTrue([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:@"invalid.org"], @"Policy should allow server trust because domain name validation is disabled");
}

- (void)testThatPolicyWithDomainNameValidationAndSelfSignedCommonNameCertificateAllowsServerTrust {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];

    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithCommonNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);
    [policy setPinnedCertificates:[NSSet setWithObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];
    [policy setAllowInvalidCertificates:YES];

    XCTAssertTrue([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should allow server trust");
}

- (void)testThatPolicyWithDomainNameValidationAndSelfSignedDNSCertificateAllowsServerTrust {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];

    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);
    [policy setPinnedCertificates:[NSSet setWithObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];
    [policy setAllowInvalidCertificates:YES];

    XCTAssertTrue([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should allow server trust");
}

#pragma mark Negative Evaluation Tests

- (void)testThatPolicyWithDomainNameValidationDoesNotAllowServerTrustWithInvalidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    XCTAssertFalse([policy evaluateServerTrust:BBKUTHTTPBinOrgServerTrust() forDomain:@"invalid.org"], @"Policy should not allow allow server trust");
}

- (void)testThatPolicyWithDomainNameValidationAndSelfSignedNoDomainCertificateDoesNotAllowServerTrust {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];

    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithoutDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);
    [policy setPinnedCertificates:[NSSet setWithObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];
    [policy setAllowInvalidCertificates:YES];

    XCTAssertFalse([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should not allow server trust");
}

#pragma mark - Self Signed Certificate Tests
#pragma mark Positive Test Cases

- (void)testThatPolicyWithInvalidCertificatesAllowedAllowsSelfSignedServerTrust {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];
    [policy setAllowInvalidCertificates:YES];

    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);

    XCTAssertTrue([policy evaluateServerTrust:trust forDomain:nil], @"Policy should allow server trust because invalid certificates are allowed");
}

- (void)testThatPolicyWithInvalidCertificatesAllowedAndValidPinnedCertificatesDoesAllowSelfSignedServerTrustForValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    [policy setAllowInvalidCertificates:YES];
    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);
    [policy setPinnedCertificates:[NSSet setWithObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];

    XCTAssertTrue([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should allow server trust because invalid certificates are allowed");
}

- (void)testThatPolicyWithInvalidCertificatesAllowedAndNoSSLPinningAndDomainNameValidationDisabledDoesAllowSelfSignedServerTrustForValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    [policy setValidatesDomainName:NO];

    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);

    XCTAssertTrue([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should allow server trust because invalid certificates are allowed");
}

#pragma mark Negative Test Cases

- (void)testThatPolicyWithInvalidCertificatesDisabledDoesNotAllowSelfSignedServerTrust {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy defaultPolicy];

    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);

    XCTAssertFalse([policy evaluateServerTrust:trust forDomain:nil], @"Policy should not allow server trust because invalid certificates are not allowed");
}

- (void)testThatPolicyWithInvalidCertificatesAllowedAndNoPinnedCertificatesAndPublicKeyPinningModeDoesNotAllowSelfSignedServerTrustForValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModePublicKey];
    [policy setAllowInvalidCertificates:YES];
    [policy setPinnedCertificates:[NSSet set]];
    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);

    XCTAssertFalse([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should not allow server trust because invalid certificates are allowed but there are no pinned certificates");
}

- (void)testThatPolicyWithInvalidCertificatesAllowedAndValidPinnedCertificatesAndNoPinningModeDoesNotAllowSelfSignedServerTrustForValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);
    [policy setPinnedCertificates:[NSSet setWithObject:(__bridge_transfer NSData *)SecCertificateCopyData(certificate)]];

    XCTAssertFalse([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should not allow server trust because invalid certificates are allowed but there are no pinned certificates");
}

- (void)testThatPolicyWithInvalidCertificatesAllowedAndNoValidPinnedCertificatesAndNoPinningModeAndDomainValidationDoesNotAllowSelfSignedServerTrustForValidDomainName {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    [policy setPinnedCertificates:[NSSet set]];

    SecCertificateRef certificate = BBKUTSelfSignedCertificateWithDNSNameDomain();
    SecTrustRef trust = BBKUTTrustWithCertificate(certificate);

    XCTAssertFalse([policy evaluateServerTrust:trust forDomain:@"foobar.com"], @"Policy should not allow server trust because invalid certificates are allowed but there are no pinned certificates");
}

#pragma mark - NSCopying
- (void)testThatPolicyCanBeCopied {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(BBKUTHTTPBinOrgCertificate())];

    BBKSecurityPolicy *copiedPolicy = [policy copy];
    XCTAssertNotEqual(copiedPolicy, policy);
    XCTAssertEqual(copiedPolicy.allowInvalidCertificates, policy.allowInvalidCertificates);
    XCTAssertEqual(copiedPolicy.validatesDomainName, policy.validatesDomainName);
    XCTAssertEqual(copiedPolicy.SSLPinningMode, policy.SSLPinningMode);
    XCTAssertTrue([copiedPolicy.pinnedCertificates isEqualToSet:policy.pinnedCertificates]);
}

- (void)testThatPolicyCanBeEncodedAndDecoded {
    BBKSecurityPolicy *policy = [BBKSecurityPolicy policyWithPinningMode:BBKSSLPinningModeCertificate];
    policy.allowInvalidCertificates = YES;
    policy.validatesDomainName = NO;
    policy.pinnedCertificates = [NSSet setWithObject:(__bridge_transfer id)SecCertificateCopyData(BBKUTHTTPBinOrgCertificate())];

    NSMutableData *archiveData = [NSMutableData new];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:archiveData];
    [archiver encodeObject:policy forKey:@"policy"];
    [archiver finishEncoding];

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archiveData];
    BBKSecurityPolicy *unarchivedPolicy = [unarchiver decodeObjectOfClass:[BBKSecurityPolicy class] forKey:@"policy"];

    XCTAssertNotEqual(unarchivedPolicy, policy);
    XCTAssertEqual(unarchivedPolicy.allowInvalidCertificates, policy.allowInvalidCertificates);
    XCTAssertEqual(unarchivedPolicy.validatesDomainName, policy.validatesDomainName);
    XCTAssertEqual(unarchivedPolicy.SSLPinningMode, policy.SSLPinningMode);
    XCTAssertTrue([unarchivedPolicy.pinnedCertificates isEqualToSet:policy.pinnedCertificates]);
}

@end
