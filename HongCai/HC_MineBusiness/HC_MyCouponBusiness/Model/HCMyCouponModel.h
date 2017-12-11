//
//  HCMyCouponModel.h
//  HongCai
//
//  Created by Candy on 2017/6/23.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCMyCouponModel : NSObject<YYModel>
@property (nonatomic, strong) NSNumber * myCouponId;
@property (nonatomic, strong) NSNumber * templateId;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic, copy  ) NSString * number;
@property (nonatomic, strong) NSDecimalNumber * value;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * createTime;
@property (nonatomic, strong) NSNumber * endTime;
@property (nonatomic, copy  ) NSString * orderNum;
@property (nonatomic, strong) NSDecimalNumber * profit;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, copy  ) NSString * channelCode;
@property (nonatomic, strong) NSNumber * channelId;
@property (nonatomic, strong) NSNumber * couponNum;
@property (nonatomic, copy  ) NSString * desc;
@property (nonatomic, strong) NSNumber * duration;
@property (nonatomic,   copy) NSString * flag;
@property (nonatomic, copy  ) NSString * investProductType;
@property (nonatomic, strong) NSDecimalNumber * minInvestAmount;
@property (nonatomic, copy  ) NSObject * order;
@property (nonatomic, strong) NSNumber * projectDays;
@property (nonatomic, strong) NSNumber * updateTime;
@property (nonatomic, strong) NSNumber * usedTime;
@end
