//
//  EHTSelectImageManager.m
//  EHuaTuFramework
//
//  Created by Dale on 2018/11/27.
//  Copyright © 2018 JW. All rights reserved.
//

#import "EHTSelectImageManager.h"
#import "TZImagePickerController.h"

@interface EHTSelectImageManager()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic,strong) NSMutableArray *selectedAssets;
@property (nonatomic,strong) CLLocation *location;

@end

@implementation EHTSelectImageManager

static EHTSelectImageManager *singleton = nil;
+ (instancetype)sharedSelectImageManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleton == nil) {
            singleton = [[[self class] alloc] init];
        }
    });
    return singleton;
}
- (UIViewController *)ZYCurrentViewController{
    
    UIViewController *topViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    
    if ([topViewController isKindOfClass:[UITabBarController class]]) {
        
        topViewController = ((UITabBarController *)topViewController).selectedViewController;
    }
    
    if ([topViewController presentedViewController]) {
        
        topViewController = [topViewController presentedViewController];
    }
    
    if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController *)topViewController topViewController]) {
        
        return [(UINavigationController*)topViewController topViewController];
    }
    
    return topViewController;
}

- (void)addImages {
    UIViewController *tempVC =  [self ZYCurrentViewController];
    UIAlertController *alertVC = [EHTSelectImageManager createAlertControllerWithStyle:UIAlertControllerStyleActionSheet title:nil message:nil actionTitleOne:@"拍照" actionTitleTwo:@"从手机相册选择" actionTitleThree:@"取消" firstBtnClick:^{
        [self takePhotoFromDepartVC:tempVC];
    } secondBtnClick:^{
        [self selectImageFromAlbumFromDepartVC:tempVC];
    } thirdBtnClick:nil];
    [tempVC presentViewController:alertVC animated:YES completion:nil];
}

//MARK: - 从相册中选择图片
- (void)selectImageFromAlbumFromDepartVC:(UIViewController *)departVC {
    if (!departVC) {
        departVC = [self ZYCurrentViewController];
    }
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:_maxImagesCount delegate:self];
    imagePickerVC.takePictureImage = [UIImage imageNamed:@"EHT_Community_selected_photo"];
    imagePickerVC.selectedAssets = self.selectedAssets;
    imagePickerVC.navigationBar.translucent = NO;
    imagePickerVC.allowTakePicture = NO;
    imagePickerVC.allowPickingVideo = NO;
    imagePickerVC.allowPickingImage = YES;
    imagePickerVC.autoDismiss = NO;
    [departVC presentViewController:imagePickerVC animated:YES completion:nil];
}

//MARK: - 拍照
- (void)takePhotoFromDepartVC:(UIViewController *)departVC {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)) {
        // 无相机权限 做一个友好的提示
        UIAlertController *alertVC = [EHTSelectImageManager createAlertControllerWithStyle:UIAlertControllerStyleAlert title:@"无法使用相机" message:@"请在iPhone的设置中允许访问相机" actionTitleOne:@"取消" actionTitleTwo:@"设置" actionTitleThree:nil firstBtnClick:nil secondBtnClick:^{
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication] openURL:settingUrl];
            }
        } thirdBtnClick:nil];
        [departVC presentViewController:alertVC animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoFromDepartVC:departVC];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([[TZImageManager manager] authorizationStatusAuthorized]) {
        // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertController *alertVC = [EHTSelectImageManager createAlertControllerWithStyle:UIAlertControllerStyleAlert title:@"无法访问相册" message:@"请在iPhone的设置中允许访问相册" actionTitleOne:@"取消" actionTitleTwo:@"设置" actionTitleThree:nil firstBtnClick:nil secondBtnClick:^{
            NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
                [[UIApplication sharedApplication] openURL:settingUrl];
            }
        } thirdBtnClick:nil];
        [departVC presentViewController:alertVC animated:YES completion:nil];
    } else if ([[TZImageManager manager] authorizationStatusAuthorized]) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhotoFromDepartVC:departVC];
        }];
    } else {
        [self pushImagePickerControllerFromDepartVC:departVC];
    }
}

// 调用相机
- (void)pushImagePickerControllerFromDepartVC:(UIViewController *)departVC {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.view.backgroundColor = [UIColor whiteColor];
        imagePickerVC.delegate = self;
        UIBarButtonItem *tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
        UIBarButtonItem *barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [barItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
        imagePickerVC.sourceType = sourceType;
        [departVC presentViewController:imagePickerVC animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)deleteImage:(NSInteger)tag {
    [self.selectedPhotos removeObjectAtIndex:tag];
    [self.selectedAssets removeObjectAtIndex:tag];
}

+ (void)deallocManager {
    [singleton.selectedPhotos removeAllObjects];
    [singleton.selectedAssets removeAllObjects];
    singleton.selectedPhotos = nil;
    singleton.selectedAssets = nil;
    singleton.location = nil;
}

// 生成一个提示控制器
+ (UIAlertController *)createAlertControllerWithStyle:(UIAlertControllerStyle)style title:(NSString *)title message:(NSString *)message actionTitleOne:(NSString *)titleOne actionTitleTwo:(NSString *)titleTwo actionTitleThree:(NSString *)titleThree firstBtnClick:(void(^)(void))firstBtnBlock secondBtnClick:(void(^)(void))secondBtnBlock thirdBtnClick:(void(^)(void))thirdBtnBlock {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    
    if (titleOne) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:titleOne style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (firstBtnBlock) {
                firstBtnBlock();
            }
        }];
        [alertVc addAction:action];
    }
    if (titleTwo) {
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:titleTwo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (secondBtnBlock) {
                secondBtnBlock();
            }
        }];
        [alertVc addAction:action1];
    }
    if (titleThree) {
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:titleThree style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (thirdBtnBlock) {
                thirdBtnBlock();
            }
        }];
        [alertVc addAction:action2];
    }
    return alertVc;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:nil];
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
       __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error) {
            {
                if (error) {
                    [tzImagePickerVc hideProgressHUD];
                    NSLog(@"图片保存失败 %@",error);
                } else {
                    [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(TZAlbumModel *model) {
                        [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                            [tzImagePickerVc hideProgressHUD];
                            TZAssetModel *assetModel = [models firstObject];
                            if (tzImagePickerVc.sortAscendingByModificationDate) {
                                assetModel = [models lastObject];
                            }
                            [self.selectedPhotos addObject:image];
                            [self.selectedAssets addObject:assetModel.asset];
                            if (self.addImageBlock) {
                                self.addImageBlock(self.selectedPhotos);
                            }
                        }];
                    }];
                }
            }
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TZImagePickerControllerDelegate
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self.selectedPhotos removeAllObjects];
        [self.selectedAssets removeAllObjects];
        [self.selectedPhotos addObjectsFromArray:photos];
        [self.selectedAssets addObjectsFromArray:assets];
        if (self.addImageBlock) {
            self.addImageBlock(self.selectedPhotos);
        }
    }];
}

#pragma mark - Getter && Setter
- (NSMutableArray *)selectedPhotos {
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    return _selectedPhotos;
}

- (NSMutableArray *)selectedAssets {
    if (_selectedAssets == nil) {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

@end
