//
//  UIViewController+HoodViewWillAppear.m
//  HongCai
//
//  Created by 郭金山 on 2017/9/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "UIViewController+HoodViewWillAppear.h"
#import <objc/runtime.h>
#import <HCBeForcedOfflineBusiness_Category/CTMediator+HCBeForcedOfflineBusiness.h>
@implementation UIViewController (HoodViewWillAppear)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Inject "-navigationBar:shouldPopItem:"
        Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method swizzledMethod = class_getInstanceMethod(self, @selector(js_viewWillAppear:));
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}
- (void)js_viewWillAppear:(BOOL)animated {

    if (![self isKindOfClass:[UINavigationController class]]) {
        [[CTMediator sharedInstance] HCBeForcedOfflineBusiness_checkTokenStatus];
    }
    
    
    [self js_viewWillAppear:animated];
}
@end
