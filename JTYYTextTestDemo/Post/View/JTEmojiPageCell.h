//
//  JTEmojiPageCell.h
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JTEmojiModel;

@interface JTEmojiPageCell : UICollectionViewCell

@property (nonatomic,strong)NSArray <JTEmojiModel *> *modelArr;

@end

NS_ASSUME_NONNULL_END
