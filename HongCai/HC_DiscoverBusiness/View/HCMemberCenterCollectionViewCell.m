//
//  HCMemberCenterCollectionViewCell.m
//  HongCai
//
//  Created by Candy on 2017/11/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberCenterCollectionViewCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+HCDiscoverModule.h"
@interface HCMemberCenterCollectionViewCell ()

@end


@implementation HCMemberCenterCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRGB:0x3da23];
        
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.backgroundShadowImageView];
        [self.contentView addSubview:self.memberDescLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.nextLevelDescLabel];
        [self.contentView addSubview:self.nextLevelIconImageView];
        [self.contentView addSubview:self.currentInvestLabel];
        self.nameLabel.center = self.center;
        [self.nameLabel sizeToFit];
    }
    return self;
}
- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.userInteractionEnabled = YES;
    }
    return _backgroundImageView;
}
- (UIImageView *)backgroundShadowImageView {
    if (!_backgroundShadowImageView) {
        _backgroundShadowImageView = [UIImageView new];
        _backgroundShadowImageView.image = [NSBundle discover_ImageWithName:@"memberHeaderShadow"];
    }
    return _backgroundShadowImageView;
}
- (UILabel *)memberDescLabel {
    if (!_memberDescLabel) {
        _memberDescLabel = [[UILabel alloc] init];
        _memberDescLabel.textColor = [UIColor whiteColor];
        _memberDescLabel.font = [UIFont systemFontOfSize:23];
    }
    return _memberDescLabel;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.text = [NSString stringWithFormat:@"%zd",arc4random()];
    }
    return _nameLabel;
}
- (UILabel *)nextLevelDescLabel {
    if (!_nextLevelDescLabel) {
        _nextLevelDescLabel = [[UILabel alloc] init];
        _nextLevelDescLabel.textColor = [UIColor whiteColor];
        _nextLevelDescLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nextLevelDescLabel;
}
- (UILabel *)currentInvestLabel {
    if (!_currentInvestLabel) {
        _currentInvestLabel = [[UILabel alloc] init];
        _currentInvestLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _currentInvestLabel.font = [UIFont systemFontOfSize:10];
    }
    return _currentInvestLabel;
}
@end
