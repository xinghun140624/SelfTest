//
//  HCImmediatelyCellNormal.m
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCImmediatelyNormalCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
@interface HCImmediatelyNormalCell()
//标题
@property (nonatomic, strong) UILabel *titleLabel;
//本金
@property (nonatomic, strong) UILabel *descLabel;



@end
@implementation HCImmediatelyNormalCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        
        [self layout_Masonry];
        
    }
    return self;
}

-(void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.contentView);
        make.top.mas_equalTo(15.f);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
}


- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _titleLabel;
}
- (UILabel*)descLabel {
    if (!_descLabel){
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:15.f];
        _descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _descLabel;
}
@end
