//
//  BBKOneTimeCode.h
//  BuyBuddyKit
//
//  Created by Emir Çiftçioğlu on 12.04.2018.
//  Copyright © 2018 BuyBuddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBKOneTimeCode : NSObject

@property (nonatomic, strong, nonnull, readwrite) NSString *content;

- (instancetype _Nonnull)initWithString:(NSString *)string NS_DESIGNATED_INITIALIZER;
- (instancetype _Nonnull)init;

@end
