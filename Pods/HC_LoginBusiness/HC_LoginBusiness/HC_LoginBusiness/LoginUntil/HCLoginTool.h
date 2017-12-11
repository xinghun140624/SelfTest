//
//  HCLoginTool.h
//  HongCai
//
//  Created by Candy on 2017/6/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCLoginTool : NSObject


/**
 验证手机号

 @param str 手机号
 @return 是否是正确的
 */
+(BOOL)isValidPhoneNum:(NSString *)str;


/**
 检查密码复杂度（6-16位字母数字组合）

 @param password 密码
 @return 是否符合
 */
+ (NSInteger)checkPassword:(NSString *) password;


/**
 密码加密

 @param mdStr 需要加密的字符串
 @return 加密完成的字符串
 */
+ (NSString *)stringToMD5:(NSString *)mdStr;


/**
 检查密码强度

 @param password 密码
 @return 返回强度等级
 */
+ (NSMutableAttributedString *)checkPasswordLevel:(NSString *)password;


/**
 是否包含中文

 @param str 字符串
 @return 是否包含
 */
+ (BOOL)isContainChinese:(NSString *)str;

@end
