//
//  HCInvestcreastRateCouponApi.h
//  Pods
//
//  Created by Candy on 2017/6/29.
//
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCInvestIncreastRateCouponApi : YTKRequest

/**
 根据投资项目获取优惠券

 @param params @（token, amount, projectId）
 @return api
 */
- (instancetype)initWithParams:(NSDictionary *)params;
@end
