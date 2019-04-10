//
//  JTBaseViewController.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "JTBaseViewController.h"


@interface JTBaseViewController ()

@end

@implementation JTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.view.backgroundColor) {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }else{
        if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
    }
    
    [self setupSubviews];
}



- (void)setupSubviews{
    // 子类重写
    
    
}

- (void)dealloc {
    JTLog(@"%@销毁了", NSStringFromClass([self class]));
}


@end
