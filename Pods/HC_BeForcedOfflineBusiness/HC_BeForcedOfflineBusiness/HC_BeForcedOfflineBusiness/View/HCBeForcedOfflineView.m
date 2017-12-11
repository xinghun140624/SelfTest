//
//  HCBeForcedOfflineView.m
//  HC_BeForcedOfflineBusiness
//
//  Created by 郭金山 on 2017/9/14.
//  Copyright © 2017年 candy. All rights reserved.
//

#import "HCBeForcedOfflineView.h"
#import <Masonry/Masonry.h>

@interface HCBeForcedOfflineView()


@end

@implementation HCBeForcedOfflineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"被迫下线";
        titleLabel.textColor = [UIColor colorWithRed:1.0 green:97/255.0 blue:29/255.0 alpha:1];
        titleLabel.font = [UIFont systemFontOfSize:16.f];
        [self addSubview:titleLabel];
        
        UILabel * subTitleLabel = [[UILabel alloc] init];
        subTitleLabel.text = @"您的当前账号已在其他设备上登录，请重新登录!";
        subTitleLabel.textAlignment = NSTextAlignmentCenter;

        subTitleLabel.numberOfLines = 0;
        subTitleLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        subTitleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:subTitleLabel];
        
        
        UILabel * descLabel = [UILabel new];
        descLabel.numberOfLines = 0;
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        descLabel.text = @"*如果这不是您本人操作，您的密码可能已遭泄漏，登录后请立刻修改密码，谨防盗号";
        descLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:descLabel];
        
        
        UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        loginButton.backgroundColor = [UIColor colorWithRed:1.0 green:97/255.0 blue:29/255.0 alpha:1];
        [loginButton setTitle:@"重新登录" forState:UIControlStateNormal];
        [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:loginButton];
        
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20.f);
            make.centerX.mas_equalTo(self);
        }];
        
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(subTitleLabel.mas_bottom).mas_offset(15);
            make.left.right.mas_equalTo(subTitleLabel);
        }];
        
        [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descLabel.mas_bottom).mas_offset(25);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(170, 40));
            loginButton.layer.cornerRadius = 20.f;
            make.bottom.mas_equalTo(-15);
        }];
    }
    return self;
}
- (void)loginButtonClick:(UIButton *)button {
    if (self.loginButtonCallBack) {
        self.loginButtonCallBack();
    }
}
@end
