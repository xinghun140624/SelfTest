//
//  HCAutoTenderOptionProjectDayView.m
//  HongCai
//
//  Created by Candy on 2017/7/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCAutoTenderOptionProjectDayView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>


@interface HCAutoTenderOptionProjectDayView ()
@property (nonatomic, strong) UIButton * projectDayButton;
@property (nonatomic, strong) NSArray * projectDays;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation HCAutoTenderOptionProjectDayView
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
        self.titleLabel.text = @"选择最高标期限";
        self.titleLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        [self addSubview:self.titleLabel];
        
        
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(0);
            make.centerX.mas_equalTo(self);
        }];
        
        NSMutableArray * buttonArray = [NSMutableArray array];
        
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
            [self addSubview:projectDayButton];
            [projectDayButton addTarget:self action:@selector(projectButtonClick:) forControlEvents:UIControlEventTouchUpInside];

            [buttonArray addObject:projectDayButton];
        }
        
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80 leadSpacing:30 tailSpacing:30];        
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(25.f);
            make.height.mas_equalTo(35);
        }];
        
        UIButton * projectDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [projectDayButton setTitle:@"180天" forState:UIControlStateNormal];
        projectDayButton.titleLabel.font = [UIFont systemFontOfSize:15];
        projectDayButton.layer.borderWidth = 1.f;
        [projectDayButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateSelected];
        projectDayButton.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
        projectDayButton.backgroundColor = [UIColor colorWithHexString:@"0xebeaee"];
        projectDayButton.layer.cornerRadius = 4.f;
        [projectDayButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [projectDayButton addTarget:self action:@selector(projectButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:projectDayButton];
        [projectDayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            UIButton * button = buttonArray[1];
            make.left.mas_equalTo(30);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(button.mas_bottom).mas_offset(20.f);

        }];
        [projectDayButton setNeedsLayout];
        [projectDayButton updateConstraintsIfNeeded];

        
        UIButton * projectDayButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [projectDayButton2 setTitle:@"360天" forState:UIControlStateNormal];
        projectDayButton2.titleLabel.font = [UIFont systemFontOfSize:15];
        projectDayButton2.layer.borderWidth = 1.f;
        projectDayButton2.layer.borderColor = [UIColor colorWithHexString:@"0xdddddd"].CGColor;
        projectDayButton2.backgroundColor = [UIColor colorWithHexString:@"0xebeaee"];
        projectDayButton2.layer.cornerRadius = 4.f;
        [projectDayButton2 setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        [projectDayButton2 setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateSelected];

        [projectDayButton2 addTarget:self action:@selector(projectButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:projectDayButton2];
        [projectDayButton2 mas_makeConstraints:^(MASConstraintMaker *make) {
            UIButton * button = buttonArray[1];
            make.left.mas_equalTo(button);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(button.mas_bottom).mas_offset(20.f);
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
    return @[@"30天",@"90天",@"120天"];
}


@end
