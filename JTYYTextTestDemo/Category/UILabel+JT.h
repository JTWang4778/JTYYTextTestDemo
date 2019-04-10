//
//  UILabel+JT.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JT)
/// 快速创建UILabel实例
+ (UILabel *)creatWithFont:(UIFont *)font TextColor:(UIColor *)color Alignment:(NSTextAlignment)ali Text: (NSString *)text;
@end

NS_ASSUME_NONNULL_END
