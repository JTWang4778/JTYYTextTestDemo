//
//  ControllerA.m
//  
//
//  Created by wangjintao on 2019/6/5.
//

#import "ControllerA.h"
#import "ControllerB.h"

@implementation ControllerA

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"A";
    self.view.backgroundColor = [UIColor randomColor];
    self.navigationController.fd_prefersNavigationBarHidden = NO;
    
    UIButton *testButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testButton.backgroundColor = [UIColor randomColor];
    [testButton addTarget:self action:@selector(didClickTestButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:testButton];
}

- (void)didClickTestButton:(UIButton *)sender{
    
    [self.navigationController pushViewController:[ControllerB new] animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

@end
