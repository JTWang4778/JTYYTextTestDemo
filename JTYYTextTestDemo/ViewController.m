//
//  ViewController.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "ViewController.h"
#import "EHTPostController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}
- (IBAction)didClickPost:(UIButton *)sender {
    
    [self.navigationController pushViewController:[EHTPostController new] animated:YES];
}


@end
