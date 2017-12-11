//
//  CTMediator+HCUserBusiness.h
//  HCUserBusiness_Category
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <CTMediator/CTMediator.h>

@interface CTMediator (HCUserBusiness)

/**
 获取用户数据

 @return 返回用户数据
 */
- (NSDictionary *)HCUserBusiness_getUser;

/**
 更新用户数据

 @return 是否成功
 */
- (BOOL)HCUserBusiness_saveUser:(NSDictionary *)params;

/**
 移除User（安全退出）

 @return 是否成功
 */
- (BOOL)HCUserBusiness_removeUser;

/**
 获取用户授权数据

 */
- (void)HCUserBusiness_getUserAuth:(NSDictionary *)param SuccessCallBack:(void(^)(NSDictionary * info))successCallBack;

@end
