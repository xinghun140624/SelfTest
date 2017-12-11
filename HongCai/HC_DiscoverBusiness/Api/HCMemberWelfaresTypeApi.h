//
//  HCMemberWelfaresApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/10/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///会员等级奖励查询
@interface HCMemberWelfaresTypeApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token level:(NSInteger)level;
@end
