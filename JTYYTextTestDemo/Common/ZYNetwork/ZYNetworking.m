//
//  ZYNetworking.m
//  EHuaTuFramework
//
//  Created by JW on 2018/9/30.
//

#import "ZYNetworking.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"

@interface ZYNetworking ()

@end

static NSMutableArray      *requestTasks;

@implementation ZYNetworking

+ (ZYURLSessionTask *)requestWithType:(ZYRequestType)type urlString:(NSString *)urlString params:(NSDictionary *)params success:(ZYResponseSuccess)success fail:(ZYResponseFail)fail{
    if (urlString == nil){
        return nil;
    }
    
    ZYURLSessionTask *sessionTask = nil;
    AFHTTPSessionManager *manager = [self manager];
//    [manager.requestSerializer setValue:[EHTTrainManager sharedInstance].trainToken forHTTPHeaderField:@"Authorization"];
//
//     [manager.requestSerializer setValue:[EHTTrainManager sharedInstance].htToken forHTTPHeaderField:@"httoken"];
    
    if (type == ZYGet) {
        
        NSDictionary *body = params;
        NSMutableDictionary *paramsBody = [NSMutableDictionary dictionary];
        for (NSString *key in body) {
            if ([urlString containsString:[NSString stringWithFormat:@"%@={%@}",key,key]]) {
                urlString = [urlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@={%@}",key,key] withString:[NSString stringWithFormat:@"%@=%@",key,[body objectForKey:key]]];
            }else{
                [paramsBody setObject:[body objectForKey:key] forKey:key];
            }
            
        }
        JTLog(@"-->>GET请求>>>>%@\nheader-%@\nbody--%@", urlString,manager.requestSerializer.HTTPRequestHeaders,body);

        sessionTask = [manager GET:urlString parameters:paramsBody progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                [self successResponse:responseObject callback:success];
            }
            
//            if ([EHTTrainManager sharedInstance].forcedLogout) {
//                [EHTTrainManager sharedInstance].forcedLogout();
//            }
            
            [[self allTasks] removeObject:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            if (fail) {
                fail(error);
            }
//            [MBProgressHUD showErrorMessage:[NSString stringWithFormat:@"网络异常%ld",(long)error.code]];
            [[self allTasks] removeObject:task];
        }];
        
    }else if (type == ZYPost){
        JTLog(@"-->>POST请求>>>>%@\nheader-%@\nbody--%@", urlString,manager.requestSerializer.HTTPRequestHeaders,params);

        sessionTask = [manager POST:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
//            [MBProgressHUD hideHUD];
            
            if (success) {
                [self successResponse:responseObject callback:success];
            }
            
            [[self allTasks] removeObject:task];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
//            [MBProgressHUD hideHUD];
            
            if (fail) {
                fail(error);
            }
//            [MBProgressHUD showErrorMessage:[NSString stringWithFormat:@"网络异常%ld",(long)error.code]];
            [[self allTasks] removeObject:task];
        }];
        
    }
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}



//上传图片
+ (void)updateImageWithParams:(NSDictionary *)params url:(NSString *)url image:(UIImage *)image imageFile:(NSString *)imageFile success:(ZYResponseSuccess)success fail:(ZYResponseFail)fail{
    
    AFHTTPSessionManager *manager =[self manager];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageData = UIImagePNGRepresentation(image);
        float size = imageData.length/1024.0/1024.0;
        if (size >= 1) {
            imageData = UIImageJPEGRepresentation(image, 0.3);
        }else{
            imageData = UIImageJPEGRepresentation(image, 0.5);
        }
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        
        [formData appendPartWithFileData:imageData name:imageFile fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
//        NSLog(@"进度");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"上传成功");
        if (success) {
            [self successResponse:responseObject callback:success];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"上传失败");
        if (fail) {
            fail(error);
        }
    }];
}

///上传多张图片
+ (void)uploadImagesWithParams:(NSDictionary *)params url:(NSString *)url images:(NSArray<UIImage *> *)images success:(ZYResponseSuccess)success fail:(ZYResponseFail)fail {
    
    AFHTTPSessionManager *manager =[self manager];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj = [UIImage fixOrientation:obj];
            NSString *name = [NSString stringWithFormat:@"file%d", (int)idx];
            NSData *imageData = UIImagePNGRepresentation(obj);
            float size = imageData.length/1024.0/1024.0;
            if (size >= 1) {
                imageData = UIImageJPEGRepresentation(obj, 0.3);
                
            }else{
                imageData = UIImageJPEGRepresentation(obj, 0.5);
            }
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", [NSString randomStringWithLength:15]];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/jpeg"];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //        NSLog(@"进度");
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        NSLog(@"上传成功");
        if (success) {
            [self successResponse:responseObject callback:success];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"上传失败");
        if (fail) {
            fail(error);
        }
    }];
}


+ (id)tryToParseData:(id)responseData {
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            //            NSLog(@"--%@",error);
            if (error != nil) {
                return [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
            } else {
                return response;
            }
        }
    } else {
        return [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
    }
}

+ (BOOL)isJsonFormatData:(id)data{
    if ([data isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (data == nil) {
            return NO;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            //            NSLog(@"--%@",error);
            if (error != nil) {
                return NO;
            } else {
                return YES;
            }
        }
    } else {
        return NO;
    }
    
    
}


+ (void)successResponse:(id)responseData callback:(ZYResponseSuccess)success {
    if (success) {
        
        if (![self isJsonFormatData:responseData]) {//当返回格式不是json
//            [MBProgressHUD showErrorMessage:@"数据格式异常"];
            JTLog(@"异常格式数据:%@",[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
        }else{
            success([self tryToParseData:responseData],[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
        }
        
    }
}




#pragma 任务管理
+ (NSMutableArray *)allTasks{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasks == nil) {
            requestTasks = [[NSMutableArray alloc] init];
        }
    });
    return requestTasks;
}

+ (void)cancelAllRequest {
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(ZYURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[ZYURLSessionTask class]]) {
                [task cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
        
    };
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    
    @synchronized(self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(ZYURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[ZYURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                return;
            }
        }];
    };
}

+ (AFHTTPSessionManager *)manager{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        
        /*! 设置请求超时时间 */
        manager.requestSerializer.timeoutInterval = 20;
        
        /*! 打开状态栏的等待菊花 */
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        /*! 设置相应的缓存策略：此处选择不用加载也可以使用自动缓存【注：只有get方法才能用此缓存策略，NSURLRequestReturnCacheDataDontLoad】 */
        //        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        /*! 设置返回数据类型为 json, 分别设置请求以及相应的序列化器 */
        /*!
         json：[AFJSONResponseSerializer serializer](常用)
         http：[AFHTTPResponseSerializer serializer]
         */
        AFHTTPResponseSerializer *response = [AFHTTPResponseSerializer serializer];
        /*! 这里是去掉了键值对里空对象的键值 */
        //        response.removesKeysWithNullValues = YES;
        manager.responseSerializer = response;
        
        
        /* 设置请求服务器数类型式为 HTTP */
        /*!
         json：[AFJSONRequestSerializer serializer](常用)
         http：[AFHTTPRequestSerializer serializer]
         */
        AFHTTPRequestSerializer *request = [AFHTTPRequestSerializer serializer];
        request.stringEncoding = NSUTF8StringEncoding;
        manager.requestSerializer = request;
        
        
        /*! 设置apikey ------类似于自己应用中的token---此处仅仅作为测试使用*/
        //        [manager.requestSerializer setValue:apikey forHTTPHeaderField:@"apikey"];
        
        /*! 复杂的参数类型 需要使用json传值-设置请求内容的类型*/
        //        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        /*! 设置响应数据的基本类型 */
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/xml",@"text/plain", @"application/javascript", @"image/*", nil];
        
        /*! https 参数配置 */
        /*!
         采用默认的defaultPolicy就可以了. AFN默认的securityPolicy就是它, 不必另写代码. AFSecurityPolicy类中会调用苹果security.framework的机制去自行验证本次请求服务端放回的证书是否是经过正规签名.
         */
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        manager.securityPolicy = securityPolicy;
        
        /*! 自定义的CA证书配置如下： */
        /*! 自定义security policy, 先前确保你的自定义CA证书已放入工程Bundle */
        /*!
         https://api.github.com网址的证书实际上是正规CADigiCert签发的, 这里把Charles的CA根证书导入系统并设为信任后, 把Charles设为该网址的SSL Proxy (相当于"中间人"), 这样通过代理访问服务器返回将是由Charles伪CA签发的证书.
         */
        //        NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //        policy.allowInvalidCertificates = YES;
        //        manager.securityPolicy = policy;
        
        /*! 如果服务端使用的是正规CA签发的证书, 那么以下几行就可去掉: */
        //        NSSet <NSData *> *cerSet = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
        //        AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate withPinnedCertificates:cerSet];
        //        policy.allowInvalidCertificates = YES;
        //        manager.securityPolicy = policy;
    });
    
    return manager;
}

@end
