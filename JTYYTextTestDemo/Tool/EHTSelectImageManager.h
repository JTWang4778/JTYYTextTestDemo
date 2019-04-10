//
//  EHTSelectImageManager.h
//  EHuaTuFramework
//
//  Created by Dale on 2018/11/27.
//  Copyright © 2018 JW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EHTSelectImageManager : NSObject

+ (instancetype)sharedSelectImageManager;

//允许选择最大图片数量
@property (nonatomic,assign) NSInteger maxImagesCount;
//选择的图片
@property (nonatomic,strong) NSMutableArray *selectedPhotos;
//选择图片后回调
@property (nonatomic,copy) void(^addImageBlock)(NSMutableArray *images);

//显示添加图片ActionSheet
- (void)addImages;
//删除其中一张图片
- (void)deleteImage:(NSInteger)tag;
//MARK: - 从相册中选择图片
- (void)selectImageFromAlbumFromDepartVC:(UIViewController *)departVC;

+ (void)deallocManager;

@end
