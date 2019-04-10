//
//  UIImage+JT.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JT)

+(UIImage *)createImageWithColor:(UIColor *)color;

+(UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect;

+(UIImage *)imageWithImage:(UIImage *)image scaleToSize:(CGSize)size;

+ (CGSize)getImageSizeWithURL:(id)URL;


/**
 加载图片资源抽象方法， 内部可以配置加载指定bundle的资源，也可以是本地Assets资源
 */
+ (UIImage *)jt_bundleImageWithBundleName:(NSString *)bundleName ImageName:(NSString *)imageName;
+ (UIImage*)fixOrientation:(UIImage*)image;


#pragma mark - emoji编码
// emoji编码
@property (nonatomic,copy)NSString *code;
@end

NS_ASSUME_NONNULL_END
