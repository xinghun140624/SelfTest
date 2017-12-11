//
//  HCGoToTransferConfirmView.m
//  Pods
//
//  Created by Candy on 2017/7/7.
//
//

#import "HCGoToTransferConfirmView.h"
#import "NSBundle+GoToInvestModule.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <AMPopTip/AMPopTip.h>
#import "HCNetworkConfig.h"
@interface HCGotoTransferConfirmCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation HCGotoTransferConfirmCell

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

@interface HCGoToTransferConfirmView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) HCGoToInvestConfirmHeaderView *headerView;
@property (nonatomic, strong) UIImageView *helpView;
@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) AMPopTip * popTip;
@end
static NSString * const gotoTransferCellIdentifier = @"HCGotoTransferConfirmCell";

@implementation HCGoToTransferConfirmView

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
- (void)setPayMoney:(NSString *)payMoney {
    _payMoney =payMoney;
    self.statusLabel.text = [NSString stringWithFormat:@"您需要实际支付%@元",self.payMoney];
    NSString * desc = [self getDescStrings];
    self.helpView.hidden = desc.length==0;
    if (desc.length>0) {
        [self.popTip showText:desc direction:AMPopTipDirectionDown maxWidth:(CGRectGetWidth([UIScreen mainScreen].bounds)-60) inView:self.helpView fromFrame:self.helpView.bounds];
    }
    self.headerView.moneyNumber = self.investAmount;
}
//计算待收未收利息
- (NSDecimalNumber *)caculateUnReceiveProfit{
    
    //转让奖金
    NSDecimalNumber * transferMoney = [self caculateTransferMoneyWithInvestAmount:self.investAmount isRound:NO];
    
    NSDecimalNumber * payMoney = [NSDecimalNumber decimalNumberWithString:self.payMoney];
     NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * result = [[payMoney decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.investAmount.stringValue]] decimalNumberByAdding:transferMoney withBehavior:handler];
    return result;
}

//计算当前转让奖金
- (NSDecimalNumber *)caculateTransferMoneyWithInvestAmount:(NSNumber *)investAmount isRound:(BOOL)isRound{
        //当前认购的利率
    NSDecimalNumber * annualEarnings = [NSDecimalNumber decimalNumberWithString:self.annualEarnings.stringValue];
    NSDecimalNumber * originalAnnualEarnings = [NSDecimalNumber decimalNumberWithString:self.originalAnnualEarnings.stringValue];

    NSDecimalNumber * resultOriginalAnnualEarnings = [annualEarnings decimalNumberBySubtracting:originalAnnualEarnings];
    
    if ([resultOriginalAnnualEarnings compare:@(0)]==NSOrderedSame) {
        return [NSDecimalNumber zero];
    }
    NSDecimalNumber * projectDays = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
    
    NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *result = [[[[NSDecimalNumber decimalNumberWithString:investAmount.stringValue] decimalNumberByMultiplyingBy:resultOriginalAnnualEarnings] decimalNumberByMultiplyingBy:projectDays] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:@"36500"] withBehavior:isRound?handler:[NSDecimalNumberHandler defaultDecimalNumberHandler]];
    return result;
}

- (void)setShouyiAmount:(NSNumber *)shouyiAmount {
    _shouyiAmount = shouyiAmount;
    [self.tableView reloadData];
}
- (void)setUserBalance:(NSNumber *)userBalance {
    _userBalance = userBalance;
    [self.tableView reloadData];
}
- (void)backButtonClick:(UIButton *)button {
    if (self.backButtonCallBack) {
        self.backButtonCallBack();
    }
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
- (void)protocolClick {
    NSString * url = [NSString stringWithFormat:@"%@assignment-agree",WebBaseURL];
    UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url,HCWebBusinessNavigationType:@(2)}];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [[self getCurrentViewController] presentViewController:nav animated:YES completion:NULL];
    
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCGotoTransferConfirmCell * cell = [tableView dequeueReusableCellWithIdentifier:gotoTransferCellIdentifier];
    if (indexPath.row==0) {
        cell.titleLabel.text = @"账户余额";
        cell.descLabel.text = [NSString stringWithFormat:@"%.2f",[self.userBalance doubleValue]];
        
        
    }else if (indexPath.row==1){
        cell.titleLabel.text = @"预计收益";
        cell.descLabel.text =[NSString stringWithFormat:@"%.2f",[self.shouyiAmount doubleValue]] ;
        
    }
    return cell;
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
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerClass:[HCGotoTransferConfirmCell class] forCellReuseIdentifier:gotoTransferCellIdentifier];
        _tableView.backgroundColor = [UIColor whiteColor];
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
        CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds)==812?214+40:214;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
        
        UIView * topLine = [[UIView alloc] init];
        topLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
        topLine.frame = CGRectMake(15, 0, CGRectGetWidth([UIScreen mainScreen].bounds)-30, 0.5);
        
        [_footerView addSubview:topLine];
        
        UILabel * statusLabel = [[UILabel alloc] init];
        statusLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
        statusLabel.font = [UIFont systemFontOfSize:13.f];
        self.statusLabel = statusLabel;
        [_footerView addSubview:statusLabel];
        
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25.f);
            make.centerX.mas_equalTo(_footerView);
        }];
        
        
        UIImageView * helpImage = [[UIImageView alloc] initWithImage:[NSBundle goToInvest_ImageWithName:@"wdyhq_icon_wh_nor"]];
        [_footerView addSubview:helpImage];
        self.helpView = helpImage;
        [helpImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(statusLabel);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        
        UILabel * descLabel = [[UILabel alloc] init];
        descLabel.text = @" 您的投资受电子合同法律保护";
        descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        descLabel.font = [UIFont systemFontOfSize:11];
        
        [_footerView addSubview:descLabel];
        
        UIButton * protocolButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSMutableAttributedString *agreeText = [[NSMutableAttributedString alloc] initWithString:@"同意"];
        [agreeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, agreeText.string.length)];
        [agreeText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x666666"] range:NSMakeRange(0, agreeText.string.length)];
        
        NSMutableAttributedString *protocolText = [[NSMutableAttributedString alloc] initWithString:@"《债权转让服务协议》" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}];
        [protocolText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x006cff"] range:NSMakeRange(0, protocolText.string.length)];
        
        
        
        [agreeText appendAttributedString:protocolText];
        [protocolButton addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
        
        [protocolButton setAttributedTitle:agreeText forState:UIControlStateNormal];
        
        
        [_footerView addSubview:protocolButton];
        
        
        
        UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmButton.backgroundColor = [UIColor colorWithHexString:@"0xFA4918"];
        [confirmButton setTintColor:[UIColor whiteColor]];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmButton setTitle:@"立即认购" forState:UIControlStateNormal];
        [confirmButton setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:confirmButton];
        
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(1);
            make.height.mas_equalTo(48);
        }];
        CGSize size = [descLabel.text sizeWithAttributes:@{NSFontAttributeName:descLabel.font}];
        
        [protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_footerView).mas_offset(-ceilf(size.width*0.5));
            make.bottom.mas_equalTo(confirmButton.mas_top).mas_offset(-20);
        }];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(protocolButton);
            make.left.mas_equalTo(protocolButton.mas_right);
        }];
        
        
    }
    return _footerView;
}

- (NSString *)getDescStrings {
    
    NSDecimalNumber * unReceiveProfit = [self caculateUnReceiveProfit];
    
    int days = [self caculateUnReceiveProfitDaysWithInvestAmount:[NSDecimalNumber decimalNumberWithString:self.investAmount.stringValue] unReceiveProfit:unReceiveProfit];
    NSString * text = nil;
    
    
    if ([[self caculateTransferMoneyWithInvestAmount:self.investAmount isRound:NO] isEqualToNumber:@(0)]) {
        
        if ([unReceiveProfit compare:@(0)]==NSOrderedDescending) {
            text = [NSString stringWithFormat:@"您需先行垫付该笔债权当期已产生收益%.2f元，这部分资金会在下个还款日归还给您。",unReceiveProfit.doubleValue];
        }else if ([unReceiveProfit compare:@(0)]==NSOrderedAscending) {
            text = [NSString stringWithFormat:@"您提前获得该笔债权%d天收益%.2f元，实际支付扣减该部分金额",days,fabs(unReceiveProfit.doubleValue)];
        }
        return text;
        
    }
    NSDecimalNumber * transferMoney = [self caculateTransferMoneyWithInvestAmount:self.investAmount isRound:YES];

    switch ([unReceiveProfit compare:@(0)]) {
        case NSOrderedSame:
        {
            text = [NSString stringWithFormat:@"您获得转让奖金%.2f元，实际支付金额扣减该部分资金。",transferMoney.doubleValue];
        }
            break;
        case NSOrderedDescending:
        {
            text = [NSString stringWithFormat:@"您需先行垫付该笔债权当期已产生收益%.2f元，这部分资金会在下个还款日归还给您。您获得转让奖金%.2f元，实际支付金额扣减该部分资金。",unReceiveProfit.doubleValue,transferMoney.doubleValue];
        
        }
            break;
        case NSOrderedAscending:
        {
        
        text = [NSString stringWithFormat:@"您提前获得该笔债权%d天收益%.2f元，实际支付扣减该部分金额。您获得转让奖金%.2f元，实际支付金额扣减该部分资金。",days,fabs(unReceiveProfit.doubleValue),transferMoney.doubleValue];
        }
        default:
            break;
    }
    return text;
}
- (int)caculateUnReceiveProfitDaysWithInvestAmount:(NSDecimalNumber *)investAmont unReceiveProfit:(NSDecimalNumber *)unReceiveProfit {
    
    NSDecimalNumberHandler * handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber * days =  [[[unReceiveProfit decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"36500"]] decimalNumberByDividingBy:investAmont withBehavior:handler] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:self.originalAnnualEarnings.stringValue] withBehavior:handler];
    return (int)(fabs(round(days.doubleValue)));
    
}
- (AMPopTip *)popTip {
    if (!_popTip) {
        _popTip = [AMPopTip popTip];
        _popTip.popoverColor = [UIColor whiteColor];
        _popTip.borderWidth = 0.5f;
        _popTip.borderColor = [UIColor colorWithHexString:@"0x999999"];
        _popTip.textColor = [UIColor colorWithHexString:@"0x999999"];
        _popTip.offset = 3;
        _popTip.font = [UIFont systemFontOfSize:12];
        _popTip.textAlignment = NSTextAlignmentLeft;
        _popTip.entranceAnimation = AMPopTipEntranceAnimationNone;
    }
    return _popTip;
}
- (void)confirmButtonClick:(UIButton *)button {
    if (self.confirmButtonCallBack) {
        self.confirmButtonCallBack();
    }
}
- (void)layoutSubviews {
    
    [super layoutSubviews];
}
@end
