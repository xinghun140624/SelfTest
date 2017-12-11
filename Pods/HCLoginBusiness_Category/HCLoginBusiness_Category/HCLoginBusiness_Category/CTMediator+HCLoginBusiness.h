//
//  CTMediator+HCLoginBusiness.h
//  HCLoginBusiness_Category
//
//  Created by Candy on 2017/6/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <CTMediator/CTMediator.h>
#import <UIKit/UIKit.h>

extern NSString *const HC_LoginSuccessNotification;

typedef void(^closeButtonClickCallBack)(void);


@interface CTMediator (HCLoginBusiness)

/**
 登录控制器

 @return 返回登录控制器
 */
- (UIViewController *)HCLoginBusiness_viewController;
/**
 更改绑定手机号控制器

 @return 更改绑定手机号控制器
 */
- (UIViewController *)HCLoginBusiness_modifyBingdingMobileViewController;

/**
 绑定新手机号控制器

 @return 绑定新手机号控制器
 */
- (UIViewController *)HCLoginBusiness_bindingNewMobileViewController;

/**
 设置登录密码控制器
 
 @return  设置登录密码控制器
 */
- (UIViewController *)HCLoginBusiness_settingLoginPasswordController;



/**
 修改登录密码

 @return 修改登录密码控制器
 */
- (UIViewController *)HCLoginBusiness_modifyLoginPasswordController;

@end
