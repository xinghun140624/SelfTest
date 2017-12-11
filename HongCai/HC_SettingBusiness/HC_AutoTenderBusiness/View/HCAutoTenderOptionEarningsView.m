//
//  HCAutoTenderOptionEarningsView.m
//  HongCai
//
//  Created by Candy on 2017/7/20.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAutoTenderOptionEarningsView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>


@interface HCAutoTenderOptionEarningsView ()
@property (nonatomic, strong) NSArray * projectDays;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation HCAutoTenderOptionEarningsView
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tc_icon"]];
    }
    return _iconView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self  = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(-30);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.mas_equalTo(self);
        }];
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = @"选择最低期望收益";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        [self addSubview:self.titleLabel];
        
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self);
        }];
        
        NSMutableArray * firstButtonArray = [NSMutableArray array];
        NSMutableArray * secondButtonArray = [NSMutableArray array];
        for (NSInteger index = 0; index < self.projectDays.count; index++) {
            UIButton * projectDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [projectDayButton setTitle:self.projectDays[index] forState:UIControlStateNormal];
            projectDayButton.titleLabel.font = [UIFont systemFontOfSize:15];
            projectDayButton.layer.borderWidth = 1.f;
            projectDayButton.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
            projectDayButton.backgroundColor = [UIColor colorWithHexString:@"0xebeaee"];
            projectDayButton.layer.cornerRadius = 4.f;
            [projectDayButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
            [projectDayButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateSelected];
            [projectDayButton addTarget:self action:@selector(projectButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            [self addSubview:projectDayButton];
            if (index<3) {
                [firstButtonArray addObject:projectDayButton];
            }else{
                [secondButtonArray addObject:projectDayButton];
            }
        }
        
        [firstButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:30 tailSpacing:30];
        [secondButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:30 tailSpacing:30];

        [firstButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(25.f);
            make.height.mas_equalTo(35);
        }];
        [secondButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            UIButton * button =firstButtonArray[0];
            make.top.mas_equalTo(button.mas_bottom).mas_offset(20.f);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(80);
        }];
        
        
        
    }
    return self;
}
- (void)projectButtonClick:(UIButton *)button {
    for (UIView  * subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * subButton = (UIButton *)subView;
            subButton.selected = NO;
            subButton.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
            subButton.backgroundColor = [UIColor colorWithHexString:@"0xebeaee"];
        }
    }
    button.selected = YES;
    button.layer.borderColor = [UIColor colorWithHexString:@"0xff611d"].CGColor;
    button.backgroundColor = [UIColor colorWithHexString:@"0xf3ccc1"];
    if(self.selectCallBack){
        self.selectCallBack(button);
    }
    [[self getCurrentViewController] dismissViewControllerAnimated:YES completion:NULL];
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
- (NSArray *)projectDays {
    return @[@"7%",@"8%",@"9%",@"10%",@"11%",@"12%"];
}


@end
