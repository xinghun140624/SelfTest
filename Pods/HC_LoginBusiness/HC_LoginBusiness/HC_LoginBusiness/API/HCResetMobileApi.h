//
//  HCResetMobileApi.h
//  Pods
//
//  Created by Candy on 2017/7/5.
//
//

#import <YTKNetwork/YTKNetwork.h>
///重置手机号
@interface HCResetMobileApi : YTKRequest
- (instancetype)initWithMobile:(NSString *)mobile captcha:(NSString *)captcha;
@end
