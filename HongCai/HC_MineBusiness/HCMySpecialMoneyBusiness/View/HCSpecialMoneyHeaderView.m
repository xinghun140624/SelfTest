
//
//  HCSpecialMoneyHeaderView.m
//  HongCai
//
//  Created by Candy on 2017/7/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSpecialMoneyHeaderView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <Masonry/Masonry.h>
#import "HCAccountModel.h"
#import <JSCategories/UIButton+ImageTitleStyle.h>
#import <TYAlertController/UIView+TYAlertView.h>
#import <TYAlertController/TYAlertView.h>
#import "HCPrivilegeEarningsController.h"
@interface HCSpecialMoneyHeaderView ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *cumulativeLabel;
@property (nonatomic, strong) UILabel *cumulativeMoneyLabel;
@property (nonatomic, strong) UILabel *userfulLabel;
@property (nonatomic, strong) UILabel *userfulMoneyLabel;
@property (nonatomic, strong) UIButton * helpButton;
@end

@implementation HCSpecialMoneyHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.bgImageView];
        
        
        UIImage * image = [UIImage imageNamed:@"wdtqbj_bg_nor"];
        
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.bgImageView.mas_width).multipliedBy(image.size.height/image.size.width);
        }];
        [self.bgImageView addSubview:self.cumulativeLabel];
        [self.bgImageView addSubview:self.cumulativeMoneyLabel];
        [self.bgImageView addSubview:self.helpButton];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor whiteColor];
        [self.bgImageView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.bgImageView);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(25.f);
            make.centerX.mas_equalTo(self.bgImageView);
        }];

        
        [self.cumulativeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0);
            make.centerY.mas_equalTo(line).mas_offset(12);
        }];
        CGSize cumulativeDescSize = [@"当前累计特权本金(元)" sizeWithAttributes:@{NSFontAttributeName:self.userfulLabel.font}];
        
        [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 40));
            make.centerX.mas_equalTo(self.cumulativeLabel).mas_offset(cumulativeDescSize.width/2.0+10);
            make.centerY.mas_equalTo(self.cumulativeLabel);
        }];
        [self.cumulativeMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.cumulativeLabel.mas_centerX);
            make.bottom.mas_equalTo(self.cumulativeLabel.mas_top).mas_offset(-2);
        }];
        
        
        
        UIView * rightBottomView = [[UIView alloc] init];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shouyiClick)];
        [rightBottomView addGestureRecognizer:tap];
        [self.bgImageView addSubview:rightBottomView];
        [rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0);
            make.height.mas_equalTo(40);
            make.centerY.mas_equalTo(line);
        }];
        
        [rightBottomView addSubview:self.userfulLabel];
        [rightBottomView addSubview:self.userfulMoneyLabel];
        
       
        [self.userfulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(rightBottomView);
        }];
      
        [self.userfulMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(rightBottomView);
            make.bottom.mas_equalTo(self.userfulLabel.mas_top).mas_offset(-2);
        }];

    }
    return self;
}
- (void)shouyiClick {
    
    HCPrivilegeEarningsController * controller = [HCPrivilegeEarningsController new];
    [[self getCurrentViewController].navigationController pushViewController:controller animated:YES];

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
- (void)helpButtonClick {
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"特权本金介绍" message:@""];
    alertView.buttonCornerRadius = 5.f;
    alertView.layer.cornerRadius = 5.f;
    
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"我知道了" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
    }];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"0xff611d"];
    NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc] init];
    para.paragraphSpacing = 5.f;
    para.lineSpacing = 2.f;
    
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:@"特权本金是平台向用户提供的一种虚拟资金，用于回馈奖励等活动。其本身不可提现或用于投资，但享受8%年化收益率。根据不同的活动规则，特权本金具有不同的计息时长，每日计息产生的收益直接发放至用户可用余额，可用于提现或投资。" attributes:@{NSParagraphStyleAttributeName:para}];
    alertView.messageLabel.attributedText = string;
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addAction:cancel];
    
    [alertView showInController:[self getCurrentViewController] preferredStyle:TYAlertControllerStyleAlert];
}
- (UIButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_helpButton setImage:[UIImage imageNamed:@"wdtqbj_icon_how_nor"] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}


- (UIImageView*)bgImageView {
    if (!_bgImageView){
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wdtqbj_bg_nor"]];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}


-(UILabel *)cumulativeMoneyLabel {
    if (!_cumulativeMoneyLabel) {
        _cumulativeMoneyLabel = [[UILabel alloc] init];
        _cumulativeMoneyLabel.text = @"0.00";
        _cumulativeMoneyLabel.font = [UIFont systemFontOfSize:18];
        _cumulativeMoneyLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
        _cumulativeMoneyLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _cumulativeMoneyLabel;
}
-(UILabel *)cumulativeLabel {
    if (!_cumulativeLabel) {
        _cumulativeLabel = [[UILabel alloc] init];
        _cumulativeLabel.text = @"当前累计特权本金(元)";
        _cumulativeLabel.font = [UIFont systemFontOfSize:10.5];
        _cumulativeLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
        _cumulativeLabel.textAlignment = NSTextAlignmentCenter;
        [_cumulativeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return _cumulativeLabel;
}

-(UILabel *)userfulLabel {
    if (!_userfulLabel) {
        _userfulLabel = [[UILabel alloc] init];
        _userfulLabel.text = @"累计收益(元)";
        [_userfulLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        _userfulLabel.font = [UIFont systemFontOfSize:10.5];
        _userfulLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
        _userfulLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _userfulLabel;
}
-(UILabel *)userfulMoneyLabel {
    if (!_userfulMoneyLabel) {
        _userfulMoneyLabel = [[UILabel alloc] init];
        _userfulMoneyLabel.text = @"0.00";
        _userfulMoneyLabel.font = [UIFont systemFontOfSize:18];
        _userfulMoneyLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
        _userfulMoneyLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _userfulMoneyLabel;
}
@end
