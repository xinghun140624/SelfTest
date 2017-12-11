//
//  HCCutIncreaseRateApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///通过项目编号获取用户可以使用的降息兑换物品
@interface HCCutIncreaseRateApi : YTKRequest
- (instancetype)initWithProjectType:(int)projectType token:(NSString *)token;
@end
