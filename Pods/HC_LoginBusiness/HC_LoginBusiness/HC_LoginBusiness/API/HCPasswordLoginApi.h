//
//  HCPasswordLoginApi.h
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///密码登陆接口
@interface HCPasswordLoginApi : YTKRequest
- (instancetype)initWithAccount:(NSString *)account password:(NSString *)password;
@end
