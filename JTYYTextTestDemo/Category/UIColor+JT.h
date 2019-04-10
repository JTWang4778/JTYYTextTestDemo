//
//  UIColor+JT.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JT)

+ (UIColor *)jt_colorWithHexString:(NSString *)hexColorString;
/**
*  十六进制颜色
*/
+ (UIColor *)hexColorWith:(NSString *)hexColorString;
/**
 *  十六进制颜色:含alpha
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha;

/**
 *  随机颜色
 *
 *  @return UIColor
 */
+ (UIColor *)randomColor;

@end

NS_ASSUME_NONNULL_END
