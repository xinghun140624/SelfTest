//
//  HCMineRemindingView.m
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/10/20.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "HCMineRemindingView.h"
#import <Masonry/Masonry.h>
#import "NSBundle+JSToastBusiness.h"

@implementation HCMineRemindingView

- (CGSize)intrinsicContentSize {
    return [UIScreen mainScreen].bounds.size;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);


        UIImageView * helpImageView = [[UIImageView alloc] init];
        helpImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"bzzx"];
        [self addSubview:helpImageView];
        
        [helpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            if (CGRectGetWidth([UIScreen mainScreen].bounds)>375) {
                make.bottom.mas_equalTo(self).mas_offset(-height*0.10);
                make.size.mas_equalTo(CGSizeMake(100, 100));
                
            }else{
                if (CGRectGetHeight([UIScreen mainScreen].bounds)==812) {
                    make.bottom.mas_equalTo(self).mas_offset(-height *0.22);
                }else{
                    make.bottom.mas_equalTo(self).mas_offset(-height *0.08);
                }
                make.size.mas_equalTo(CGSizeMake(80, 80));
                
            }
        }];
        
        UIImageView * arrowImageView1 = [[UIImageView alloc] init];
        arrowImageView1.image = [NSBundle jSToastBusiness_ImageWithName:@"icon_down"];
        [self addSubview:arrowImageView1];
        [arrowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(helpImageView.mas_top).mas_offset(-15);
            make.centerX.mas_equalTo(helpImageView.mas_centerX);
        }];
        
        UIImageView * desc1ImageView = [[UIImageView alloc] init];
        desc1ImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"mine_desc_1"];
        [self addSubview:desc1ImageView];
        
        [desc1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImageView1.mas_left).mas_offset(-5);
            make.bottom.mas_equalTo(arrowImageView1.mas_bottom).mas_offset(-3);
        }];
        
        UIImageView * calendarView = [[UIImageView alloc] init];
        calendarView.image = [NSBundle jSToastBusiness_ImageWithName:@"hkrl"];
        [self addSubview:calendarView];
        
        [calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(helpImageView.mas_top).mas_offset(-15);
            if (CGRectGetWidth([UIScreen mainScreen].bounds)>375) {
                make.size.mas_equalTo(CGSizeMake(100, 100));
            }else{
                make.size.mas_equalTo(CGSizeMake(80, 80));
            }
        }];
        
        UIImageView * arrowImageView2 = [[UIImageView alloc] init];
        arrowImageView2.image = [NSBundle jSToastBusiness_ImageWithName:@"icon_down"];
        [self addSubview:arrowImageView2];
        [arrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(calendarView.mas_top).mas_offset(-15);
            make.centerX.mas_equalTo(calendarView.mas_centerX);
        }];
        
        UIImageView * desc2ImageView = [[UIImageView alloc] init];
        desc2ImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"mine_desc_2"];
        [self addSubview:desc2ImageView];
        
        [desc2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImageView2.mas_left).mas_offset(-5);
            make.bottom.mas_equalTo(arrowImageView2.mas_bottom).mas_offset(-5);
        }];
        

        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
    }
    return self;
}
- (void)tapClick:(UITapGestureRecognizer *)tap {
    if (self.tapClick) {
        self.tapClick();
    }
}



@end
