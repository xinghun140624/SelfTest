//
//  HCHomeNoticeView.m
//  HongCai
//
//  Created by Candy on 2017/6/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCHomeNoticeView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCNetworkConfig.h"
@interface HCHomeNoticeView ()
@property (nonatomic, strong, readwrite) UIImageView *noticeImageView;
@property (nonatomic, strong, readwrite) SXHeadLine *headLine;
@property (nonatomic, strong, readwrite) UIButton *moreButton;
@end

@implementation HCHomeNoticeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.noticeImageView];
        [self addSubview:self.headLine];
        [self addSubview:self.moreButton];
        [self layout_Masonry];
    }
    return self;
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
- (void)layout_Masonry {
    [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15.5, 13));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(20.f);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40,20));
        make.centerY.mas_equalTo(self.noticeImageView);
        make.right.mas_equalTo(-5);
    }];

}
- (void)moreButtonClick {
    UIViewController * controller = [[CTMediator sharedInstance] HCMessageBusiness_viewControllerWithIndex:0];
    [[self getCurrentViewController].navigationController pushViewController:controller animated:YES];
}
- (void)setNoticeModels:(NSArray *)noticeModels {
    
    _noticeModels = noticeModels;
    NSMutableArray * tempArray = [NSMutableArray array];
    
    [noticeModels enumerateObjectsUsingBlock:^(HCNoticeModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempArray addObject:model.title];
    }];
    self.headLine.messageArray = tempArray;
    [self.headLine start];
}
- (SXHeadLine*)headLine {
    if (!_headLine){
        _headLine = [[SXHeadLine alloc] initWithFrame:CGRectMake(40,5,[UIScreen mainScreen].bounds.size.width-70,18)];
        UIColor * textColor = [UIColor colorWithHexString:@"0x666666"];
        [_headLine setBgColor:[UIColor whiteColor] textColor:textColor textFont:[UIFont systemFontOfSize:12]];
        [_headLine setScrollDuration:1 stayDuration:4];
        __weak typeof(self) weakSelf = self;
        [_headLine changeTapMarqueeAction:^(NSInteger index) {
            HCNoticeModel * model = weakSelf.noticeModels[index];
            NSString * url = [NSString stringWithFormat:@"%@user-center/messages/%@",WebBaseURL,model.noticeId];
            UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
            [[weakSelf getCurrentViewController].navigationController pushViewController:controller animated:YES];
        }];
        _headLine.hasGradient = YES;
    }
    return _headLine;
}
- (UIImageView *)noticeImageView {
    if (!_noticeImageView) {
        _noticeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_icon_notice_nor"]];
    }
    return _noticeImageView;
}
- (UIButton*)moreButton {
    if (!_moreButton){
        _moreButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * backgroundImage = [UIImage imageNamed:@"home_icon_more_nor"];
        backgroundImage = [backgroundImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_moreButton setImage:backgroundImage forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(moreButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
