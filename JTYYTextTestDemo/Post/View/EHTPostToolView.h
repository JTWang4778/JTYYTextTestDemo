//
//  EHTPostToolView.h
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/3.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol  EHTPostToolViewDelegate <NSObject>

- (void)didClickButtonWithIndex: (NSInteger)index;

@end
@interface EHTPostToolView : UIView
@property (nonatomic,weak) id <EHTPostToolViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
