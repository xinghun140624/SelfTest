//
//  HCMyAssetsShouYiCell.m
//  HongCai
//
//  Created by Candy on 2017/7/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyAssetsShouYiCell.h"

#import "SCChart.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
@interface HCMyAssetsShouYiCell ()
@property (nonatomic, strong) SCPieChart *chartView;
@property (nonatomic, strong) UILabel * statusLabel;
@end

@implementation HCMyAssetsShouYiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.contentView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self.contentView addSubview:self.chartView];
        
        [self.chartView addSubview:self.statusLabel];
        [self.chartView bringSubviewToFront:self.statusLabel];
        [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.chartView);
        }];
        
        UILabel * label = [[UILabel alloc] init];
        label.text = @"已收收益(元)";
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithHexString:@"0xff611d"];
        [self.chartView addSubview:label];
        [self.chartView bringSubviewToFront:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.chartView);
            make.bottom.mas_equalTo(self.statusLabel.mas_top).mas_equalTo(-3);
        }];
        
    }
    return self;
}
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:20.f];
        _statusLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
    return _statusLabel;
}
- (void)setModel:(HCAccountModel *)model {
    _model = model;
    
    double decimail = [self.model.receivedProfit doubleValue]-[self.model.activityProfit doubleValue];
    double  investProfit = decimail - [self.tequanShouyiProfit doubleValue];
    
    self.statusLabel.text = [NSString stringWithFormat:@"%.2f",[model.receivedProfit doubleValue]];
     NSArray * array = @[@(investProfit),self.tequanShouyiProfit,self.model.activityProfit];
    if ([model.receivedProfit compare:@(0)]==NSOrderedSame &&[model.activityProfit compare:@(0)]==NSOrderedSame && [self.tequanShouyiProfit compare:@(0)] == NSOrderedSame) {
        [self.chartView updateChartByNumbers:@[@30,@30,@30]];
    }else{
        [self.chartView updateChartByNumbers:array];
    }
    
}


- (SCPieChart *)chartView {
    if (!_chartView) {
        NSArray *items = @[[SCPieChartDataItem dataItemWithValue:30 color:[UIColor colorWithHexString:@"0xf2784d"] description:@"A"],
                           [SCPieChartDataItem dataItemWithValue:30 color:[UIColor colorWithHexString:@"0xf4d03f"] description:@"B"],
                           [SCPieChartDataItem dataItemWithValue:30 color:[UIColor colorWithHexString:@"0xf5b34f"] description:@"C"],
                           ];
        _chartView = [[SCPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)*0.5, 40, 180, 180) items:items];
        _chartView.descriptionTextColor = [UIColor clearColor];
    }
    return _chartView;
}
@end
