//
//  JTBaseNavigationController.m
//  JTYYTextTestDemo
//
//  Created by wangjintao on 2019/4/5.
//  Copyright © 2019年 wangjintao. All rights reserved.
//

#import "JTBaseNavigationController.h"
#import "JTBaseViewController.h"
@interface JTBaseNavigationController ()<UINavigationControllerDelegate>

@end

@implementation JTBaseNavigationController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = nil;
    self.delegate = self;
    
    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
//    self.navigationBar.b/arTintColor = [UIColor hexColorWith:@"#4A88FB"];
    [self.navigationBar setBackgroundImage:[UIImage createImageWithColor:[UIColor hexColorWith:@"4A88FB"]] forBarMetrics:UIBarMetricsDefault];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    if (self.viewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed = YES;//处理隐藏tabbar
        if ([viewController isKindOfClass:[JTBaseViewController class]]) {
            //            EHTBaseViewController *vc = (EHTBaseViewController *)viewController;

            viewController.navigationItem.leftBarButtonItem = [self barButtonItemWithImage:[UIImage jt_bundleImageWithBundleName:@"bundleTest" ImageName:@"EHT_navigationBar_back"] highImage:nil target:self action:@selector(backToPop:) forControlEvents:UIControlEventTouchUpInside];
            //        }

        }else{
            viewController.navigationItem.leftBarButtonItem = [self barButtonItemWithImage:[UIImage jt_bundleImageWithBundleName:@"bundleTest" ImageName:@"EHT_navigationBar_back"] highImage:nil target:self action:@selector(backToPop:) forControlEvents:UIControlEventTouchUpInside];
        }

    }else{

    }
    [super pushViewController:viewController animated:animated];
    
    // 修正push控制器tabbar上移问题
    if (@available(iOS 11.0, *)){
        // 修改tabBar的frame
        CGRect frame = self.tabBarController.tabBar.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
        self.tabBarController.tabBar.frame = frame;
    }
    
}

-(void)backToPop:(UIBarButtonItem *)sender{
    [self.view endEditing:YES];
    //    UIViewController * currentVC = self.topViewController;
    //    if (currentVC.clickPopBlock) {
    //        currentVC.clickPopBlock(sender);
    //    }else{
    [self popViewControllerAnimated:YES];
    //    }
}



- (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    // btn
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    //    btn.frame =CGRectMake(0, 0, 15, 24);
    //    btn.backgroundColor = [UIColor redColor];
    
    [btn addTarget:target action:action forControlEvents:controlEvents];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
