//
//  HCInvestCouponModel.h
//  Pods
//
//  Created by Candy on 2017/6/29.
//
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCGoToInvestCouponModel : NSObject<YYModel>

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
@property (nonatomic, strong) NSNumber * profit;
@property (nonatomic, strong) NSNumber * activityId;
@property (nonatomic, copy  ) NSString * channelCode;
@property (nonatomic, strong) NSNumber * channelId;
@property (nonatomic, strong) NSNumber * couponNum;
@property (nonatomic, copy  ) NSString * desc;
@property (nonatomic, strong) NSNumber * duration;
@property (nonatomic, strong) NSNumber * flag;
@property (nonatomic, copy  ) NSString * investProductType;
@property (nonatomic, strong) NSNumber * minInvestAmount;
@property (nonatomic, copy  ) NSString * order;
@property (nonatomic, strong) NSNumber * projectDays;
@property (nonatomic, strong) NSNumber * updateTime;
@property (nonatomic, strong) NSNumber * usedTime;
@property (nonatomic, assign) BOOL isSelected;

@end
