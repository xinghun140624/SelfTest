//
//  HCUserInvestStatApi.h
//  Pods
//
//  Created by Candy on 2017/7/10.
//
//

#import <YTKNetwork/YTKNetwork.h>

/**
 用户投资统计
 */
@interface HCUserInvestStatApi : YTKRequest

- (instancetype)initWithParams:(NSDictionary *)params;
@end
