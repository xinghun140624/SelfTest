//
//  HCUserBankCardModel.h
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/9.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
@interface HCUserBankCardModel : NSObject <YYModel>
@property (nonatomic, strong) NSNumber * bankCardId;
@property (nonatomic,   copy) NSString * cardNo;
@property (nonatomic, strong) NSNumber * userId;
@property (nonatomic,  copy) NSString * mobile;
@property (nonatomic, strong) NSNumber * createTime;
@property (nonatomic, strong) NSNumber * updateTime;
@property (nonatomic, assign) BOOL verifing;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, assign) BOOL initBankcard;
@property (nonatomic,   copy) NSString * bankCode;
@property (nonatomic,   copy) NSString * openBank;
@property (nonatomic,   copy) NSString * status;


@end

