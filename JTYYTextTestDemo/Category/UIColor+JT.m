//
//  UIColor+JT.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "UIColor+JT.h"

@implementation UIColor (JT)

+ (UIColor *)jt_colorWithHexString:(NSString *)hexColorString{
    return [self colorWithHexColorString:hexColorString alpha:1.0f];
}
#pragma mark  十六进制颜色
+ (UIColor *)hexColorWith:(NSString *)hexColorString{
    return [self colorWithHexColorString:hexColorString alpha:1.0f];
}

#pragma mark  十六进制颜色
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha{
    
    unsigned int red, green, blue;
    
    NSRange range;
    
    range.length =2;
    
    range.location =0;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&red];
    
    range.location =2;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&green];
    
    range.location =4;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *color = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
    
    return color;
}

/** 随机颜色 */
+ (UIColor *)randomColor
{
    CGFloat red = (arc4random() % 256) / 255.0;
    CGFloat green = (arc4random() % 256) / 255.0;
    CGFloat blue = (arc4random() % 256) / 255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}


@end
