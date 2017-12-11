//
//  HCBankManagerAddCell.m
//  Pods
//
//  Created by Candy on 2017/7/11.
//
//

#import "HCBankManagerAddCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>

#import "NSBundle+HCSettingModule.h"



@interface HCBankManagerAddButton : UIButton

@end


@implementation HCBankManagerAddButton

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat y = 5;
    return CGRectMake(contentRect.size.width*0.25, y, contentRect.size.width*0.5, contentRect.size.width*0.5);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGFloat y = contentRect.size.height *0.85;
    return CGRectMake(0, y, contentRect.size.width, contentRect.size.height*0.15);
}

@end






@interface HCBankManagerAddCell ()
@property (nonatomic, strong) HCBankManagerAddButton *addBankButton;

@end

@implementation HCBankManagerAddCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.addBankButton];
        [self.addBankButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(80, 70));
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        
        
    }
    return self;
}
- (HCBankManagerAddButton *)addBankButton {
    if (!_addBankButton) {
        _addBankButton = [HCBankManagerAddButton buttonWithType:UIButtonTypeSystem];
        _addBankButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addBankButton setTitle:@"添加银行卡" forState:UIControlStateNormal];
        [_addBankButton setTitleColor:[UIColor colorWithHexString:@"0xfc622d"] forState:UIControlStateNormal];
        [_addBankButton setImage:[NSBundle setting_ImageWithName:@"yhkgl_icon_tjyhk_nor"] forState:UIControlStateNormal];
        
        [_addBankButton addTarget:self action:@selector(addBankButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBankButton;
}
- (void)addBankButtonClick:(UIButton *)button {
    if (self.addBankCallBack) {
        self.addBankCallBack();
    }
}
@end
