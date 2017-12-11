//
//  HCResetMobilePasswordApi.h
//  HC_LoginBusiness
//
//  Created by Candy on 2017/6/23.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///重置手机密码
@interface HCResetMobilePasswordApi : YTKRequest
- (instancetype)initWithBusiness:(int)business mobile:(NSString *)mobile captcha:(NSString *)captcha password:(NSString *)password;
@end
