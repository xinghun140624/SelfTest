//
//  HCDiscoverService.h
//  HongCai
//
//  Created by Candy on 2017/7/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HCActivityModel.h"
#import "HCUserMemberModel.h"
@interface HCDiscoverService : NSObject
+ (void)getDiscoverData:(void(^)(NSArray * acvitityModels,NSArray *bottomActivityModels))models errorMessage:(void(^)(NSString *errorMessage))errorMessage;
+ (void)getUserMemberWithToken:(NSString *)token completeHanlder:(void(^)(HCUserMemberModel *model))completeHanlder;
@end
