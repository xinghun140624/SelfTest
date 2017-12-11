//
//  HCSystemVersionApi.h
//  HongCai
//
//  Created by Candy on 2017/8/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCSystemVersionApi : YTKRequest
- (instancetype)initWithOs:(NSString *)os appVersion:(NSString *)appVersion;
@end
