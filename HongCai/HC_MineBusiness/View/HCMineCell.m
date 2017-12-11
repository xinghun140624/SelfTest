//
//  HCMineCell.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMineCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>


@interface HCMineButton : UIButton

@end

@implementation HCMineButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat y = 5;
    return CGRectMake(contentRect.size.width*0.175, y, contentRect.size.width*0.65, contentRect.size.width*0.65);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat y = contentRect.size.height *0.7;
    return CGRectMake(0, y, contentRect.size.width, contentRect.size.height*0.30);
}

@end


@interface HCMineCell()
@property (nonatomic, strong) HCMineButton *button;
@property (nonatomic, strong) JSBadgeView * badgeView;
@end

@implementation HCMineCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.button];
        self.badgeView.badgeTextColor = [UIColor whiteColor];
        self.badgeView.badgeBackgroundColor = [UIColor colorWithHexString:@"0xfb673c"];
        self.badgeView.badgeTextFont = [UIFont systemFontOfSize:12];
        self.badgeView.badgePositionAdjustment = CGPointMake(-15, 15);
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.button.center = self.contentView.center;
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
            make.center.mas_equalTo(self.contentView);

        }];
        
    }
    return self;
}

- (HCMineButton *)button {
    if (!_button) {
        _button = [HCMineButton buttonWithType:UIButtonTypeSystem];
        UIImage * image = [[UIImage imageNamed:@"mine_icon_tqbj_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
        _button.enabled = NO;
        [_button setImage:image forState:UIControlStateNormal];
        [_button setTitle:@"我的投资" forState:UIControlStateNormal];
    }
    return _button;
}
- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.button alignment:JSBadgeViewAlignmentTopRight];
    }
    return _badgeView;
}
@end
