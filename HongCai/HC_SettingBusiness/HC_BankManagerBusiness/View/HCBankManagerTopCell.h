//
//  HCBankManagerTopCell.h
//  HC_SettingBusiness
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HCBankManagerTopCell : UITableViewCell
@property (nonatomic, strong, readonly) UIImageView *bankIconView;
@property (nonatomic, strong, readonly) UILabel *bankNameLabel;
@property (nonatomic, strong, readonly) UILabel *bankAccountLabel;
@end


@interface HCBankManagerMobileCell : UITableViewCell
@property (nonatomic, strong, readonly) UILabel * mobileLabel;
@property (nonatomic, copy)void(^modifyButtonClickCallBack)(void);
@end

@interface HCBankManagerJieBangCell : UITableViewCell
@property (nonatomic, copy)void(^jiebangButtonClickCallBack)(void);
@end
