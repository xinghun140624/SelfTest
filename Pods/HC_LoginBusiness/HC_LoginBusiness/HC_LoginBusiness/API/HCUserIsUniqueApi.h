//
//  HCUserIsUniqueApi.h
//  HC_LoginBusiness
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCUserIsUniqueApi : YTKRequest
- (instancetype)initWithAccount:(NSString *)account;
@end
