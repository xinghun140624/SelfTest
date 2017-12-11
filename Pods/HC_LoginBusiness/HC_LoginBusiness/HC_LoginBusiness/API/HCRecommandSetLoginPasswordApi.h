//
//  HCRecommandSetLoginPasswordApi.h
//  Pods
//
//  Created by Candy on 2017/7/19.
//
//

#import <YTKNetwork/YTKNetwork.h>
///推荐设置登录密码
@interface HCRecommandSetLoginPasswordApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token password:(NSString *)password;
@end
