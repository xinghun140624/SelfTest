//
//  HCMemberWelfareApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///会员等级奖励领取

@interface HCMemberWelfareApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token userId:(NSInteger)userId memberWelfareId:(NSInteger)memberWelfareId number:(NSInteger)number;
@end
