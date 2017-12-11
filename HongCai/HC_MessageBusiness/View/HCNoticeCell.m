//
//  HCNoticeCell.m
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCNoticeCell.h"
#import "HCNetworkConfig.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCNoticeModel.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCTimeTool.h"
@interface HCNoticeCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *detailButton;

@end

@implementation HCNoticeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.detailButton];
        [self layout_Masonry];
    }
    return self;
}

- (void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f);
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(-20.f);
    }];
    [self.detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.timeLabel);
    }];
}
- (void)setModel:(HCNoticeModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[HCTimeTool getDateWithTimeInterval:model.createTime andTimeFormatter:@"yyyy-MM-dd"]];
    
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

- (void)detailButtonClick {
    HCNoticeModel * model = self.model;
    NSString * url = [NSString stringWithFormat:@"%@user-center/messages/%@",WebBaseURL,model.noticeId];
    UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
    [[self getCurrentViewController].navigationController pushViewController:controller animated:YES];

    
}
- (UIButton *)detailButton {
    if (!_detailButton) {
        _detailButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _detailButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_detailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:[UIColor colorWithHexString:@"0x999999"] forState:UIControlStateNormal];
        [_detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _detailButton;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _timeLabel.font = [UIFont systemFontOfSize:13];
    }
    return _timeLabel;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0 ;
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}
@end
