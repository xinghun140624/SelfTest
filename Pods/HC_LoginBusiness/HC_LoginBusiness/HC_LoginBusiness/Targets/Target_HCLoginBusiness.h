//
//  Target_HCLoginBusiness.h
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Target_HCLoginBusiness : NSObject

/**
 获得登录kongzhiq

 @param params 参数
 @return 登录控制器
 */
- (UIViewController *)Action_viewController:(NSDictionary *)params;

/**
 获得更换绑定手机号控制器

 @param params 需要的参数
 @return 控制器
 */
- (UIViewController *)Action_modifyBingdingMobileViewController:(NSDictionary *)params;


/**
 获得绑定新手机号控制器

 @param params 参数
 @return 控制器
 */
- (UIViewController *)Action_bindingNewMobileViewController:(NSDictionary *)params;


/**
 设置登录密码

 @param params 参数
 @return 设置登录密码控制器
 */
- (UIViewController *)Action_settingLoginPasswordController:(NSDictionary *)params;

/**
 修改登录密码

 @param params 参数
 @return 返回修改登录密码控制器
 */
- (UIViewController *)Action_modifyLoginPasswordController:(NSDictionary *)params ;

@end
