//
//  HCMineHeaderCell.h
//  HongCai
//
//  Created by Candy on 2017/8/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCAccountModel;
@interface HCMineHeaderCell : UICollectionViewCell
@property (nonatomic, strong) HCAccountModel *model;
@property (nonatomic, copy) dispatch_block_t rechargeCallBack;
@property (nonatomic, copy) dispatch_block_t tixianCallBack;
@property (nonatomic, copy) dispatch_block_t kaitongCgtCallBack;
@property (nonatomic, copy) void(^moneyClickCallBack)(NSInteger type);
- (void)clearData;
@end
