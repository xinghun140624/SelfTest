//
//  HCDiscoverActivityCell.m
//  HongCai
//
//  Created by Candy on 2017/6/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCDiscoverActivityCell.h"
#import <Masonry/Masonry.h>
#import "HCActivityModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HCDiscoverActivityCell ()
@property (nonatomic, strong) UIImageView *activityImageView;

@end

@implementation HCDiscoverActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.activityImageView];
        [self.activityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15.f);
            make.left.mas_equalTo(15.f);
            make.right.mas_equalTo(-15.f);
            make.height.mas_equalTo(self.activityImageView.mas_width).multipliedBy(250.0/670.0);
        }];
    }
    return self;
}

- (void)setActivityModel:(HCActivityModel *)activityModel {
    _activityModel = activityModel;
    [self.activityImageView sd_setImageWithURL:[NSURL URLWithString:activityModel.imageUrl] placeholderImage:[UIImage imageNamed:@"logo_zwf_nor"]];
}

- (UIImageView*)activityImageView {
    if (!_activityImageView){
        _activityImageView = [[UIImageView alloc] init];
        _activityImageView.layer.cornerRadius = 10.f;
        _activityImageView.layer.masksToBounds = YES;
        _activityImageView.userInteractionEnabled = YES;
        _activityImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _activityImageView;
}
@end
