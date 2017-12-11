//
//  HCModifyPasswordApi.h
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import <YTKNetwork/YTKNetwork.h>
///修改密码接口
@interface HCModifyPasswordApi : YTKRequest
- (instancetype)initWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword token:(NSString *)token;
@end
