//
//  HCPayMentApi.h
//  HC_GateWayBusiness
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCPayMentApi : YTKRequest


/**
 支付接口

 @param params 请求参数 @"必传参数 orderNumber(接口url需要),from,device,token"
 @return 返回Api对象
 */
- (instancetype)initWithParams:(NSDictionary *)params;

@end
