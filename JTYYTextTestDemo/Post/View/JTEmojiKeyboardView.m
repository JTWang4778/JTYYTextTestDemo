//
//  EHTEmojiKeyboardView.m
//  EHuaTuFramework
//
//  Created by wangjintao on 2019/4/3.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import "JTEmojiKeyboardView.h"
#import "JTEmojiView.h"
#import "JTTutuGifView.h"
#import "JTEmojiModel.h"

@interface JTEmojiKeyboardView()

@property (nonatomic,strong)UIScrollView *scroll;
@property (nonatomic,strong)JTEmojiView *emojiView;
@property (nonatomic,strong)JTTutuGifView *tutuView;
@property (nonatomic,weak)UIButton *emojiButton;
@property (nonatomic,weak)UIButton *tutuButton;

@end
@implementation JTEmojiKeyboardView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    //
    self.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scroll = [[UIScrollView alloc] init];
    scroll.contentSize = CGSizeMake(self.width * 2, scroll.height);
    scroll.scrollEnabled = NO;
    [self addSubview:scroll];
    self.scroll = scroll;
    [scroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(178);
    }];
    
    
    // 添加emoji表情view
    JTEmojiView *emoji = [[JTEmojiView alloc] initWithFrame:CGRectMake(0, 0, self.width, 178)];
    [scroll addSubview:emoji];
    self.emojiView = emoji;
    
    // 添加h图兔表情键盘
    JTTutuGifView *tutuView = [[JTTutuGifView alloc] initWithFrame:CGRectMake(self.width, 0, self.width, 178)];
    [scroll addSubview:tutuView];
    self.tutuView = tutuView;
    
    // 添加button
//    JW_EmojiButton
    UIButton *emojiButton = [[UIButton alloc] init];
    emojiButton.frame = CGRectMake(21, 178, 40, 43);
    emojiButton.backgroundColor = [UIColor jt_colorWithHexString:@"F6F6F8"];
    [emojiButton setImage:[UIImage jt_bundleImageWithBundleName:@"bundleTest" ImageName:@"JW_EmojiButton"] forState:UIControlStateNormal];
    [emojiButton setImage:[UIImage jt_bundleImageWithBundleName:@"bundleTest" ImageName:@"JW_EmojiButton"] forState:UIControlStateHighlighted];
    [emojiButton addTarget:self action:@selector(didClickEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:emojiButton];
    self.emojiButton = emojiButton;
    // JW_tutu
    
    UIButton *tutuButton = [[UIButton alloc] init];
    tutuButton.frame = CGRectMake(61, 178, 40, 43);
    [tutuButton setImage:[UIImage jt_bundleImageWithBundleName:@"bundleTest" ImageName:@"JW_tutu"] forState:UIControlStateNormal];
    [tutuButton addTarget:self action:@selector(didClickEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tutuButton];
    self.tutuButton = tutuButton;
}

- (void)didClickEmojiButton: (UIButton *)sender{
    if ([sender isEqual:self.emojiButton]) {
        self.tutuButton.backgroundColor = [UIColor whiteColor];
        self.scroll.contentOffset = CGPointZero;
    }else{
        self.emojiButton.backgroundColor = [UIColor whiteColor];
        self.scroll.contentOffset = CGPointMake(self.width, 0);
    }
    sender.backgroundColor = [UIColor jt_colorWithHexString:@"F6F6F8"];
}

- (void)setEmojiModelArr:(NSArray<JTEmojiModel *> *)emojiModelArr{
    _emojiModelArr = emojiModelArr;
    self.emojiView.emojiModelArr = emojiModelArr;
}

- (void)setTutuModelArr:(NSArray<JTEmojiModel *> *)tutuModelArr{
    _tutuModelArr = tutuModelArr;
    self.tutuView.modelArr = tutuModelArr;
}

@end
