//
//  HCYeePayRegisterApi.h
//  HongCai
//
//  Created by Candy on 2017/6/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCYeePayRegisterApi : YTKRequest

/**
 
 
 @param params @{realName,idCardNo,from,token}
 @return <#return value description#>
 */
- (instancetype)initWithParams:(NSDictionary *)params;

@end
