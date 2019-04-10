//
//  JTCommonDefine.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//
/*
    公共定义文件。  存放
 */

#ifndef JTCommonDefine_h
#define JTCommonDefine_h

// 屏幕宽高和各种高度

// 屏幕宽度，会根据横竖屏的变化而变化
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
// 屏幕高度，会根据横竖屏的变化而变化
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define Is_iPhoneX_iPhoneXS_iPhoneXR ([UIScreen mainScreen].bounds.size.height >=812.0f ?YES : NO)
#define StatusBarHeight    ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define NavigationBarHeight ((CGFloat)40)
#define StatusAndNaviBarHeight (StatusBarHeight + NavigationBarHeight)
#define BottomSafeHeight   (CGFloat)(Is_iPhoneX_iPhoneXS_iPhoneXR ?(34):(0))
#define TabBarHeight ((CGFloat)49)
#define TabBarAndBottomSafeHeight (TabBarHeight + BottomSafeHeight)

// 字体的宏
#define UIFontMake(size) [UIFont systemFontOfSize:size]
#define UIFontBoldMake(size) [UIFont boldSystemFontOfSize:size]

// 颜色的宏
#define ThemeColor [UIColor whiteColor]
// 根据屏幕宽动态适配
#define kRealValueWidthIn6(w) (([UIScreen mainScreen].bounds.size.width/375.0)*(w))
// 弱引用
#define WEAKSELF __weak typeof(self) weakSelf = self;

#ifdef DEBUG //开发阶段
#define JTLog(format,...) printf("JTLog-[%s %s] FUNCTION:%s [Line %d] %s\n",__DATE__,__TIME__, __PRETTY_FUNCTION__,__LINE__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else //发布阶段
#define JTLog(...)
#endif

#endif /* JTCommonDefine_h */
