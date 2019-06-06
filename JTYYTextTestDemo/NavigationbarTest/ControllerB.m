
//
//  ControllerB.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/6/5.
//  Copyright © 2019 wangjintao. All rights reserved.
//

#import "ControllerB.h"
#import "ControllerC.h"

typedef void (^CallBlock)(UIViewController *);

@interface ControllerB ()

@property (nonatomic, copy)CallBlock block;

@end

@implementation ControllerB

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"B";
    self.view.backgroundColor = [UIColor randomColor];
    // 是否禁用全屏手势手势手势
//    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = YES;
    self.fd_interactivePopMaxAllowedInitialDistanceToLeftEdge = 100;
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testButton.backgroundColor = [UIColor randomColor];
    [testButton addTarget:self action:@selector(didClickTestButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    self.block = ^(UIViewController *asdf) {
        self.view = [UIColor orangeColor];
    };
}

- (void)didClickTestButton:(UIButton *)sender{
    
    [self.navigationController pushViewController:[ControllerC new] animated:YES];
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    
//}


@end
