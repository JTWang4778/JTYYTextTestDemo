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

+ (NSString *)removeSpaceAndNewline:(NSString *)str{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}

+ (BOOL)isUrlAddress:(NSString*)url{
    NSString * reg = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate * urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return [urlPredicate evaluateWithObject:url];
}

@end
