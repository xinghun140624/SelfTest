//
//  HCMemberWelfareModel.h
//  HongCai
//
//  Created by Candy on 2017/11/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@class HCMemberWelfareRuleModel;
@interface HCMemberWelfareModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger memberWelfareId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray <HCMemberWelfareRuleModel *>*welfareRules;
@property (nonatomic, assign) NSInteger amount;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, assign) NSInteger withdrawCount;

@end
