//
//  HCPartakeCutInterestRateApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///通过项目类型判断用户是否可以参与降息兑换
@interface HCPartakeCutInterestRateApi : YTKRequest
- (instancetype)initWithProjectType:(int)projectType token:(NSString *)token;
@end
