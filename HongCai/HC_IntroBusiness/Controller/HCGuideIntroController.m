//
//  HCGuideIntroController.m
//  HongCai
//
//  Created by Candy on 2017/7/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGuideIntroController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#include <Masonry/Masonry.h>
#import "HCTabBarControllerConfig.h"
#import "HCHomeController.h"
@interface HCGuideIntroController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@end

@implementation HCGuideIntroController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    for (NSInteger index = 0; index<4; index++) {
        NSString * imagePath = nil;
        
        if ([UIScreen mainScreen].bounds.size.height==480) {
            imagePath = [NSString stringWithFormat:@"intro_guide_320_%zd@2x.png",index];
        }else if (CGRectGetHeight([UIScreen mainScreen].bounds)==812){
            imagePath = [NSString stringWithFormat:@"intro_guide_X_%zd@3x.png",index];
        }else {
            imagePath = [NSString stringWithFormat:@"intro_guide_%zd@2x.png",index];
        }
        
        UIImage * image =  [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imagePath]];
        UIImageView * imageView =[[UIImageView alloc] initWithImage:image];
        if (index==3) {
            //最后一张；
            imageView.userInteractionEnabled = YES;
            UIButton * button  = [self button];
            [imageView addSubview:button];
            CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                if ([UIScreen mainScreen].bounds.size.height==480) {
                    make.bottom.mas_equalTo(-height*0.03);
                }else{
                    make.bottom.mas_equalTo(-height*0.08);

                }
                make.centerX.mas_equalTo(imageView);
                make.size.mas_equalTo(CGSizeMake(119, 38));
            }];
        }
        [imageView setFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)*index, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
        [self.scrollView addSubview:imageView];
    }
}
- (UIButton *)button {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"立即体验" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
    button.layer.borderWidth = 0.5f;
    button.layer.borderColor = [UIColor colorWithHexString:@"0xff611d"].CGColor;
    button.layer.cornerRadius = 5.f;
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDown];
    return button;
}
- (void)buttonClick {
    HCTabBarControllerConfig *tabBarControllerConfig = [[HCTabBarControllerConfig alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBarControllerConfig.tabBarController;
}
- (void)loadView {
    self.view = self.scrollView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _scrollView.pagingEnabled = YES;
        CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        _scrollView.contentSize = CGSizeMake(screenWidth*4, CGRectGetHeight([UIScreen mainScreen].bounds));
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
@end
