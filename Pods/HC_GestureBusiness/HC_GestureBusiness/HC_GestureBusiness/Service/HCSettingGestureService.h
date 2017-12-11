//
//  HCSettingGestureService.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface HCSettingGestureService : NSObject

/**
 获取用户手势密码

 @param success 成功
 */
+ (void)getUserGesture:(void(^)(BOOL success,NSString *gesture))success;

/**
 删除用户手势密码

 @param success 成功回调
 */
+ (void)deleteUserGesture:(void(^)(BOOL success))success;


/**
 更改或者保存用户手势密码

 @param gesture 手势密码
 @param success 成功回调
 */
+ (void)updateUserGesture:(NSString *)gesture success:(void (^)(BOOL success))success;


/**
 检查是否显示推荐设置手势密码
 */
+ (void)checkUserIsAppearReconmandSettingGesturePassword;
@end
