//
//  EHTEmojiKeyboardView.h
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/3.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTEmojiModel;

NS_ASSUME_NONNULL_BEGIN
// 表情键盘view
@interface JTEmojiKeyboardView : UIView

@property (nonatomic,weak)NSArray <JTEmojiModel *> *emojiModelArr;

@property (nonatomic,weak)NSArray <JTEmojiModel *> *tutuModelArr;
@end

NS_ASSUME_NONNULL_END
