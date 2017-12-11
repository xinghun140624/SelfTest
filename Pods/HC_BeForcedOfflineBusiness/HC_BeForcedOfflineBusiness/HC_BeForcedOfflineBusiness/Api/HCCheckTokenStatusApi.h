//
//  HCCheckTokenStatusApi.h
//  HC_BeForcedOfflineBusiness
//
//  Created by 郭金山 on 2017/9/14.
//  Copyright © 2017年 candy. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCCheckTokenStatusApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token;
@end
