//
//  HCUserOpenAutoTenderApi.h
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///开启或者修改自动投标
@interface HCUserOpenAutoTenderApi : YTKRequest
- (instancetype)initWithParams:(NSDictionary *)params;

@end
