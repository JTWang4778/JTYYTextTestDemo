//
//  NSString+JT.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/7.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "NSString+JT.h"

@implementation NSString (JT)

+ (NSString *)randomStringWithLength:(NSInteger)len {
    NSString *letters = [NSUUID UUID].UUIDString;
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (NSInteger i = 0; i < len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)letters.length)]];
    }
    return randomString;
}

@end
