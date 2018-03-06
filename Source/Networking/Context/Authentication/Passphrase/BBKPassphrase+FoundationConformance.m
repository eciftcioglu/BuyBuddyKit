// BBKPassphrase+FoundationConformance.m
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

#import "BBKPassphrase+FoundationConformance.h"

@implementation BBKPassphrase (FoundationConformance)

#pragma mark - Secure coding conformance

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithID:[aDecoder decodeObjectForKey:@"ID"]
                    passkey:[aDecoder decodeObjectForKey:@"passkey"]
                  issueDate:[aDecoder decodeObjectForKey:@"issueDate"]
                      owner:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.passkey forKey:@"passkey"];
    [aCoder encodeObject:self.issueDate forKey:@"issueDate"];
}

#pragma mark - Copying conformance

- (id)copyWithZone:(NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithID:self.ID
                                                 passkey:self.passkey
                                               issueDate:self.issueDate
                                                   owner:self.owner];
}

#pragma mark - Comparison

- (BOOL)isEqualToPassphrase:(BBKPassphrase *)passphrase
{
    return [self.ID isEqualToNumber:passphrase.ID];
}

- (BOOL)isEqualTo:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    __weak typeof(self) rhs = (typeof(self))object;
    
    return [self isEqualToPassphrase:rhs];
}

#pragma mark - Hashing

- (NSUInteger)hash
{
    return [self.ID unsignedLongLongValue];
}

@end
