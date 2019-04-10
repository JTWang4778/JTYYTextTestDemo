//
//  JTTutuGifCell.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/6.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "JTTutuGifCell.h"
#import "JTEmojiModel.h"
#import "YYText.h"
#import "YYImage.h"

@interface JTTutuGifCell()

@property (nonatomic,weak)YYAnimatedImageView *imageView;

@end
@implementation JTTutuGifCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews{
    YYAnimatedImageView *iamgeView = [[YYAnimatedImageView alloc] init];
    iamgeView.autoPlayAnimatedImage = YES;
    [self.contentView addSubview:iamgeView];
    self.imageView = iamgeView;
    CGFloat width = MIN(self.width, self.height);
    [iamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(width, width));
    }];
    
}

- (void)setModel:(JTEmojiModel *)model{
    _model = model;
    self.imageView.image = model.gifImage;
}
@end
