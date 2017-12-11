//
//  HCProjectDetailRemindinvView.m
//  JSToastBusiness
//
//  Created by 郭金山 on 2017/10/20.
//  Copyright © 2017年 Candy. All rights reserved.
//

#import "HCProjectDetailRemindingView.h"
#import <Masonry/Masonry.h>
#import "NSBundle+JSToastBusiness.h"


@interface HCProjectDetailRemindingView ()


@end

@implementation HCProjectDetailRemindingView

- (CGSize)intrinsicContentSize {
    return [UIScreen mainScreen].bounds.size;
}
- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

        UIImageView * descImageView = [[UIImageView alloc] init];
        descImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"projectDetails_desc"];
        [self addSubview:descImageView];
        
        [descImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(-60);
        }];
 
        UIImageView * arrowImageView = [[UIImageView alloc] init];
        arrowImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"icon_arrow_top"];
        [self addSubview:arrowImageView];
        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(descImageView.mas_top).mas_offset(-15);
            make.centerX.mas_equalTo(descImageView.mas_centerX).mas_offset(-15);
        }];
        
        UIImageView * handImageView = [[UIImageView alloc] init];
        handImageView.image = [NSBundle jSToastBusiness_ImageWithName:@"icon_hand"];
        [self addSubview:handImageView];
        
        [handImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(arrowImageView.mas_right).mas_offset(10);
            make.bottom.mas_equalTo(arrowImageView.mas_bottom);
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

