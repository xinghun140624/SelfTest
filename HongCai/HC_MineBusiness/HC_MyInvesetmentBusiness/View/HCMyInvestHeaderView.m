//
//  HCMyInvestHeaderView.m
//  HongCai
//
//  Created by 郭金山 on 2017/9/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyInvestHeaderView.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
@interface HCMyInvestHeaderView ()
@property (nonatomic, strong) SCPieChart *chartView;
@property (nonatomic, strong) UILabel * statusLabel;
@end

@implementation HCMyInvestHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self addSubview:self.chartView];
   
        UILabel * label = [[UILabel alloc] init];
        label.text = @"待收本金(元)";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor colorWithHexString:@"0xff611d"];
        [self.chartView addSubview:label];
        [self.chartView bringSubviewToFront:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.chartView);
            make.centerY.mas_equalTo(self.chartView).mas_offset(-20);
        }];
        
        
        [self.chartView addSubview:self.statusLabel];
        [self.chartView bringSubviewToFront:self.statusLabel];
        
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.chartView);
            make.top.mas_equalTo(label.mas_bottom).mas_offset(5);
        }];

        
        
        UILabel * zunguiLabel = [[UILabel alloc] init];
        zunguiLabel.text = @"宏财尊贵";
        zunguiLabel.font = [UIFont systemFontOfSize:12];
        zunguiLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        [self addSubview:zunguiLabel];
        
        [zunguiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chartView.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(zunguiLabel.superview).mas_offset(10);
        }];
        
        UIView * middleView = [UIView new];
        middleView.layer.cornerRadius = 5.f;
        middleView.backgroundColor = [UIColor colorWithHexString:@"0xf0ad32"];
        [self addSubview:middleView];
        
        [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(zunguiLabel.mas_left).mas_offset(-8);
            make.centerY.mas_equalTo(zunguiLabel);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        UILabel * jingxuanLabel = [[UILabel alloc] init];
        jingxuanLabel.text = @"宏财精选";
        jingxuanLabel.font = [UIFont systemFontOfSize:12];
        jingxuanLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        [self addSubview:jingxuanLabel];
        
        [jingxuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chartView.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(jingxuanLabel.superview).mas_offset(-100);
        }];
        
        UIView * leftView = [UIView new];
        leftView.layer.cornerRadius = 5.f;
        leftView.backgroundColor = [UIColor colorWithHexString:@"0xa0d434"];
        [self addSubview:leftView];
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(jingxuanLabel.mas_left).mas_offset(-8);
            make.centerY.mas_equalTo(jingxuanLabel);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        UILabel * zhaiquanLabel = [[UILabel alloc] init];
        zhaiquanLabel.text = @"债权转让";
        zhaiquanLabel.font = [UIFont systemFontOfSize:12];
        zhaiquanLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
        [self addSubview:zhaiquanLabel];
        
        [zhaiquanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chartView.mas_bottom).mas_offset(15);
            make.centerX.mas_equalTo(zhaiquanLabel.superview).mas_offset(120);
   
        }];
        
        UIView * rightView = [UIView new];
        rightView.layer.cornerRadius = 5.f;
        rightView.backgroundColor = [UIColor colorWithHexString:@"0x7460dc"];
        [self addSubview:rightView];
        
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(zhaiquanLabel.mas_left).mas_offset(-8);
            make.centerY.mas_equalTo(zhaiquanLabel);
            make.size.mas_equalTo(CGSizeMake(10, 10));
        }];
        
        
    }
    return self;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _statusLabel.font = [UIFont systemFontOfSize:13];
    }
    return _statusLabel;
}
- (SCPieChart *)chartView {
    if (!_chartView) {
        NSArray *items = @[[SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"0xa0d434"] description:@"A"],
                           [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"0xf0ad32"] description:@"B"],
                           [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"0x7460dc"] description:@"C"]];
        _chartView = [[SCPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-190)*0.5, 30, 190, 190) items:items];
        [_chartView setValue:@(CGRectGetWidth(_chartView.bounds) / 2.8) forKey:@"innerCircleRadius"];
        _chartView.descriptionTextColor = [UIColor clearColor];
    }
    return _chartView;
}
@end
