//
//  UIImage+JT.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "UIImage+JT.h"
#import <objc/runtime.h>


const void * AsssociationKey = &AsssociationKey;

@implementation UIImage (JT)
+(UIImage *)createImageWithColor:(UIColor *)color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(UIImage *)imageWithImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIImage *newImage = nil;
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 *  根据图片url获取网络图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

+ (UIImage*)fixOrientation:(UIImage*)image
{
    if (image.imageOrientation == UIImageOrientationUp)
        return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        {
            transform =CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform =CGAffineTransformRotate(transform,M_PI);
        }
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        {
            transform =CGAffineTransformTranslate(transform, image.size.width,0);
            transform =CGAffineTransformRotate(transform,M_PI_2);
        }
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            transform =CGAffineTransformTranslate(transform,0, image.size.height);
            transform =CGAffineTransformRotate(transform, -M_PI_2);
        }
            break;
        default:
            break;
    }
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        {
            transform =CGAffineTransformTranslate(transform, image.size.width,0);
            transform =CGAffineTransformScale(transform, -1,1);
        }
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        {
            transform =CGAffineTransformTranslate(transform, image.size.height,0);
            transform =CGAffineTransformScale(transform, -1,1);
        }
            break;
        default:
            break;
            
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL,image.size.width,image.size.height,CGImageGetBitsPerComponent(image.CGImage),0,CGImageGetColorSpace(image.CGImage),CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx,CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage*img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 加载图片资源抽象方法， 内部可以配置加载指定bundle的资源，也可以是本地Assets资源
 */
+ (UIImage *)jt_bundleImageWithBundleName:(NSString *)bundleName ImageName:(NSString *)imageName{
    if (bundleName == nil) {
        return [UIImage imageNamed:imageName];
    }else{
        
        return  [UIImage imageNamed:[NSString stringWithFormat:@"%@.bundle/%@",bundleName,imageName]];
//        NSString * path = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
//        NSBundle *bunle = [NSBundle bundleWithPath:path];
//        return  [UIImage imageNamed:imageName inBundle:bunle compatibleWithTraitCollection:nil];
    }
}

#pragma mark - emoji编码
- (void)setCode:(NSString *)code{
    objc_setAssociatedObject(self, AsssociationKey, code, OBJC_ASSOCIATION_COPY);
}


- (NSString *)code{
    return [objc_getAssociatedObject(self, AsssociationKey) stringValue];
}

@end
