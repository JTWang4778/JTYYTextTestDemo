//
//  CommunityPublishInpugHyperlinksView.m
//  EHuaTuFramework
//
//  Created by HTYL on 2019/3/22.
//  Copyright © 2019年 ZhiYun. All rights reserved.
//

#import "CommunityPublishInpugHyperlinksView.h"

@implementation CommunityPublishInpugHyperlinksView

+(void)loadingMaskTitle:(NSString *)title callBack:(void(^)(CommunityPublishInpugHyperlinksView *hyperView))callBack{
    CommunityPublishInpugHyperlinksView *view = [[CommunityPublishInpugHyperlinksView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.callBack = callBack;
    [view loadingMaskTitle:title];
}
-(void)loadingMaskTitle:(NSString *)title{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    UIButton *maskBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    maskBtn.backgroundColor = [UIColor blackColor];
    maskBtn.alpha = 0.6;
    self.maskBtn = maskBtn;
    [self addSubview:maskBtn];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kRealValueWidthIn6(270), kRealValueWidthIn6(208))];
    bgView.centerX = keyWindow.centerX;
    bgView.centerY = keyWindow.centerY-30;
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    self.bgView = bgView;
    [self addSubview:bgView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kRealValueWidthIn6(20), bgView.width, kRealValueWidthIn6(20))];
    label.textColor = [UIColor blackColor];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:label];
    
    UITextField *hyperlinks = [[UITextField alloc]initWithFrame:CGRectMake(kRealValueWidthIn6(16), kRealValueWidthIn6(60), bgView.width - kRealValueWidthIn6(32), 32)];
    hyperlinks.placeholder = @"输入链接地址";
    hyperlinks.font = UIFontMake(14);
    self.hyperlinks = hyperlinks;
    [bgView addSubview:hyperlinks];
    
    UITextField *hyperlinksTitle = [[UITextField alloc]initWithFrame:CGRectMake(kRealValueWidthIn6(16), kRealValueWidthIn6(104), bgView.width - kRealValueWidthIn6(32), 32)];
    hyperlinksTitle.placeholder = @"输入链接文本（可选）";
    hyperlinksTitle.font = UIFontMake(14);
    self.hyperlinksTitle = hyperlinksTitle;
    [bgView addSubview:hyperlinksTitle];
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 32)];
    hyperlinks.leftView = leftView;
    hyperlinks.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *titleLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 32)];
    hyperlinksTitle.leftView = titleLeftView;
    hyperlinksTitle.leftViewMode = UITextFieldViewModeAlways;
    
    UIButton *cancel = [[UIButton alloc]initWithFrame:CGRectMake(0,kRealValueWidthIn6(164), kRealValueWidthIn6(270/2), kRealValueWidthIn6(44))];
    [cancel setTitleColor:[UIColor jt_colorWithHexString:@"999CAA"] forState:UIControlStateNormal];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.backgroundColor = [UIColor jt_colorWithHexString:@"#EEEFF4"];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancel addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cancel];
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(kRealValueWidthIn6(270/2),kRealValueWidthIn6(164), kRealValueWidthIn6(270/2), kRealValueWidthIn6(44))];
    [nextBtn setTitle:@"确认" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor jt_colorWithHexString:@"#3D3E43"] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [UIColor jt_colorWithHexString:@"#EEEFF4"];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:nextBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(kRealValueWidthIn6(0), kRealValueWidthIn6(164), kRealValueWidthIn6(270), 0.5)];
    line.backgroundColor = [UIColor grayColor];
    [bgView addSubview:line];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(kRealValueWidthIn6(124), kRealValueWidthIn6(164), 0.5, kRealValueWidthIn6(44))];
    line2.backgroundColor = [UIColor grayColor];
    [bgView addSubview:line2];
    
    [hyperlinks becomeFirstResponder];

}
-(void)btnAction{
    [self close];
    if (self.callBack) {
        self.callBack(self);
    }
}
-(void)close{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}

@end
