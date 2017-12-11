//
//  HCMyAssetsPiedCell.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyAssetsPiedCell.h"
#import "SCChart.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
@interface HCMyAssetsPiedCell ()
@property (nonatomic, strong) SCPieChart *chartView;
@property (nonatomic, strong) UILabel * statusLabel;
@end

@implementation HCMyAssetsPiedCell

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
        label.text = @"总资产(元)";
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
    self.statusLabel.text = [NSString stringWithFormat:@"%.2f",[model.totalAssets doubleValue]];

    NSArray * array = @[[model.waitingCapital decimalNumberByAdding:model.freezeCapital],model.waitingProfit,model.balance];

    [self.chartView updateChartByNumbers:array];

}


- (SCPieChart *)chartView {
    if (!_chartView) {
        NSArray *items = @[[SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"0x478bc5"] description:@"A"],
                           [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"0x3a6cab"] description:@"B"],
                           [SCPieChartDataItem dataItemWithValue:0 color:[UIColor colorWithHexString:@"0x7abff3"] description:@"C"],
                           ];
        _chartView = [[SCPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)*0.5, 40, 180, 180) items:items];
        _chartView.descriptionTextColor = [UIColor clearColor];
    }
    return _chartView;
}
@end
