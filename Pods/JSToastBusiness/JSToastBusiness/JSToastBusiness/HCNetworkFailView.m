//
//  HCNetworkFailView.m
//  HongCai
//
//  Created by Candy on 2017/7/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCNetworkFailView.h"
#import <Masonry/Masonry.h>
#import "NSBundle+JSToastBusiness.h"
@interface HCNetworkFailView ()
@end

@implementation HCNetworkFailView
- (CGSize)intrinsicContentSize {
    return CGSizeMake(120, 140);
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.image = [NSBundle jSToastBusiness_ImageWithName:@"kby_icon_mywl_nor"];
        [self addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).mas_offset(-50);
        }];
        
        UILabel * label = [[UILabel alloc] init];
        label.text = @"没有网络";
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(10.f);
            make.centerX.mas_equalTo(self);
        }];
        UILabel * label2 = [[UILabel alloc] init];
        label2.text = @"点击屏幕重新加载";
        label2.font = [UIFont systemFontOfSize:16];
        label2.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0  blue:102/255.0  alpha:1];
        [self addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).mas_offset(10.f);
            make.centerX.mas_equalTo(self);
        }];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadClick)]];
    }
    return self;
}
- (void)reloadClick {
    if (self.reloadViewCallBack) {
        self.reloadViewCallBack();
    }
}

@end
