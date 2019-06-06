//
//  ControllerC.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/6/5.
//  Copyright © 2019 wangjintao. All rights reserved.
//

#import "ControllerC.h"
#import "ControllerD.h"

@interface ControllerC ()

@end

@implementation ControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"C";
    self.view.backgroundColor = [UIColor randomColor];
//    self.fd_prefersNavigationBarHidden = YES;
    
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testButton.backgroundColor = [UIColor randomColor];
    [testButton addTarget:self action:@selector(didClickTestButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
    
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(receivedPand:)];
    [self.view addGestureRecognizer:pan];
}

- (void)receivedPand:(UIPanGestureRecognizer *)ges{
    CGPoint asdf = [ges translationInView:self.view];
    JTLog(@"----->%@",NSStringFromCGPoint(asdf));
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//
//}

- (void)didClickTestButton:(UIButton *)sender{
    
    [self.navigationController pushViewController:[ControllerD new] animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
