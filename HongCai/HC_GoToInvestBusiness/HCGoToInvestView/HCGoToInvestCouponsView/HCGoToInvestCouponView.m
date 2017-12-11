//
//  HCGoToInvestCouponsView.m
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGoToInvestCouponView.h"
#import "HCGoToInvestCouponCell.h"

#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+GoToInvestModule.h"
#import <Masonry/Masonry.h>
@interface HCGoToInvestCouponView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIButton * confirmButton;
@end

static NSString *const cellIdentifier = @"HCGoToInvestCouponCell";


@implementation HCGoToInvestCouponView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.topLine];
        [self addSubview:self.tableView];
        [self addSubview:self.confirmButton];
        [self layout_Masonry];        
    }
    return self;
}

- (void)layout_Masonry {
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton);
        make.centerX.mas_equalTo(self);
    }];
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(45.f);
        make.height.mas_equalTo(0.5);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLine.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)setCouponArray:(NSArray *)couponArray {
    _couponArray = couponArray;
    
    
    __block  NSInteger number = 0;
    
    [couponArray enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if (obj.minInvestAmount.integerValue <= self.investAmount.integerValue) {
            number +=1;
        };
    }];
    
    if (number>0) {
        self.confirmButton.hidden = NO;
    }else{
        self.confirmButton.hidden = YES;
    }
    [self.tableView reloadData];
}
#pragma -mark events

- (void)backButtonClick:(UIButton *)button {
    if (self.backButtonCallBack) {
        __block  HCGoToInvestCouponModel * model = nil;
        [self.couponArray enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.isSelected) {
                model = obj;
            }
        }];
        
        self.backButtonCallBack(model);
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat height = (CGRectGetWidth([UIScreen mainScreen].bounds) -40)*162.0/664.0+15.f;
    return height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.couponArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    HCGoToInvestCouponModel * model = self.couponArray[indexPath.row];
    if ([model.minInvestAmount integerValue] > [self.investAmount integerValue]) {
        return;
    }else{
        
        model.isSelected = !model.isSelected;
        [self.couponArray enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( obj == model) {
                if (model.isSelected) {
                    model.isSelected = YES;
                }
            }else{
                obj.isSelected = NO;
            }
        }];
        [self.tableView reloadData];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCGoToInvestCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    HCGoToInvestCouponModel * model = self.couponArray[indexPath.row];
    cell.investAmount = self.investAmount;
  
    cell.model = model;
    return cell;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 20)];
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[HCGoToInvestCouponCell class] forCellReuseIdentifier:cellIdentifier];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerLabel;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"优惠券";
    }
    return _titleLabel;
}
- (UIButton*)backButton {
    if (!_backButton){
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        UIImage * backGroundImage = [NSBundle goToInvest_ImageWithName:@"Registration_icon_return_Dark_nor"];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:backGroundImage forState:UIControlStateNormal];
    }
    return _backButton;
}
- (UIButton*)confirmButton {
    if (!_confirmButton){
        _confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_confirmButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
    }
    return _confirmButton;
}
- (UIView*)topLine {
    if (!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    }
    return _topLine;
}
- (UILabel *)headerLabel {
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 28)];
        _headerLabel.text = @"满足投资条件可使用";
        _headerLabel.font = [UIFont systemFontOfSize:12.f];
        _headerLabel.textAlignment = NSTextAlignmentCenter;
        [_headerLabel setTextColor:[UIColor colorWithHexString:@"0xff611d"]];
    }
    return _headerLabel;
}
@end
