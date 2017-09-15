// BBKUser+FoundationConformance.m
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


#import "BBKUser+FoundationConformance.h"

@implementation BBKUser (FoundationConformance)

#pragma mark - Secure coding conformance

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithID:[aDecoder decodeObjectForKey:@"ID"]
                      email:[aDecoder decodeObjectForKey:@"email"]
              bindToContext:nil];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.email forKey:@"email"];
    
    if (self.boundContext) {
        NSLog(@"Encoding object %@ which is bound to the context %@, decoding will result in lost information of context.", self, self.boundContext);
    }
}

#pragma mark - Copying conformance

- (id)copyWithZone:(NSZone *)zone
{
    return [[[super class] allocWithZone:zone] initWithID:self.ID
                                                    email:self.email
                                            bindToContext:self.boundContext];
}

#pragma mark - Comparison

- (BOOL)isEqualToUser:(BBKUser *)user
{
    return self.ID == user.ID;
}

- (BOOL)isEqual:(id)object
{
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    __weak typeof(self) rhs = (typeof(self))object;
    
    return self.ID == rhs.ID;
}

#pragma mark - Hashing

- (NSUInteger)hash
{
    return [self.ID unsignedLongLongValue];
}

@end


