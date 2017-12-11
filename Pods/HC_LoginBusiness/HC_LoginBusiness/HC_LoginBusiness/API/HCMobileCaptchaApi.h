//
//  HCMobileCaptchaApi.h
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//  发送手机验证码

#import <YTKNetwork/YTKNetwork.h>
///  发送手机验证码
/// 参数为（business,device,mobile,picCaptcha,type=1要校验手机号是否注册，0为不校验）
@interface HCMobileCaptchaApi : YTKRequest
- (instancetype)initWithBusiness:(int)business mobile:(NSString *)mobile picCaptcha:(NSString *)picCaptcha type:(int)type;

@end
