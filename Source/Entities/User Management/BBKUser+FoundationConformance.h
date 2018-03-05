// BBKUser+FoundationConformance.h
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


#import "BBKUser.h"

@interface BBKUser (FoundationConformance) <NSSecureCoding, NSCopying>

/**
 @name Foundation Conformance
 */

/**
 Returns a Boolean value which indicates whether a given `BBKUser` instance is equal to the receiver using
 identifier-based comparison.
 
 #### Discussion
 
 This method compares two objects by checking their `ID` properties, it does not perform a lookup on its fetched
 properties. An updated `BBKUser` instance might be equal to an outdated `BBKUser` instance due to the similarity
 on their identifiers.
 
 #### Special Considerations
 
 If you use two objects referring to the same user on platform-level, you will need to maintain the synchronization
 of those two instances simultaneously.
 */
- (BOOL)isEqualToUser:(BBKUser *)user;

@end
