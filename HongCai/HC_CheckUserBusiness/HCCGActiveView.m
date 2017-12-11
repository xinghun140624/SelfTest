//
//  HCCGActiveView.m
//  HongCai
//
//  Created by Candy on 2017/7/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCGActiveView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>


@interface HCCGActiveView ()
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UIButton * detailButton;
@property (nonatomic, strong) UIButton * openButton;
@property (nonatomic, strong) UILabel * descLabel;
@end

@implementation HCCGActiveView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.detailButton];
        [self.bgImageView addSubview:self.openButton];
        [self.bgImageView addSubview:self.descLabel];
        [self layout_Masonry];
    }
    return self;
}

- (void)layout_Masonry {
    
    CGSize imageSize = [UIImage imageNamed:@"app_bg_pop_yhcg"].size;
    CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds) -30;
    CGFloat height = width * imageSize.height/imageSize.width;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.mas_equalTo(self);
   
        
        make.size.mas_equalTo(CGSizeMake(width , height));
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(height*0.67);
        make.left.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)*0.12);
        make.right.mas_equalTo(-CGRectGetWidth([UIScreen mainScreen].bounds)*0.12);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)*0.1);
        make.bottom.mas_equalTo(-height*0.03);
        if (CGRectGetWidth([UIScreen mainScreen].bounds)==320) {
            make.size.mas_equalTo(CGSizeMake(100, 43));
        }
    }];
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-CGRectGetWidth([UIScreen mainScreen].bounds)*0.12);
        make.bottom.mas_equalTo(-height*0.03);
        if (CGRectGetWidth([UIScreen mainScreen].bounds)==320) {
            make.size.mas_equalTo(CGSizeMake(100, 43.5));
        }
    }];
}
- (void)detailButtonClick {
    if (self.detailButtonCallBack) {
        self.detailButtonCallBack();
    }
}
- (void)openButtonClick {
    if (self.openButtonCallBack) {
        self.openButtonCallBack();
    }
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        UIImage * bgImge = [UIImage imageNamed:@"app_bg_pop_yhcg"];
        _bgImageView.image = bgImge;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}
- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_detailButton setTitle:@"了解详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_detailButton setBackgroundImage:[UIImage imageNamed:@"btn_ljxq_nor"] forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}
- (UIButton *)openButton {
    if (!_openButton) {
        _openButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_openButton setTitle:@"立即开通" forState:UIControlStateNormal];
        [_openButton setTitleColor:[UIColor colorWithHexString:@"0x000142"]  forState:UIControlStateNormal];
        _openButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_openButton setBackgroundImage:[UIImage imageNamed:@"btn_ljkt_nor"] forState:UIControlStateNormal];
        [_openButton addTarget:self action:@selector(openButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}
- (UILabel *)descLabel {
    if(!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexString:@"0x000142"];
        _descLabel.font = [UIFont systemFontOfSize:11.5];
        _descLabel.numberOfLines = 0;
        NSMutableParagraphStyle * paraStryle = [[NSMutableParagraphStyle alloc] init];
        paraStryle.lineSpacing = 5.f;
    
        CGFloat fontSize = 0;
        if (CGRectGetWidth([UIScreen mainScreen].bounds)==320) {
            fontSize = 10;
        }else{
            fontSize = 11.5;
        }
        
        
         NSAttributedString * attrContent = [[NSAttributedString alloc] initWithString:@"尊敬的宏财用户，您的账户已升级为银行资金存管账户，请点击下方按钮开通，尽享安全投资。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x000142"],NSParagraphStyleAttributeName:paraStryle}];

        _descLabel.attributedText = attrContent;
    }
    return _descLabel;
}
@end
