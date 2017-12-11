//
//  HCMineHeaderCell.m
//  HongCai
//
//  Created by Candy on 2017/8/5.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMineHeaderCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <Masonry/Masonry.h>
#import "HCAccountModel.h"
#import <JSCategories/UIButton+ImageTitleStyle.h>

@interface HCMineHeaderCell ()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *currentLabel;
@property (nonatomic, strong) UIButton *eyeButton;
@property (nonatomic, strong) UILabel *totalLabel;//总资产
@property (nonatomic, strong) UILabel *cumulativeLabel;
@property (nonatomic, strong) UILabel *cumulativeMoneyLabel;
@property (nonatomic, strong) UILabel *userfulLabel;
@property (nonatomic, strong) UILabel *userfulMoneyLabel;
@property (nonatomic, strong) UIButton *rechargeButton;
@property (nonatomic, strong) UIButton *tixianButton;
@property (nonatomic, strong) UIButton *openButton;
@property (nonatomic, strong) UIView * leftBottomView;
@property (nonatomic, strong) UIView * rightBottomView;
@end





@implementation HCMineHeaderCell
- (void)clearData {
    self.totalLabel.text = @"0.00";
    self.cumulativeMoneyLabel.text = @"0.00";
    self.userfulMoneyLabel.text = @"0.00";
    self.rechargeButton.hidden = NO;
    self.tixianButton.hidden = NO;
    self.openButton.hidden = YES;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            UIImage * image = [UIImage imageNamed:@"mine_bg_nor"];
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.bgImageView.mas_width).multipliedBy(image.size.height/image.size.width).priorityHigh();
        }];
        [self.bgImageView addSubview:self.currentLabel];
        [self.bgImageView addSubview:self.totalLabel];
        [self.bgImageView addSubview:self.eyeButton];

        UIView * bottomBgView = [[UIView alloc] init];
        [self.contentView addSubview:bottomBgView];
        
        [bottomBgView addSubview:self.rechargeButton];
        [bottomBgView addSubview:self.tixianButton];
        [bottomBgView addSubview:self.openButton];
     
        [self.currentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)==320?10.f:20.f);
            make.centerX.mas_equalTo(self.bgImageView).mas_offset(-15);
            
        }];
        
        
        [self.eyeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.left.mas_equalTo(self.currentLabel.mas_right).mas_offset(5);
            make.centerY.mas_equalTo(self.currentLabel);
        }];
        
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.currentLabel.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self.bgImageView);
        }];
        
        
        
        
        self.leftBottomView = [[UIView alloc] init];
        UITapGestureRecognizer * leftTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        
        [self.leftBottomView addGestureRecognizer:leftTap];
        [self.bgImageView addSubview:self.leftBottomView];
        
        [self.leftBottomView addSubview:self.cumulativeLabel];
        [self.leftBottomView addSubview:self.cumulativeMoneyLabel];
        
        
        [self.leftBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.mas_equalTo(0);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0);
            make.height.mas_equalTo(60);
        }];
        
        //已收收益
        [self.cumulativeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-20);
        }];
        [self.cumulativeMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.cumulativeLabel);
            make.bottom.mas_equalTo(self.cumulativeLabel.mas_top).mas_offset(-2);
        }];
        
        
        self.rightBottomView = [[UIView alloc] init];
        
        UITapGestureRecognizer * rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        
        [self.rightBottomView addGestureRecognizer:rightTap];
        [self.bgImageView addSubview:self.rightBottomView];
        [self.rightBottomView addSubview:self.userfulLabel];
        [self.rightBottomView addSubview:self.userfulMoneyLabel];
        
        [self.rightBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(0);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0);
            make.height.mas_equalTo(60);
        }];
        
        //可用余额
        [self.userfulLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-20);
        }];
        
        [self.userfulMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self.userfulLabel);
            make.bottom.mas_equalTo(self.userfulLabel.mas_top).mas_offset(-2);
        }];
        
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor whiteColor];
        [self.leftBottomView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.cumulativeLabel).mas_offset(-8);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(25.f);
            make.right.mas_equalTo(0);
        }];
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self.contentView addSubview:bottomView];
        
        
        [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgImageView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(74-15);
        }];
        //提现，充值
        CGFloat halfWidth = [UIScreen mainScreen].bounds.size.width/2.0;
        
        
        [self.tixianButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 34.5));
            make.left.mas_equalTo((halfWidth-100)/2.0);
            make.centerY.mas_equalTo(bottomBgView);
        }];
        [self.rechargeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 34.5));
            make.right.mas_equalTo(-(halfWidth-100)/2.0);
            make.centerY.mas_equalTo(bottomBgView);
        }];
        
        [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(bottomBgView);
            make.height.mas_equalTo(30.f);
        }];
        [self.openButton setButtonImageTitleStyle:ButtonImageTitleStyleRight padding:4];
        
        
 
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(bottomBgView.mas_bottom);
            make.height.mas_equalTo(15.f);
        }];
    }
    return self;
}

- (void)assetViewClick:(UITapGestureRecognizer *)tap {
    if ([tap.view isEqual:self.bgImageView] || [tap.view isEqual:self.totalLabel]) {
        if (self.moneyClickCallBack) {
            self.moneyClickCallBack(0);//红背景或者总资产;
        }
    }else if ([tap.view isEqual:self.cumulativeMoneyLabel]||[tap.view isEqual:self.leftBottomView]) {
        if (self.moneyClickCallBack) {
            self.moneyClickCallBack(1);//红背景或者总资产;
        }
        
    }else if ([tap.view isEqual:self.userfulMoneyLabel]||[tap.view isEqual:self.rightBottomView]) {
        if (self.moneyClickCallBack) {
            self.moneyClickCallBack(2);//红背景或者总资产;
        }
        
    }
}



#pragma -mark events
- (void)setModel:(HCAccountModel *)model {
    _model = model;

    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"isHideMoney"] boolValue]) {
        self.totalLabel.text = [NSString stringWithFormat:@"%.2f",[model.totalAssets doubleValue]];
        self.cumulativeMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[model.receivedProfit doubleValue]];
        self.userfulMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[model.balance doubleValue]];
        self.eyeButton.selected = NO;
    }else{
        self.totalLabel.text = @"******";
        self.userfulMoneyLabel.text = @"***";
        self.cumulativeMoneyLabel.text = @"***";
        self.eyeButton.selected = YES;
        
    }
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    if (user) {
        
        [[CTMediator sharedInstance] HCUserBusiness_getUserAuth:@{@"token":user[@"token"]} SuccessCallBack:^(NSDictionary *info) {
            if ([info[@"authStatus"] integerValue]!=2) {
                self.rechargeButton.hidden = YES;
                self.tixianButton.hidden = YES;
                self.openButton.hidden = NO;
            }else {
                self.rechargeButton.hidden = NO;
                self.tixianButton.hidden = NO;
                self.openButton.hidden = YES;
            }
            
            
        }];
        
    }
    
    
    
}
- (void)eyeButtonClick:(UIButton *)button {
    button.selected =!button.isSelected;
    if (button.selected) {
        [[NSUserDefaults standardUserDefaults] setValue:@(1) forKey:@"isHideMoney"];
        
        self.totalLabel.text = @"******";
        self.userfulMoneyLabel.text = @"***";
        self.cumulativeMoneyLabel.text = @"***";
        
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:@(0) forKey:@"isHideMoney"];
        
        self.totalLabel.text = [NSString stringWithFormat:@"%.2f",[self.model.totalAssets doubleValue]];
        self.cumulativeMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.model.receivedProfit doubleValue]];
        self.userfulMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[self.model.balance doubleValue]];
    }
}
- (void)openButtonClick:(UIButton *)button {
    if (self.kaitongCgtCallBack) {
        self.kaitongCgtCallBack();
    }
}
- (void)rechargeButtonClick:(UIButton *)button {
    if (self.rechargeCallBack) {
        self.rechargeCallBack();
    }
}
- (void)tixianButtonClick:(UIButton *)button {
    if (self.tixianCallBack) {
        self.tixianCallBack();
    }
}

- (UIImageView*)bgImageView {
    if (!_bgImageView){
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mine_bg_nor"]];
        _bgImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        [_bgImageView addGestureRecognizer:tap];
    }
    return _bgImageView;
}
-(UILabel *)currentLabel {
    if (!_currentLabel) {
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.text = @"当前资产(元)";
        _currentLabel.font = [UIFont systemFontOfSize:12];
        _currentLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
    }
    return _currentLabel;
}
- (UIButton*)eyeButton {
    if (!_eyeButton){
        _eyeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * norMalbackgroundImage = [[UIImage imageNamed:@"Registration_icon_visiblel_nor_White"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * selectedBackgroundImage = [[UIImage imageNamed:@"Registration_icon_invisiblel_nor_White"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_eyeButton setImage:norMalbackgroundImage forState:UIControlStateNormal];
        _eyeButton.adjustsImageWhenHighlighted = NO;
        
        [_eyeButton setImage:selectedBackgroundImage forState:UIControlStateSelected];
        [_eyeButton addTarget:self action:@selector(eyeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeButton;
}

-(UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.text = @"0.00";
        _totalLabel.font = [UIFont systemFontOfSize:40];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        [_totalLabel addGestureRecognizer:tap];
    }
    return _totalLabel;
}

-(UILabel *)cumulativeMoneyLabel {
    if (!_cumulativeMoneyLabel) {
        _cumulativeMoneyLabel = [[UILabel alloc] init];
        _cumulativeMoneyLabel.text = @"0.00";
        _cumulativeMoneyLabel.font = [UIFont systemFontOfSize:18];
        _cumulativeMoneyLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
        _cumulativeMoneyLabel.textAlignment = NSTextAlignmentCenter;
        _cumulativeMoneyLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        [_cumulativeMoneyLabel addGestureRecognizer:tap];
    }
    return _cumulativeMoneyLabel;
}
-(UILabel *)cumulativeLabel {
    if (!_cumulativeLabel) {
        _cumulativeLabel = [[UILabel alloc] init];
        _cumulativeLabel.text = @"已收收益(元)";
        _cumulativeLabel.font = [UIFont systemFontOfSize:10.5];
        _cumulativeLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
        _cumulativeLabel.textAlignment = NSTextAlignmentCenter;
        [_cumulativeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        [_cumulativeLabel addGestureRecognizer:tap];
    }
    return _cumulativeLabel;
}

-(UILabel *)userfulLabel {
    if (!_userfulLabel) {
        _userfulLabel = [[UILabel alloc] init];
        _userfulLabel.text = @"可用余额(元)";
        //        [_userfulLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_userfulLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        _userfulLabel.font = [UIFont systemFontOfSize:10.5];
        _userfulLabel.textColor = [UIColor colorWithHexString:@"0xfffefe"];
        _userfulLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        [_userfulLabel addGestureRecognizer:tap];
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
        _userfulMoneyLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(assetViewClick:)];
        [_userfulMoneyLabel addGestureRecognizer:tap];
    }
    return _userfulMoneyLabel;
}
- (UIButton *)rechargeButton {
    if (!_rechargeButton) {
        _rechargeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        _rechargeButton.layer.borderColor = [UIColor colorWithHexString:@"0xff611d"].CGColor;
        _rechargeButton.layer.borderWidth = 0.7f ;
        _rechargeButton.layer.cornerRadius = 17.25f;
        [_rechargeButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        [_rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rechargeButton;
}
- (UIButton *)tixianButton {
    if (!_tixianButton) {
        _tixianButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_tixianButton setTitle:@"提现" forState:UIControlStateNormal];
        _tixianButton.layer.borderColor = [UIColor colorWithHexString:@"0xff611d"].CGColor;
        _tixianButton.layer.borderWidth = 0.7f;
        _tixianButton.layer.cornerRadius = 17.25f;
        [_tixianButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        [_tixianButton addTarget:self action:@selector(tixianButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tixianButton;
}

- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_openButton setTitle:@"请开通银行资金存管账户" forState:UIControlStateNormal];
        
        [_openButton setImage:[[UIImage imageNamed:@"mine_icon_ktcg_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        _openButton.hidden = YES;
        [_openButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        [_openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}
@end
