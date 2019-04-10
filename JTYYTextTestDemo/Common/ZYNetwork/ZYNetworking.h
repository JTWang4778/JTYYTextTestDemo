//
//  ZYNetworking.h
//  EHuaTuFramework
//
//  Created by JW on 2018/9/30.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZYRequestType) {
    ZYGet = 1,
    ZYPost = 2
};

/*! 定义请求成功的 block */
typedef void( ^ZYResponseSuccess)(id responseObject, NSString *stringData);
/*! 定义请求失败的 block */
typedef void( ^ZYResponseFail)(NSError *error);

/**
 *  请求任务
 */
typedef NSURLSessionTask ZYURLSessionTask;

@interface ZYNetworking : NSObject


+ (ZYURLSessionTask *)requestWithType:(ZYRequestType)type
                            urlString:(NSString *)urlString
                               params:(NSDictionary *)params
                              success:(ZYResponseSuccess)success
                                 fail:(ZYResponseFail)fail;

//上传多张图片
+ (void)uploadImagesWithParams:(NSDictionary *)params url:(NSString *)url images:(NSArray<UIImage *> *)images success:(ZYResponseSuccess)success fail:(ZYResponseFail)fail;

+ (void)cancelRequestWithURL:(NSString *)url;


@end
