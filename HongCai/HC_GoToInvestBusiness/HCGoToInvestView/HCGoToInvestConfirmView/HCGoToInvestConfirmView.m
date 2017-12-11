//
//  HCInvestmentConfirmView.m
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGoToInvestConfirmView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "NSBundle+GoToInvestModule.h"
#import <Masonry/Masonry.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCNetworkConfig.h"
@interface HCInvestConfirmViewCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation HCInvestConfirmViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];

        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20.f);
            make.centerY.mas_equalTo(self.contentView);
        }];

    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
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

@interface HCGoToInvestConfirmView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HCGoToInvestConfirmHeaderView *headerView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) HCGoToInvestCouponModel * selectedCouponModel;
@end

static NSString * const investConfirmCellIdentifier = @"investConfirmCellIdentifier";


@implementation HCGoToInvestConfirmView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backButton];
        [self addSubview:self.titleLabel];
        [self addSubview:self.topLine];
        [self addSubview:self.tableView];
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
- (void)setInvestmentAmount:(NSNumber *)investmentAmount {
    _investmentAmount = investmentAmount;
   
    if ([investmentAmount integerValue] > [self.userBalance integerValue]) {
        
        CGFloat myHeight = CGRectGetHeight([UIScreen mainScreen].bounds)==812?34:0;
        
        self.footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.frame)-CGRectGetMaxY(self.tableView.tableHeaderView.frame)-45*5-myHeight);
        self.tableView.tableFooterView = self.footerView;
    }else{
        CGFloat myHeight = CGRectGetHeight([UIScreen mainScreen].bounds)==812?34:0;
        self.footerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.frame)-CGRectGetMaxY(self.tableView.tableHeaderView.frame)-45*4-myHeight);
        self.tableView.tableFooterView = self.footerView;
    }

    self.descLabel.hidden = !self.isPartake;
    [self.tableView reloadData];
}
- (void)setUserBalance:(NSNumber *)userBalance {
    _userBalance = userBalance;
    [self.tableView reloadData];
}

#pragma -mark events

- (void)backButtonClick:(UIButton *)button {
    if (self.backButtonCallBack) {
        self.backButtonCallBack();
    }
}
//确认投资
- (void)confirmButtonClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoInvestConfirmViewInvestButtonClick:)]) {
        [self.delegate gotoInvestConfirmViewInvestButtonClick:button];
    }
}
- (void)protocolClick {
    NSString * url = nil;
    if (self.isPartake) {
        //降息换物
          url = [NSString stringWithFormat:@"%@service-agree/%@/0?creditNum=0",WebBaseURL,self.projectNumber];
    }else{
          url = [NSString stringWithFormat:@"%@service-agree/%@/0",WebBaseURL,self.projectNumber];
    }
    UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url,HCWebBusinessNavigationType:@(2)}];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [[self getCurrentViewController] presentViewController:nav animated:YES completion:NULL];

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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([self.investmentAmount integerValue]>[self.userBalance integerValue]) {
        //投资金额大于用户余额
        [self.confirmButton setTitle:@"去充值并投资" forState:UIControlStateNormal];
        return 4;
    }
    [self.confirmButton setTitle:@"立即投资" forState:UIControlStateNormal];
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCInvestConfirmViewCell * cell = [tableView dequeueReusableCellWithIdentifier:investConfirmCellIdentifier];
    
    
        if (indexPath.row==0) {
            cell.titleLabel.text = self.isPartake?@"特权奖励":@"优惠券";
            if (self.isPartake) {
                cell.descLabel.text = self.specailInvestDesc;
            }else{
                if (self.couponArray.count>0) {
                    
                    __block NSInteger number = 0;
                    __block  HCGoToInvestCouponModel * model  = nil;
                    [self.couponArray enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.isSelected) {
                            model = obj;
                            self.selectedCouponModel = model;
                        }
                        if ([self.investmentAmount integerValue] >= [[obj valueForKey:@"minInvestAmount"] integerValue]) {
                            number +=1;
                        }
                    }];
                    
                    if (model) {
                        if ([model.type integerValue]==1) {
                            //加息；
                            cell.descLabel.text = [NSString stringWithFormat:@"%@%%加息券",model.value];
                            
                        }else{
                            cell.descLabel.text = [NSString stringWithFormat:@"%@元现金券",model.value];
                        }
                        
                    }else{
                        if (number>0) {
                            cell.descLabel.text = [NSString stringWithFormat:@"有%zd张优惠券可用",number];
                        }else{
                            cell.descLabel.text = [NSString stringWithFormat:@"暂无可用优惠券"];
                        }
                        
                    }
                    [cell.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(0);
                    }];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.descLabel.text = @"暂无优惠券";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }

            
            }
            
            
        }else if (indexPath.row==1){
            if ([self.userBalance integerValue]<[self.investmentAmount integerValue]) {
                cell.titleLabel.text = @"预计收益";
                
                if (self.couponArray.count>0) {
                    __block  HCGoToInvestCouponModel * model  = nil;
                    [self.couponArray enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.isSelected) {
                            model = obj;
                            self.selectedCouponModel = model;
                        }
                    }];
                    
                    if (model) {
                        cell.descLabel.text =  [self calculateEarningWithType:[model.type integerValue] value:model.value];
                    }else{
                        NSDecimalNumber * investNumber = [NSDecimalNumber decimalNumberWithString:self.investmentAmount.stringValue];
                        NSDecimalNumber * projectDaysNumber = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
                        
                        NSDecimalNumber * earning = [self caculateEarningsWithInvestAmount:investNumber projectDays:projectDaysNumber annualEarning:self.annualEarnings];
                        cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",earning.doubleValue];
                    }
                }else {
                    if (self.investmentAmount!=nil) {
                        NSDecimalNumber * investNumber = [NSDecimalNumber decimalNumberWithString:self.investmentAmount.stringValue];
                        NSDecimalNumber * projectDaysNumber = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
                        
                        NSDecimalNumber * earning = [self caculateEarningsWithInvestAmount:investNumber projectDays:projectDaysNumber annualEarning:self.annualEarnings];
                        cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",earning.doubleValue];
                    }
                   
                }
                
                [cell.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.centerY.mas_equalTo(cell.contentView);
                    
                }];
                
            }else{
                cell.titleLabel.text = @"账户余额";
                cell.descLabel.text = [NSString stringWithFormat:@"%.2f",[self.userBalance doubleValue]];
                [cell.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.centerY.mas_equalTo(cell.contentView);
                }];
            }
            
            
        }else if(indexPath.row == 2) {
            
            
            if ([self.userBalance integerValue]<[self.investmentAmount integerValue]) {
                cell.titleLabel.text = @"余额支付";
                cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.userBalance doubleValue]];
                cell.accessoryType = UITableViewCellAccessoryNone;
                [cell.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.centerY.mas_equalTo(cell.contentView);
                    
                }];
                
            }else{
                cell.titleLabel.text = @"预计收益";
                
                
                if (self.couponArray.count>0) {
                    __block  HCGoToInvestCouponModel * model  = nil;
                    [self.couponArray enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (obj.isSelected) {
                            model = obj;
                        }
                    }];
                    
                    if (model) {
                        cell.descLabel.text = [self calculateEarningWithType:[model.type integerValue] value:model.value];
                    }else{
                        NSDecimalNumber * investNumber = [NSDecimalNumber decimalNumberWithString:self.investmentAmount.stringValue];
                        NSDecimalNumber * projectDaysNumber = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
                        NSDecimalNumber * earning = [self caculateEarningsWithInvestAmount:investNumber projectDays:projectDaysNumber annualEarning:self.annualEarnings];
                        cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",earning.doubleValue];
                    }
                }else {
                    if (self.investmentAmount!=nil) {
                        NSDecimalNumber * investNumber = [NSDecimalNumber decimalNumberWithString:self.investmentAmount.stringValue];
                        NSDecimalNumber * projectDaysNumber = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
                        NSDecimalNumber * earning = [self caculateEarningsWithInvestAmount:investNumber projectDays:projectDaysNumber annualEarning:self.annualEarnings];
                        cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",earning.doubleValue];
                    }
                }
                
                [cell.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.centerY.mas_equalTo(cell.contentView);
                    
                }];
                
            }
            
        }else if (indexPath.row==3){
            cell.titleLabel.text = @"还需支付";
            if (self.investmentAmount && self.userBalance) {
                //还需支付 = 投资金额 - 用户余额
                NSDecimalNumber * amount = [[NSDecimalNumber decimalNumberWithString:self.investmentAmount.stringValue] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.userBalance.stringValue]];
                cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",amount.doubleValue];
                [cell.descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-20);
                    make.centerY.mas_equalTo(cell.contentView);
                }];
            }
        }

    return cell;
}

//根据类型来计算收益
- (NSString *)calculateEarningWithType:(NSInteger )type value:(NSDecimalNumber *)value {

    NSDecimalNumber * investNumber = [NSDecimalNumber decimalNumberWithString:self.investmentAmount.stringValue];
    NSDecimalNumber * projectNumber = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
    
    NSDecimalNumber * earnings = [self caculateEarningsWithInvestAmount:investNumber projectDays:projectNumber annualEarning:self.annualEarnings];
    if (type==1) {
        //加息；
        NSDecimalNumber * rateProjectDays = nil;
        if (self.selectedCouponModel.duration.integerValue >0) {
            rateProjectDays = [NSDecimalNumber decimalNumberWithString:self.selectedCouponModel.duration.stringValue];
        }else{
            rateProjectDays = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
        }
        
        
        NSDecimalNumber * jiaxiEarnings = [self caculateEarningsWithInvestAmount:investNumber projectDays:rateProjectDays annualEarning:value];
        return [NSString stringWithFormat:@"%.2f+%.2f元",earnings.doubleValue,jiaxiEarnings.doubleValue];
    }else{
        return [NSString stringWithFormat:@"%.2f+%.2f元",earnings.doubleValue,value.doubleValue];

    }
}
//计算收益
- (NSDecimalNumber *)caculateEarningsWithInvestAmount:(NSDecimalNumber *)investAmount projectDays:(NSDecimalNumber *)projectDays annualEarning:(NSDecimalNumber *)annualEarning {
    NSDecimalNumber * daysOfOneYear = [NSDecimalNumber decimalNumberWithString:@"36500"];
    NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    
    return [[[investAmount decimalNumberByMultiplyingBy:annualEarning] decimalNumberByMultiplyingBy:projectDays] decimalNumberByDividingBy:daysOfOneYear withBehavior:handler];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isPartake||self.couponArray.count==0) {
        return;
    }
    if (indexPath.row==0) {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (self.couponsCellSelectCallBack) {
            self.couponsCellSelectCallBack(cell);
        }
    }
}

- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"投资确认";
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
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView =self.footerView ;
        [_tableView registerClass:[HCInvestConfirmViewCell class] forCellReuseIdentifier:investConfirmCellIdentifier];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = self.headerView;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _tableView.separatorColor = [UIColor colorWithHexString:@"0xeeeeee"];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (HCGoToInvestConfirmHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HCGoToInvestConfirmHeaderView alloc] initWithFrame:CGRectMake(0, 0,CGRectGetWidth([UIScreen mainScreen].bounds), 70.f)];
    }
    return _headerView;
}

- (UIView*)topLine {
    if (!_topLine){
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    }
    return _topLine;
}


- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 800)];
        
        UIView * topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        topLine.frame = CGRectMake(15, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-30, 0.5);
        [_footerView addSubview:topLine];

        self.descLabel = [[UILabel alloc] init];
        self.descLabel.font = [UIFont systemFontOfSize:11];
        self.descLabel.text = @"友情提示：您该笔投资不可进行债权转让操作";
        self.descLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        self.descLabel.hidden = YES;
        [_footerView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.centerX.mas_equalTo(_footerView);
        }];
        
        UIButton * protocolButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSMutableAttributedString *agreeText = [[NSMutableAttributedString alloc] initWithString:@"同意"];
        [agreeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, agreeText.string.length)];
        [agreeText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x666666"] range:NSMakeRange(0, agreeText.string.length)];
        
        NSMutableAttributedString *protocolText = [[NSMutableAttributedString alloc] initWithString:@"《宏财网服务协议》" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        [protocolText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x006cff"] range:NSMakeRange(0, protocolText.string.length)];
        [agreeText appendAttributedString:protocolText];
        [protocolButton addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
        [protocolButton setAttributedTitle:agreeText forState:UIControlStateNormal];
        [_footerView addSubview:protocolButton];

        UILabel * descLabel = [[UILabel alloc] init];
        descLabel.text = @" 您的投资受电子合同法律保护";
        descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        descLabel.font = [UIFont systemFontOfSize:11];
        
        [_footerView addSubview:descLabel];
        self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        self.confirmButton.backgroundColor = [UIColor colorWithHexString:@"0xFA4918"];
        [self.confirmButton setTintColor:[UIColor whiteColor]];
        self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [self.confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:self.confirmButton];

        
        [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        CGSize size = [descLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        
        [protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.confirmButton.mas_top).mas_offset(-25);
            make.centerX.mas_equalTo(_footerView).mas_offset(-ceilf(size.width*0.5));
        }];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(protocolButton.mas_right);
            make.centerY.mas_equalTo(protocolButton).mas_offset(0);
        }];
    }
    return _footerView;
}

@end
