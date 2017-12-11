//
//  HCMemberCenterRemindingView.m
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/10/23.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "HCMemberCenterRemindingView.h"
#import <Masonry/Masonry.h>
#import "NSBundle+JSToastBusiness.h"

@interface HCMemberCenterRemindingView ()
@property (nonatomic, strong) UIImageView *memberGuideImageView;
@end

@implementation HCMemberCenterRemindingView

- (CGSize)intrinsicContentSize {
    return [UIScreen mainScreen].bounds.size;
}
- (void)dealloc {
    
}
-(void)setSection1Frame:(CGRect)section1Frame {
    _section1Frame = section1Frame;
    
    [self.memberGuideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController * navController = (UINavigationController *)tabBarVC.selectedViewController;
        make.top.mas_equalTo(CGRectGetMinY(section1Frame)+ statusBarHeight+navController.navigationBar.frame.size.height-5);
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.height.mas_equalTo(self.memberGuideImageView.mas_width).multipliedBy(321.0/1076.0).priorityHigh();
        make.centerX.mas_equalTo(self);
    }];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds)-40;
        CGFloat height = width * 365.0/686.0;
        UIImageView * arrowImageView1 = [[UIImageView alloc] init];
        arrowImageView1.image = [NSBundle jSToastBusiness_ImageWithName:@"icon_down"];
        [self addSubview:arrowImageView1];
        
        UIImageView * levelDescImageView = [[UIImageView alloc] init];
        levelDescImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"member_djsm"];
        [self addSubview:levelDescImageView];
 
        UIImageView * descImageView = [[UIImageView alloc] init];
        descImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"member_desc_2"];
        [self addSubview:descImageView];

        CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController * navController = (UINavigationController *)tabBarVC.selectedViewController;
        CGFloat navigationBarHeight = navController.navigationBar.frame.size.height;

        [levelDescImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(statusBarHeight+ navigationBarHeight+20+height *0.7);
            make.right.mas_equalTo(-30);
        }];
        [arrowImageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(levelDescImageView.mas_top).mas_offset(-3);
            make.centerX.mas_equalTo(levelDescImageView);
        }];
        
        [descImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowImageView1.mas_left).mas_offset(-10);
            make.centerY.mas_equalTo(arrowImageView1);
        }];
  
        UIImageView *memberGuideImageView = [[UIImageView alloc] init];
        memberGuideImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"member_guide"];
        self.memberGuideImageView = memberGuideImageView;
        [self addSubview:memberGuideImageView];
        
        UIImageView * arrowImageView2 = [[UIImageView alloc] init];
        arrowImageView2.image = [NSBundle jSToastBusiness_ImageWithName:@"icon_down"];
        [self addSubview:arrowImageView2];
        
        [arrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(memberGuideImageView.mas_top).mas_offset(-15);
            make.left.mas_equalTo(memberGuideImageView.mas_left).mas_offset(15);
        }];
  
        UIImageView * descImageView2 = [[UIImageView alloc] init];
        descImageView2.image = [NSBundle jSToastBusiness_ImageWithName:@"member_desc_1"];
        [self addSubview:descImageView2];
        [descImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(arrowImageView2.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(arrowImageView2);
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
