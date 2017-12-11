//
//  HCDisvocerTopCell.m
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCDisvocerTopCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+HCDiscoverModule.h"
#import "HCUserMemberModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
@interface HCDisvocerTopUnLoginCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel * loginLabel;


@end

@implementation HCDisvocerTopUnLoginCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.loginLabel];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.size.mas_equalTo(CGSizeMake(50.f, 50.f));
        make.centerY.mas_equalTo(self.contentView);
    }];
    
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(20.f);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.centerY.mas_equalTo(self.iconView);
    }];

}

- (UIImageView*)iconView {
    if (!_iconView){
        _iconView = [[UIImageView alloc] initWithImage:[NSBundle discover_ImageWithName:@"img-wdl"]];
    }
    return _iconView;
}
- (UILabel*)loginLabel {
    if (!_loginLabel){
        _loginLabel = [[UILabel alloc] init];
        _loginLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
        _loginLabel.font = [UIFont systemFontOfSize:15.f];
        _loginLabel.textAlignment = NSTextAlignmentCenter;
        _loginLabel.text = @"登录／注册";
        _loginLabel.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        _loginLabel.layer.cornerRadius = 15.f;
        _loginLabel.layer.masksToBounds = YES;
    }
    return _loginLabel;
}
@end











@interface HCDisvocerTopLoginedCell()
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) UILabel * mobileLabel;
@property (nonatomic, strong) UILabel * memberDescLabel;
@property (nonatomic, strong) UILabel * memberCenterLabel;

@end
@implementation HCDisvocerTopLoginedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.mobileLabel];
        [self.contentView addSubview:self.memberDescLabel];
        [self.contentView addSubview:self.memberCenterLabel];
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(self.iconView.mas_width).multipliedBy(103.0/93.0);
        make.centerY.mas_equalTo(self.contentView);
    }];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView).mas_offset(5);
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(10.f);
    }];
    [self.memberDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.iconView).mas_offset(-5);
        make.left.mas_equalTo(self.mobileLabel);
    }];
    [self.memberCenterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 24));
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
- (void)setModel:(HCUserMemberModel *)model {
    _model = model;
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    self.mobileLabel.text = user[@"mobile"];
    self.memberDescLabel.text = model.name;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_zwf_nor"]];
}

- (UIImageView*)iconView {
    if (!_iconView){
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}
- (UILabel*)mobileLabel {
    if (!_mobileLabel){
        _mobileLabel = [[UILabel alloc] init];
        _mobileLabel.textColor = [UIColor colorWithHexString:@"0x444444"];
    }
    return _mobileLabel;
}

- (UILabel*)memberDescLabel {
    if (!_memberDescLabel){
        _memberDescLabel = [[UILabel alloc] init];
        _memberDescLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _memberDescLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _memberDescLabel;
}
- (UILabel*)memberCenterLabel {
    if (!_memberCenterLabel){
        _memberCenterLabel = [[UILabel alloc] init];
        _memberCenterLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
        _memberCenterLabel.font = [UIFont systemFontOfSize:15.f];
        _memberCenterLabel.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        _memberCenterLabel.layer.cornerRadius = 12;
        _memberCenterLabel.layer.masksToBounds = YES;
        _memberCenterLabel.text = @"会员中心";
        _memberCenterLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _memberCenterLabel;
}
@end
