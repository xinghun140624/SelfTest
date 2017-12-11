//
//  HCNavigationController.m
//  HongCai
//
//  Created by Candy on 2017/5/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCNavigationController.h"
@interface HCNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation HCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count>=1) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.navigationBar.topItem.title = @"";
    }
    [super pushViewController:viewController animated:animated];
    // 修改tabBra的frame
    CGRect frame = self.tabBarController.tabBar.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height;
    self.tabBarController.tabBar.frame = frame;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count<=1) {
        return NO;
    }
    return YES;
}

@end
