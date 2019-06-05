//
//  ControllerC.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/6/5.
//  Copyright © 2019 wangjintao. All rights reserved.
//

#import "ControllerC.h"

@interface ControllerC ()

@end

@implementation ControllerC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = @"C";
    self.view.backgroundColor = [UIColor randomColor];
    self.fd_prefersNavigationBarHidden = YES;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
