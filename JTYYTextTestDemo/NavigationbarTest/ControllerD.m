//
//  ControllerD.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/6/6.
//  Copyright © 2019 wangjintao. All rights reserved.
//

#import "ControllerD.h"

@interface ControllerD ()

@end

@implementation ControllerD

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fd_prefersNavigationBarHidden = YES;
    self.title = @"D";
    self.view.backgroundColor = [UIColor randomColor];
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
