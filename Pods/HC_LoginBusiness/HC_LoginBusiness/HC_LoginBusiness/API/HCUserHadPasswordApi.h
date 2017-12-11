//
//  HCUserHadPasswordApi.h
//  HC_LoginBusiness
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
///检测用户是否设置过密码
@interface HCUserHadPasswordApi : YTKRequest
- (instancetype)initWithMobile:(NSString  *)mobile;
@end
