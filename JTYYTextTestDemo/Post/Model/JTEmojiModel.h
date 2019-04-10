//
//  JTEmojiModel.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "JTBaseModel.h"
#import "YYImage.h"

NS_ASSUME_NONNULL_BEGIN
UIKIT_EXTERN NSString * const JTEmojiKeyboardActionNotification;
UIKIT_EXTERN NSString * const JTTutuGifKeyboardActionNotification;

typedef NS_ENUM(NSUInteger, JTEmojiType) {
    JTEmojiTypeEmoji = 0, // 表情
    JTEmojiTypeBlankSpace, // 空格
    JTEmojiTypeDelete, // 删除
};
@interface JTEmojiModel : JTBaseModel

@property (nonatomic,assign)JTEmojiType type;
@property (nonatomic,copy)NSString *code;
@property (nonatomic,copy)NSString *imageName;
@property (nonatomic,strong)YYImage *gifImage;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,assign)NSInteger pageIndex;
@property (nonatomic,weak)UIImage *iamge;

@end

NS_ASSUME_NONNULL_END
