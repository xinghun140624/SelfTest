//
//  HCSettingExitCell.m
//  Pods
//
//  Created by Candy on 2017/7/5.
//
//

#import "HCSettingExitCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
@interface HCSettingExitCell ()
@property (nonatomic, strong) UIButton *exitButton;

@end

@implementation HCSettingExitCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.exitButton];
        [self.exitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.contentView);
            make.height.mas_equalTo(50).priorityHigh();
        }];

        
    }
    return self;
}
- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _exitButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_exitButton setTitle:@"安全退出" forState:UIControlStateNormal];
        [_exitButton setTitleColor:[UIColor colorWithHexString:@"0xfc622d"] forState:UIControlStateNormal];
        [_exitButton setBackgroundColor:[UIColor whiteColor]];
        [_exitButton addTarget:self action:@selector(exitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exitButton;
}
- (void)exitButtonClick:(UIButton *)button {
    if (self.exitButtonClickCallBack) {
        self.exitButtonClickCallBack();
    }
}

@end
