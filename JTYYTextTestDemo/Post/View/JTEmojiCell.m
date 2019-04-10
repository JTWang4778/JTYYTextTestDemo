//
//  JTEmojiCell.m
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/3.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import "JTEmojiCell.h"
#import "JTEmojiModel.h"

@interface JTEmojiCell()

@property (nonatomic,weak)UIImageView *imageView;
@property (nonatomic,weak)UILabel *tipLabel;

@end
@implementation JTEmojiCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


- (void)setupSubViews{
    self.backgroundColor = [UIColor jt_colorWithHexString:@"F6F6F8"];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    self.tipLabel = tipLabel;
    
    
    UIImageView *iamgeView = [[UIImageView alloc] init];
    [self.contentView addSubview:iamgeView];
    self.imageView = iamgeView;
    WEAKSELF
    [iamgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(weakSelf);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
}

- (void)setModel:(JTEmojiModel *)model{
    if (model == nil || model.type == JTEmojiTypeBlankSpace) {
        self.imageView.hidden = YES;
        self.tipLabel.hidden = YES;
    }else{
        if (model.type == JTEmojiTypeEmoji) {
            self.imageView.hidden = NO;
            self.tipLabel.hidden = YES;
//            self.imageView.image = [UIImage jt_bundleImageWithBundleName:@"EmoticonQQ" ImageName:model.imageName];
//            self.imageView.image = [UIImage imageNamed: model.imageName];
            self.imageView.image = model.iamge;
        }else{
            self.imageView.hidden = YES;
            self.tipLabel.hidden = NO;
            self.tipLabel.text = @"X";
        }
    }
}

@end
