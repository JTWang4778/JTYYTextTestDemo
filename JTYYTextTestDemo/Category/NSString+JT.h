//
//  NSString+JT.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/7.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JT)

/**
 返回指定长度的随机字符串

 @param len
 @return 
 */
+ (NSString *)randomStringWithLength:(NSInteger)len;


/**
 去除字符串中所有空格和换行

 @param str
 @return
 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str;


/**
 判断是否是正确的网址

 @param url <#url description#>
 @return <#return value description#>
 */
+ (BOOL)isUrlAddress:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
