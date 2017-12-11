//
//  HCMemberWelfareRuleModel.h
//  HongCai
//
//  Created by Candy on 2017/11/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCMemberWelfareRuleModel : NSObject<YYModel>
@property (nonatomic, strong) NSDecimalNumber *amount;
@property (nonatomic, assign) NSInteger dueTime;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, strong) NSString  *imgUrl;
@property (nonatomic, assign) NSInteger investProjectType;
@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) NSInteger minInvestAmount;
@property (nonatomic, assign) NSInteger minProjectDays;
@property (nonatomic, assign) NSInteger number;

/*
 amount = "0.5";
 description = "<null>";
 dueTime = 10;
 duration = 0;
 expiredTime = 1512316740000;
 imgUrl = "http://test321.hongcai.com/uploads/png/original/2017-10-24/image/193a50a1dfa740d4a40efb057fa574e5-original.png";
 investProjectType = 5;
 maxCount = 10;
 minInvestAmount = 5000;
 minProjectDays = 20;
 number = 1;
 */

@end
