//
//  HCBannerActivityApi.h
//  HongCai
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///首页banner下方活动 发现下方活动，大图
@interface HCBannerActivityApi : YTKRequest
/**
 type 3，local 1发现大页，2发现小入口，3首页入口
 */
- (instancetype)initWithToken:(NSString *)token type:(NSInteger)type locale:(NSInteger)locale count:(NSInteger)count;
@end
