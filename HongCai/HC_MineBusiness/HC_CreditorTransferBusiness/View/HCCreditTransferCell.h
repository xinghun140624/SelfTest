//
//  HCCreditTransferCell.h
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCAssignmentModel;
@class HCMyInvestModel;
@interface HCCreditTransferCell : UITableViewCell
@property (nonatomic, strong) HCMyInvestModel *model;
@property (nonatomic, strong) HCAssignmentModel * assignModel;
@property (nonatomic, strong, readonly) UIButton *transferButton;
@property (nonatomic, copy) void(^transferButtonCallBack)(void);
@end
