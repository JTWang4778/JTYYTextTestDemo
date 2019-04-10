//
//  UILabel+JT.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "UILabel+JT.h"

@implementation UILabel (JT)

+ (UILabel *)creatWithFont:(UIFont *)font TextColor:(UIColor *)color Alignment:(NSTextAlignment)ali Text: (NSString *)text{
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    label.textAlignment = ali;
    label.text = text;
    return label;
}
@end
