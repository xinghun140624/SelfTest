//
//  HCAccountApi.h
//  HongCai
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCAccountApi : YTKRequest
//获取用户信息
- (instancetype)initWithParams:(NSDictionary *)params;
@end
