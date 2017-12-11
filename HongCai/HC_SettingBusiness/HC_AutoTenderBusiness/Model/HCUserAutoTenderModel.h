//
//  HCUserAutoTenderModel.h
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HC_UserBusiness/HCUser.h>
@interface HCUserAutoTenderModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSDecimalNumber * minInvestAmount;
@property (nonatomic, assign) NSInteger minRemainDay;
@property (nonatomic, assign) NSInteger maxRemainDay;
@property (nonatomic, strong) NSDecimalNumber * annualEarnings;
@property (nonatomic, strong) NSDecimalNumber * remainAmount;
@property (nonatomic, assign) NSInteger investType;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSNumber * startTime;
@property (nonatomic, strong) NSNumber * endTime;
@property (nonatomic, strong) HCUser * user;
@end
