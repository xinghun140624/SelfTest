//
//  HCShareView.m
//  HC_ShareBusiness
//
//  Created by Candy on 2017/6/30.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCShareView.h"
#import "NSBundle+HCShareModule.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "UIButton+ImageTitleStyle.h"

@interface HCShareView ()
@property (nonatomic, strong) UIButton *wechatButton;
@property (nonatomic, strong) UIButton *qqButton;
@property (nonatomic, strong) UIButton *copyButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation HCShareView {
    NSArray * _buttonArray;
    UILabel * _shareLabel;
}
- (void)shareButtonClick:(UIButton *)button {
    if (self.shareButtonClickCallBack) {
        self.shareButtonClickCallBack(button.tag-100);
    }
}
- (void)cancelButtonClick:(UIButton *)button {
    if (self.cancelButtonClickCallBack) {
        self.cancelButtonClickCallBack();
    }
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
       
        [self initSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
      
        [self initSubViews];
    }
    return self;
}
- (void)setType:(NSInteger)type {
    _type = type;
    if (type==2) {
        [self.copyButton removeFromSuperview];

    }
}
- (void)initSubViews {
    self.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    
    
    UILabel *shareLabel = [[UILabel alloc] init];
    shareLabel.text = @"分享到：";
    shareLabel.font = [UIFont systemFontOfSize:15.f];
    _shareLabel = shareLabel;
    [self addSubview:shareLabel];
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24.f);
        make.left.mas_equalTo(24.f);
    }];
    
    [self addSubview:self.wechatButton];
    [self addSubview:self.qqButton];
    [self addSubview:self.copyButton];
    NSArray * buttonArray = @[self.wechatButton,self.qqButton,self.copyButton];
    [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:30 tailSpacing:30];
    [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(80);
        make.top.mas_equalTo(shareLabel.mas_bottom).mas_offset(25.f);
    }];
    [self.wechatButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:8];
    [self.qqButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:8];
    [self.copyButton setButtonImageTitleStyle:ButtonImageTitleStyleTop padding:8];
    
    [self addSubview:self.cancelButton];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
}


- (UIButton *)qqButton {
    if (!_qqButton) {
        _qqButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_qqButton setTitle:@"QQ好友" forState:UIControlStateNormal];
        _qqButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_qqButton setImage:[NSBundle share_ImageWithName:@"tc_icon_qq_nor"] forState:UIControlStateNormal];
        _qqButton.titleLabel.font =[UIFont systemFontOfSize:13];
        [_qqButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        _qqButton.tag = 101;
        [_qqButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqButton;
}

- (UIButton *)copyButton {
    if (!_copyButton) {
        _copyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_copyButton setImage:[NSBundle share_ImageWithName:@"tc_icon_lj_nor"] forState:UIControlStateNormal];
        [_copyButton setTitle:@"复制链接" forState:UIControlStateNormal];
        _copyButton.titleLabel.font =[UIFont systemFontOfSize:13];
        [_copyButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        _copyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _copyButton.tag = 102;
        [_copyButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _copyButton;
}
- (UIButton *)wechatButton {
    if (!_wechatButton) {
        _wechatButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_wechatButton setImage:[NSBundle share_ImageWithName:@"tc_icon_wx_nor"] forState:UIControlStateNormal];
        [_wechatButton setTitle:@"微信好友" forState:UIControlStateNormal];
        _wechatButton.titleLabel.font =[UIFont systemFontOfSize:13];
        [_wechatButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        _wechatButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _wechatButton.tag = 100;
        [_wechatButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wechatButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [_cancelButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
@end
