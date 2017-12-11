//
//  HCGetCalendarDataApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCGetCalendarDataApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token userId:(int)userId startTime:(NSTimeInterval)startTime endTime:(NSTimeInterval)endTime;
@end
