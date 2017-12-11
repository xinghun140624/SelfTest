//
//  HCMyInvestApi.h
//  Pods
//
//  Created by Candy on 2017/7/10.
//
//

#import <YTKNetwork/YTKNetwork.h>

/**
 我的投资接口
 */
@interface HCMyInvestApi : YTKRequest
- (instancetype)initWithParams:(NSDictionary *)params;
@end
