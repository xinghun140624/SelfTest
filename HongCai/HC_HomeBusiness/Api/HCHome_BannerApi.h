//
//  HCHome_BannerApi.h
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCHome_BannerApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token type:(NSInteger)type;
@end
