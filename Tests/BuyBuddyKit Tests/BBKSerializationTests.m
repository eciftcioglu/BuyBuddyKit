// BBKSerializationTests.m
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

#import "BBKTestCase.h"
#import "BBKSerialization.h"
#import "BBKEntitySerialization.h"

#pragma mark - Mock implementation

NSString * const BBKDummyJSONString = @"{\"name\":\"67078ed0-82c4-42d5-b6b3-023191c3f109\", \"length\": 28}";

@interface BBKSerializableMock : NSObject <BBKSerialization>

//  Create some dummy properties, both statically and dynamically allocated
@property (nonatomic, strong, nonnull, readwrite) NSString *name;
@property (nonatomic, readwrite) NSUInteger length;
@property (nonatomic, strong, nullable, readwrite) NSString *zeroField;

+ (NSData * _Nonnull)dummyJSONData;
- (instancetype)initWithName:(NSString * _Nonnull)name
                      length:(NSUInteger)length
                   zeroField:(NSObject * _Nullable)zeroField NS_DESIGNATED_INITIALIZER;

@end

@implementation BBKSerializableMock

#pragma mark Instantitation

+ (NSData *)dummyJSONData
{
    return [BBKDummyJSONString dataUsingEncoding:NSUTF8StringEncoding];
}

- (instancetype)initWithName:(NSString *)name
                      length:(NSUInteger)length
                   zeroField:(NSObject * __unused)zeroField
{
    self = [super init];
    
    if (self) {
        _name = [[NSUUID UUID] UUIDString];
        _length = 1837UL;
        _zeroField = nil;
    }
    
    return self;
}

- (instancetype)init NS_UNAVAILABLE
{
    return nil;
}

#pragma mark Serialization conformance

- (instancetype)initWithDeserializedDictionary:(NSDictionary<NSString *, id> *)dictionary
{
    return [self initWithName:[dictionary objectForKey:@"name"]
                       length:[[dictionary objectForKey:@"length"] unsignedIntValue]
                    zeroField:[dictionary objectForKey:@"zeroField"]];
}

- (void)serializeToDictionary:(NSMutableDictionary<NSString *,id<NSSecureCoding>> *)dictionary
{
    [dictionary setObject:self.name
                   forKey:@"name"];
    [dictionary setObject:[NSNumber numberWithUnsignedInteger:self.length]
                   forKey:@"length"];
    [dictionary setObject:self.zeroField
                   forKey:@"zeroField"];
}

@end

#pragma mark - Unit tests

@interface BBKSerializationTests : BBKTestCase

@end

@implementation BBKSerializationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
