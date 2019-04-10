//
//  UIView+JT.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JT)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGFloat bottom;
//添加边框:四边
-(void)setBorder:(UIColor *)color width:(CGFloat)width;
//视图变圆
+(void)makeViewCycleSharp:(UIView *)view;
//返回视图的高
+(CGFloat)viewHeight;

-(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
