//
//  HCWithDrawFreeCountApi.h
//  HongCai
//
//  Created by Candy on 2017/11/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///可提现金额
@interface HCWithDrawFreeCountApi : YTKRequest
- (instancetype)initWithToken:(NSString *)token userId:(NSInteger)userId;

@end
