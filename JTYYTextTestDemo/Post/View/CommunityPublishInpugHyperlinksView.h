//
//  CommunityPublishInpugHyperlinksView.h
//  EHuaTuFramework
//
//  Created by HTYL on 2019/3/22.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommunityPublishInpugHyperlinksView : UIView

@property (strong, nonatomic) UIButton * maskBtn;
@property (strong, nonatomic) UIView * bgView;
@property (strong, nonatomic) UITextField * hyperlinks;
@property (strong, nonatomic) UITextField * hyperlinksTitle;
@property (copy, nonatomic) void(^callBack)(CommunityPublishInpugHyperlinksView *hyperView);

+(void)loadingMaskTitle:(NSString *)title callBack:(void(^)(CommunityPublishInpugHyperlinksView *hyperView))callBack;

@end

NS_ASSUME_NONNULL_END
