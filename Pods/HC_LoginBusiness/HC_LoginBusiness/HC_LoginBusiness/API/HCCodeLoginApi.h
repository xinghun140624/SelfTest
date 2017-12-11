//
//  HCCodeLoginApi.h
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//  验证码登录

#import <YTKNetwork/YTKNetwork.h>
///验证码登录
@interface HCCodeLoginApi : YTKRequest
- (instancetype)initWithMobile:(NSString *)mobile captcha:(NSString *)captcha;
@end
