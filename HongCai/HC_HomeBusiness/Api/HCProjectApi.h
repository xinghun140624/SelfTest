//
//  HCProjectApi.h
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface HCProjectApi : YTKRequest
- (instancetype)initWithPage:(NSInteger)page pageSize:(NSInteger)pageSize type:(NSInteger)type;
@end
