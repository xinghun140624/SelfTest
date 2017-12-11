//
//  HCNoticesApi.h
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCNoticesApi : YTKRequest
- (instancetype)initWithPage:(NSInteger)page pageSize:(NSInteger)pageSize;
@end
