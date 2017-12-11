//
//  HCUserAuthApi.h
//  HongCai
//
//  Created by Candy on 2017/6/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///获得用户授权状态
@interface HCUserAuthApi : YTKRequest

- (instancetype)initWithToken:(NSString *)token;
@end
