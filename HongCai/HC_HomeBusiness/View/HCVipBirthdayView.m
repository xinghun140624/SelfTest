//
//  HCVipBirthdayView.m
//  HongCai
//
//  Created by hoolai on 2017/12/6.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCVipBirthdayView.h"

#import <Masonry/Masonry.h>
@implementation HCVipBirthdayView
{
    UIImageView * _imageView;
    UIImageView * _closeImageView;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
        [_imageView addGestureRecognizer:imageTap];
        [self addSubview:_imageView];
        _closeImageView = [[UIImageView alloc] init];
        _closeImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * closeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeTap:)];
        [_closeImageView addGestureRecognizer:closeTap];
        _closeImageView.image = [UIImage imageNamed:@"vip_birthday_close_icon"];
        [self addSubview:_closeImageView];
        CGFloat padding = CGRectGetWidth([UIScreen mainScreen].bounds)*0.18;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(padding);
            make.right.mas_equalTo(-padding);
            make.centerY.mas_equalTo(self);
            make.height.mas_equalTo(_imageView.mas_width).dividedBy(0.85);
        }];
        
        [_closeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_imageView);
            make.top.mas_equalTo(_imageView.mas_bottom).mas_offset(21);
            make.size.mas_equalTo(CGSizeMake(24.5, 24.5));
        }];
        
    }
    return self;
}
- (void)imageTap:(UITapGestureRecognizer *)imageTap {
    if (self.imageClick) {
        self.imageClick();
    }
    
}
- (void)closeTap:(UITapGestureRecognizer *)tap {
    if (self.closeButtonClick) {
        self.closeButtonClick();
    }
    [self removeFromSuperview];
}

@end
