//
//  JTEmojiView.h
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/3.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTEmojiModel;

NS_ASSUME_NONNULL_BEGIN
// emoji 表情view
@interface JTEmojiView : UIView
@property (nonatomic,weak)NSArray <JTEmojiModel *> *emojiModelArr;
@end

NS_ASSUME_NONNULL_END
