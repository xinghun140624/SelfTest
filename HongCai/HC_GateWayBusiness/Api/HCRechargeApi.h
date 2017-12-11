//
//  YTKRechargeApi.h
//  HongCai
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCRechargeApi : YTKRequest
/**
 充值接口
 
 @param params 请求参数 @"必传参数 amount,from,device,token,rechargeWay(SWIFT)"
 @return 返回Api对象
 */
- (instancetype)initWithParams:(NSDictionary *)params;

@end
