//
//  HCCalendarRepaymentDetailsApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCCalendarRepaymentDetailsApi : YTKRequest

/**
 查询回款详情

 @param token 验证身份
 @param userId 用户ID
 @param type 1、预计回款 2、待收回款 3、已收回款
 @param startTime 开始时间
 @param endTime 结束时间
 @return 回款详情Request
 */
- (instancetype)initWithToken:(NSString *)token userId:(int)userId type:(int)type startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime;
@end
