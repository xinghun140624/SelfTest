//
//  HCAutoTenderDateView.m
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAutoTenderDateView.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>


@interface HCAutoTenderDateView ()
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIDatePicker * dataPicker;
@property (nonatomic, strong) UIButton * doneButton;

@end

@implementation HCAutoTenderDateView

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tc_icon"]];
    }
    return _iconView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self  = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"设置开始时间";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        [self addSubview:self.titleLabel];
        
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(45);
            make.centerX.mas_equalTo(self);
        }];
        
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"0xefefef"];
        [self addSubview:line];
        
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(45);
            make.height.mas_equalTo(0.5);
        }];
        
        
        
        self.dataPicker = [[UIDatePicker alloc] init];
        self.dataPicker.datePickerMode = UIDatePickerModeDate;
        self.dataPicker.locale = [NSLocale currentLocale];
        
        [self addSubview: self.dataPicker];
        
        [self.dataPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
            make.centerX.mas_equalTo(self);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.doneButton setTitle:@"完成" forState:UIControlStateNormal];
        self.doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.doneButton addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.doneButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        self.doneButton.layer.cornerRadius = 3.f;
        [self addSubview:self.doneButton];
        [self.doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(70, 30));
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.titleLabel);
        }];
        
        
    }
    return self;
}
- (void)doneButtonClick:(UIButton *)button {
    [[self getCurrentViewController] dismissViewControllerAnimated:YES completion:NULL];
    if (self.selectTimeCallBack) {
        self.selectTimeCallBack(self.dataPicker.date);
    }
}
- (void)setMinimumDate:(NSDate *)minimumDate {
    _minimumDate = minimumDate;
    self.dataPicker.minimumDate = minimumDate;
}
- (void)setMaximumDate:(NSDate *)maximumDate {
    _maximumDate = maximumDate;
    self.dataPicker.maximumDate = maximumDate;
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
@end
