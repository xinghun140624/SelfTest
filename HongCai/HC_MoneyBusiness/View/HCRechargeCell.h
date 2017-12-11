//
//  HCRechargeCell.h
//  HongCai
//
//  Created by Candy on 2017/6/13.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

//顶部账户余额
@interface HCRechargeTopCell : UITableViewCell
@property (nonatomic, strong) UILabel *accountBalanceLabel;
@end


@interface HCRechargeBankCell : UITableViewCell
@property (nonatomic, strong) UIImageView *bankIconView;
@property (nonatomic, strong) UILabel *bankNameLabel;
@property (nonatomic, strong) UILabel *bankAccountLabel;
@end



@interface HCRechargeInputCell : UITableViewCell
@property (nonatomic, strong) UITextField *rechargeTextField;
@property (nonatomic, strong) UILabel  *jinELabel;

@end

@interface HCRechargeBottomCell : UITableViewCell
@property (nonatomic, strong) UIButton *payButton;
@property (nonatomic, strong) UILabel  *bottomLabel;

@end


