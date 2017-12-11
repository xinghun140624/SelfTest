//
//  HCRegisterApi.h
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///注册接口
@interface HCRegisterApi : YTKRequest
- (instancetype)initWithMobile:(NSString *)mobile captcha:(NSString *)captcha password:(NSString *)password;

@end
