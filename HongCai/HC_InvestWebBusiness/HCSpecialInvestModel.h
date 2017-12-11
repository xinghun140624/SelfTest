//
//  HCSpecialInvestModel.h
//  HongCai
//
//  Created by 郭金山 on 2017/8/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCSpecialInvestRuleModel: NSObject<YYModel>
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, assign) int level;
@property (nonatomic, strong) NSDecimalNumber * minInvestAmount;
@end


@interface HCSpecialInvestModel : NSObject <YYModel>
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, assign) int cutRateWay;
@property (nonatomic, strong) NSDecimalNumber * baseRate;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, strong) NSArray <HCSpecialInvestRuleModel *>* rules;
@end
