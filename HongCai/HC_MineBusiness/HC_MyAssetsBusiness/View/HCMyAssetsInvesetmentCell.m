//
//  HCMyAssetsInvesetmentCell.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyAssetsInvesetmentCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+MyAssetsModule.h"
#import "HCCheckUserService.h"
@interface HCMyAssetsInvesetmentCell()
@property (nonatomic, strong) UIButton *invesetmentButton;
@property (nonatomic, strong) UIButton *rechargeButton;

@end
@implementation HCMyAssetsInvesetmentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.invesetmentButton];
        [self.contentView addSubview:self.rechargeButton];
        [self layout_Masonry];
  
    }
    return self;
}
- (void)layout_Masonry {
    [self.invesetmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(56.f);
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.height.mas_equalTo(self.invesetmentButton.mas_width).multipliedBy(274.0/1446.0);
    }];
    [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.invesetmentButton.mas_bottom).mas_offset(2.f);
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.height.mas_equalTo(self.rechargeButton.mas_width).multipliedBy(274.0/1446.0);
    }];
}
/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

#pragma -mark events
- (void)invesetmentButtonClick:(UIButton *)button {
    UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVC.selectedIndex = 1;
    [[self getCurrentViewController].navigationController popToRootViewControllerAnimated:NO];
}

- (void)rechargeButtonClick:(UIButton *)button {
    [HCCheckUserService checkUserAuthStatusAndBankcard:[self getCurrentViewController] success:^(BOOL success) {
        if (success) {
            [[self getCurrentViewController].navigationController pushViewController:[NSClassFromString(@"HCRechargeController") new] animated:YES];
        }
    }];
 
}

- (UIButton*)invesetmentButton {
    if (!_invesetmentButton){
        _invesetmentButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _invesetmentButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_invesetmentButton setTitle:@"去投资" forState:UIControlStateNormal];
        [_invesetmentButton addTarget:self action:@selector(invesetmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle myAssets_ImageWithName:@"zhzlb_btn_qtz_nor"];
        _invesetmentButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_invesetmentButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [_invesetmentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _invesetmentButton;
}

- (UIButton*)rechargeButton {
    if (!_rechargeButton){
        _rechargeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _rechargeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_rechargeButton setTitle:@"去充值" forState:UIControlStateNormal];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle myAssets_ImageWithName:@"zhzlb_btn_qcz_nor"];
        _rechargeButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [_rechargeButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _rechargeButton;
}
@end
