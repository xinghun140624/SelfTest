//
//  HCAutoTenderNormalCell.m
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import "HCAutoTenderNormalCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "NSBundle+HCSettingModule.h"
#import "HCAutoTenderOptionProjectDayView.h"
#import "HCAutoTenderOptionEarningsView.h"
#import "HCAutoTenderOptionInvestTypeView.h"
#import <TYAlertController/TYAlertController.h>

NSString * const HCAutoTenderNormalCellFormNormalCell = @"HCAutoTenderNormalCellFormNormalCell";
NSString * const HCAutoTenderNormalCellFormNormalCellTagProjectDay = @"最高标的期限";
NSString * const HCAutoTenderNormalCellFormNormalCellTagEarning = @"最低期望收益";
NSString * const HCAutoTenderNormalCellFormNormalCellTagProjectType = @"标的类型";



@interface HCAutoTenderNormalCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView * line;
@end

@implementation HCAutoTenderNormalCell
+(void)load
{
    [XLFormViewController.cellClassesForRowDescriptorTypes setObject:[HCAutoTenderNormalCell class] forKey:HCAutoTenderNormalCellFormNormalCell];
}
- (void)configure {
    [super configure];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.contentView);
    }];

    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(self.contentView);
    }];
}
-(void)update {
    [super update];
    
    self.descLabel.textColor = [UIColor colorWithHexString:self.rowDescriptor.isDisabled?@"0x666666":@"0xff611d"];

    if ([self.rowDescriptor.tag isEqualToString:@"可用余额"]) {
        self.line.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
        [self.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
        self.descLabel.text = [NSString stringWithFormat:@"%@",self.rowDescriptor.value];
    }else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (self.rowDescriptor.value) {
            self.descLabel.text = self.rowDescriptor.value;
        }
    }
    self.titleLabel.text =self.rowDescriptor.tag;
}

- (void)formDescriptorCellDidSelectedWithFormController:(XLFormViewController *)controller {

    if ([self.rowDescriptor.tag isEqualToString:HCAutoTenderNormalCellFormNormalCellTagProjectDay]) {
        //最高标的期限;
        [self showOptionRowsWithType:0 controller:controller];
    }else if ([self.rowDescriptor.tag isEqualToString:HCAutoTenderNormalCellFormNormalCellTagEarning]) {
        [self showOptionRowsWithType:1 controller:controller];

    }else if ([self.rowDescriptor.tag isEqualToString:HCAutoTenderNormalCellFormNormalCellTagProjectType]) {
        [self showOptionRowsWithType:2 controller:controller];
        
    }

}

- (void)showOptionRowsWithType:(NSInteger )type controller:(XLFormViewController *)controller
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 250);
    __weak typeof(self) weakSelf = self;

    
    if (type==0) {
        //最高期限；
        HCAutoTenderOptionProjectDayView * view = [[HCAutoTenderOptionProjectDayView alloc] initWithFrame:frame];
        view.selectCallBack = ^(UIButton *button) {
        
            weakSelf.rowDescriptor.value = button.currentTitle;
            weakSelf.descLabel.text = weakSelf.rowDescriptor.value;
            
        };
        TYAlertController * alertVC = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleActionSheet];
        [controller presentViewController:alertVC animated:YES completion:NULL];
        
    }else if (type==1) {
    
        //最高期限；
        HCAutoTenderOptionEarningsView * view = [[HCAutoTenderOptionEarningsView alloc] initWithFrame:frame];
        
        view.selectCallBack = ^(UIButton *button) {
            weakSelf.rowDescriptor.value = button.currentTitle;
            weakSelf.descLabel.text = weakSelf.rowDescriptor.value;            
        };
        TYAlertController * alertVC = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleActionSheet];
        [controller presentViewController:alertVC animated:YES completion:NULL];
    
    }else if (type==2) {
        
        //最高期限；
        HCAutoTenderOptionInvestTypeView * view = [[HCAutoTenderOptionInvestTypeView alloc] initWithFrame:frame];
        
        view.selectCallBack = ^(UIButton *button) {
            
            weakSelf.rowDescriptor.value = button.currentTitle;
            weakSelf.descLabel.text = weakSelf.rowDescriptor.value;
        };
        TYAlertController * alertVC = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleActionSheet];
        [controller presentViewController:alertVC animated:YES completion:NULL];
        
    }




}
+ (CGFloat)formDescriptorCellHeightForRowDescriptor:(XLFormRowDescriptor *)rowDescriptor {
    return 50.f;
}

- (UIView *)line {
    if (!_line) {
        _line =[[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"0xefefef"];
    }
    return _line;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        _descLabel.font = [UIFont systemFontOfSize:15];
    }
    return _descLabel;
}

@end
