//
//  HCWithDrawModel.h
//  HongCai
//
//  Created by Candy on 2017/11/28.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel/YYModel.h>
#import "HCAccountModel.h"
#import "HCUserBankCardModel.h"

@interface HCWithDrawModel : NSObject<YYModel>
@property (nonatomic, assign) NSInteger  withdrawFee;
@property (nonatomic,   copy) NSString *cardStatus;
@property (nonatomic, strong) HCAccountModel *account;
@property (nonatomic, strong) HCUserBankCardModel *bankcard;
@end
