//
//  HCDiscoverMiddleCell.m
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCDiscoverMiddleCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <JSCategories/UIButton+ImageTitleStyle.h>
#import <SDWebImage/UIButton+WebCache.h>

@interface HCDiscoverButton : UIButton

@end

@implementation HCDiscoverButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat y = 5;
    return CGRectMake(contentRect.size.width*0.15, y, contentRect.size.width*0.7, contentRect.size.width*0.7);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat y = contentRect.size.height *0.7;
    return CGRectMake(0, y, contentRect.size.width, contentRect.size.height*0.2);
}

@end



@interface HCDiscoverMiddleCell ()
@property (nonatomic, strong) NSArray *buttonArray;

@end

@implementation HCDiscoverMiddleCell

- (void)setActivictyModels:(NSArray<HCActivityModel *> *)activictyModels {
    _activictyModels = activictyModels;
    if (activictyModels.count>0) {
        [self.buttonArray enumerateObjectsUsingBlock:^(UIButton * button, NSUInteger idx, BOOL * _Nonnull stop) {
            HCActivityModel * model = activictyModels[idx];
            [button sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] forState:UIControlStateNormal];
            [button setTitle:model.title forState:UIControlStateNormal];
        }];
    }
   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

        NSMutableArray * buttonArray = [NSMutableArray array];
        for (NSInteger i=0; i<4; i++) {
            HCDiscoverButton * button = [HCDiscoverButton buttonWithType:UIButtonTypeCustom];
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
            make.centerY.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(60, 70));
        }];
        self.buttonArray = buttonArray;
    

    }
    return self;
}
- (void)buttonClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(discoverMiddleCell:buttonClickAction:)]) {
        [self.delegate discoverMiddleCell:self buttonClickAction:button.tag-100];
    }
}


@end
