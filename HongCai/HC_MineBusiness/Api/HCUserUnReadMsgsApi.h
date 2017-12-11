//
//  HCUserUnReadMsgsApi.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/25.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCUserUnReadMsgsApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token;
@end
