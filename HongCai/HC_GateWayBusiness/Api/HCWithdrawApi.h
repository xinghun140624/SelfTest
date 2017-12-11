//
//  HCWithdrawApi.h
//  HC_GateWayBusiness
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCWithdrawApi : YTKRequest

/**
 用户提现

 @param params 参数(token,from,device,amount)
 @return api
 */
- (instancetype)initWithParams:(NSDictionary *)params;

@end
