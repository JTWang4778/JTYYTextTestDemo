//
//  EHTPostToolView.m
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/3.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import "EHTPostToolView.h"

@interface EHTPostToolView()

@property (nonatomic,strong)NSArray <NSString *>*imageNameArr;

@end
@implementation EHTPostToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageNameArr = @[@"JT_at",@"JT_video",@"JT_link",@"JT_selectImage",@"JT_emojiKeyboard",@"JT_changeLine"];
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    self.backgroundColor = [UIColor whiteColor];
    
    NSInteger buttonCount = 6;
    CGFloat buttonWidth = SCREEN_WIDTH / buttonCount;
    for (int i = 0; i < buttonCount; i ++) {
        
        UIButton *changeKeyboard = [UIButton buttonWithType:UIButtonTypeCustom];
        changeKeyboard.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, self.height);
        NSString *iamgeName = self.imageNameArr[i];
        [changeKeyboard setImage:[UIImage jt_bundleImageWithBundleName:@"bundleTest" ImageName:iamgeName] forState:UIControlStateNormal];
        changeKeyboard.tag = 1000 + i;
        [changeKeyboard addTarget:self action:@selector(didClickChangeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeKeyboard];
    }
}

- (void)didClickChangeButton: (UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    if ([self.delegate respondsToSelector:@selector(didClickButtonWithIndex:)]) {
        [self.delegate didClickButtonWithIndex:index];
    }
}
@end
