//
//  HCMemberCenterHelper.h
//  HongCai
//
//  Created by Candy on 2017/11/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCMemberWelfareModel.h"
@interface HCMemberCenterHelper : NSObject
+ (void)requestMemberCenterWelfareTypesData:(NSInteger)level completion:(void(^)(NSArray* models))models;
@end
