//
//  AppDelegate.h
//  HongCai
//
//  Created by Candy on 2017/5/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCAdWindow.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HCAdWindow *adWindow;
@property (assign, nonatomic) NSUInteger allowRotate;
- (UIViewController *)getCurrentVC;
@end

