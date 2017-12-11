//
//  HCHomeHeaderView.m
//  HongCai
//
//  Created by Candy on 2017/6/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCHomeHeaderView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>

#import "HCBannerModel.h"
#import "HCActivityModel.h"

#import "HCHomeNoticeView.h"
@interface HCHomeButton : UIButton

@end

@implementation HCHomeButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat y = 5;
    return CGRectMake(contentRect.size.width*0.15, y, contentRect.size.width*0.7, contentRect.size.width*0.7);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat y = contentRect.size.height *0.7;
    return CGRectMake(0, y, contentRect.size.width, contentRect.size.height*0.2);
}
@end

@interface HCHomeHeaderView ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong, readwrite) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) HCHomeNoticeView *homeNoticeView;
@property (nonatomic, strong) NSArray * buttonAray;
@end

@implementation HCHomeHeaderView
- (void)setActivictyModels:(NSArray<HCActivityModel *> *)activictyModels {
    _activictyModels = activictyModels;
    if (activictyModels.count>0) {
        [self.buttonAray enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
            HCActivityModel * model = activictyModels[idx];
            [button sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_zwf_nor"]];
            [button setTitle:model.title forState:UIControlStateNormal];
        }];
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xfeffff"];
        [self addSubview:self.cycleScrollView];
        [self addSubview:self.homeNoticeView];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.homeNoticeView.frame), CGRectGetWidth(self.frame), 0.5f)];
        line.backgroundColor = [UIColor colorWithHexString:@"0xefefef"];
        [self addSubview:line];
        NSMutableArray * buttonArray = [NSMutableArray array];
        for (NSInteger i=0; i<4; i++) {
            HCHomeButton * button = [HCHomeButton buttonWithType:UIButtonTypeCustom];
            button.tag = 100+i;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            button.titleLabel.font = [UIFont systemFontOfSize:11.f];
            [button setTitleColor:[UIColor colorWithHexString:@"0x333333"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            [buttonArray addObject:button];
        }
        [buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:60.f leadSpacing:15 tailSpacing:15];
        [buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).mas_offset(5);
            make.size.mas_equalTo(CGSizeMake(60, 70));
        }];
        self.buttonAray = buttonArray;
    }
    return self;
}

#pragma -mark events
- (void)buttonClick:(UIButton *)button {
    HCActivityModel * model = self.activictyModels[button.tag-100];
    if (model.openSite==1) {
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:model.linkUrl}];
        [self.controller.navigationController pushViewController:controller animated:YES];
    }
}

#pragma -mark Setters&&Getters
- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup {
    if (_imageURLStringsGroup !=imageURLStringsGroup) {
        _imageURLStringsGroup = imageURLStringsGroup;
        if (imageURLStringsGroup.count>0) {
            UIView * view = [self.cycleScrollView valueForKey:@"backgroundImageView"];
            view.hidden = YES;
        }
        self.cycleScrollView.imageURLStringsGroup = imageURLStringsGroup;
    }
}
#pragma -mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    HCBannerModel * banner = self.bannerModelArray[index];
    if ([banner.linkUrl hasPrefix:@"http"]||[banner.linkUrl hasPrefix:@"https"]) {
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:banner.linkUrl}];
        [self.controller.navigationController pushViewController:controller animated:YES];
    }
}
#pragma -mark lazyLoadings
- (SDCycleScrollView*)cycleScrollView {
    if (!_cycleScrollView){
        CGFloat height = CGRectGetWidth(self.frame)*19.0/40.0;
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), height);
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:frame
                                                              delegate:self
                                                      placeholderImage:[UIImage imageNamed:@"logo_zwf_nor"]];
        _cycleScrollView.autoScrollTimeInterval = 3;
    }
    return _cycleScrollView;
}
- (HCHomeNoticeView*)homeNoticeView {
    if (!_homeNoticeView){
        _homeNoticeView = [[HCHomeNoticeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cycleScrollView.frame), CGRectGetWidth(self.frame), 28.f)];
    }
    return _homeNoticeView;
}

@end
