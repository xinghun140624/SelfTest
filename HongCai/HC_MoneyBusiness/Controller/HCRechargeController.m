//
//  HCRechargeController.m
//  HongCai
//
//  Created by Candy on 2017/6/13.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCRechargeController.h"
#import "HCRechargeCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCUserBankCardModel.h"
#import "NSBundle+HCMoneyModule.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCMoneyService.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
@interface HCRechargeController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) NSNumber * userBalance;
@property (nonatomic, strong) HCUserBankCardModel * bankModel;
@property (nonatomic, strong) UITextField * inputTextField;
@property (nonatomic, strong) UIButton * rechargeButton;
@property (nonatomic, strong) NSDictionary * successLimitParam;
@property (nonatomic, strong) UILabel * statusLabel;
@end
static NSString * const cellIdentifier1 = @"HCRechargeCellIdentifer1";
static NSString * const cellIdentifier2 = @"HCRechargeCellIdentifer2";
static NSString * const cellIdentifier3 = @"HCRechargeCellIdentifer3";

@implementation HCRechargeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"充值" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    
    
    
    
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [HCMoneyService getRechargeData:^(NSDecimalNumber *balance, HCUserBankCardModel *model, NSDictionary *bankLimitData) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.userBalance = balance;
        self.bankModel = model;
        self.successLimitParam = bankLimitData;
        [self.tableView reloadData];
        
    } errorMessage:^(NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL isHaveDian = NO;
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            return NO;
        }
        
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
        
    }
    return YES;
}

- (void)rechargeButtonClick {
    if ([self.inputTextField.text integerValue]<3) {
        [MBProgressHUD showText:@"最低充值金额：3元"];
        return;
    }
    
    if ([self.inputTextField.text doubleValue] -[self.successLimitParam[@"singleRemain"] doubleValue] > 0.00001) {
        NSString * message = self.inputTextField.attributedPlaceholder.string;
        
        [MBProgressHUD showText:message];
        return;
    }
    if ([self.inputTextField isFirstResponder]) {
        [self.inputTextField resignFirstResponder];
    }
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"rechargeWay"] = @"SWIFT";
    params[@"amount"] = self.inputTextField.text;
    params[@"token"] = user[@"token"];
    params[@"controller"] = self;
    [[CTMediator sharedInstance] HCGateWayBusiness_rechargeWithRequestParams:params];
    
}
- (void)textDidChangeNotification {
    if ([self.inputTextField.text length] >0) {
        self.rechargeButton.enabled = YES;
        
    }else{
        self.rechargeButton.enabled = NO;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = self.footerView;
        [_tableView registerClass:[HCRechargeTopCell class] forCellReuseIdentifier:cellIdentifier1];
        [_tableView registerClass:[HCRechargeBankCell class] forCellReuseIdentifier:cellIdentifier2];
        [_tableView registerClass:[HCRechargeInputCell class] forCellReuseIdentifier:cellIdentifier3];
    }
    return _tableView;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return CGFLOAT_MIN;
            break;
        case 1:
            return 15.f;
            break;
        case 2:
            return 40.f;
            break;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==1) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 15)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        return view;
    }
    if (section==2) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,0, [UIScreen mainScreen].bounds.size.width-40, 40)];
        self.statusLabel.font =[UIFont systemFontOfSize:12];
        self.statusLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        
        NSDecimalNumber * dayLimit = self.successLimitParam[@"dayLimit"];
        NSDecimalNumber * monthLimit = self.successLimitParam[@"monthLimit"];

        self.statusLabel.text=  [NSString stringWithFormat:@"单日%@,单月%@",[self conversionNumber:dayLimit],monthLimit.intValue<0?@"不限":[self conversionNumber:monthLimit]];

        
        [view addSubview:self.statusLabel];
        return view;
        
    }
    return nil;
}
- (NSString *)conversionNumber:(NSDecimalNumber *)number {
    if (number.integerValue==0) {
        return @"0.00元";
    }
    if (number.integerValue%10000==0) {
        return [NSString stringWithFormat:@"%zd万",number.integerValue/10000];
    }
    return [NSString stringWithFormat:@"%.2f元",number.doubleValue];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==2?15:CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 84;
            break;
        case 2:
            return 50;
            break;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section==2) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 15)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        return view;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
      HCRechargeTopCell *  topCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"账户余额："];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        param[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"0xfc6120"];
        
        if (self.userBalance!=nil) {
            NSString * balance = [NSString stringWithFormat:@"%.2f",[self.userBalance doubleValue]];
            NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:balance attributes:param];
            [attr appendAttributedString:attr2];
            NSAttributedString * attr3 = [[NSAttributedString alloc] initWithString:@"元" attributes:param];
            [attr appendAttributedString:attr3];
            topCell.accountBalanceLabel.attributedText =attr;
            
        }
        return topCell;
    } else if (indexPath.section==1) {
        HCRechargeBankCell * bankCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (self.bankModel) {
            bankCell.bankIconView.image= [NSBundle money_ImageWithName:self.bankModel.bankCode];
            bankCell.bankNameLabel.text = self.bankModel.openBank;
            bankCell.bankAccountLabel.text = [NSString stringWithFormat:@"**** **** **** %@",[self.bankModel.cardNo substringFromIndex:self.bankModel.cardNo.length-4]];
        }
        
        return bankCell;
    } else{
        HCRechargeInputCell * inputCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        inputCell.jinELabel.text = @"充值金额";
        inputCell.rechargeTextField.delegate = self;
        NSString * placeString = [NSString stringWithFormat:@"该卡本次最多充值%@",[self conversionNumber:self.successLimitParam[@"singleRemain"]]];
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:placeString attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        
        inputCell.rechargeTextField.attributedPlaceholder = placeholderText;
        self.inputTextField = inputCell.rechargeTextField;
        return inputCell;
        
    }
}
- (CGFloat )footerViewHeight {
    CGFloat height = 44+(CGRectGetWidth([UIScreen mainScreen].bounds)-40) *274.0/1442.0+40;
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    NSMutableParagraphStyle * paraStryle = [[NSMutableParagraphStyle alloc] init];
    paraStryle.lineSpacing = 5.f;
    paraStryle.paragraphSpacingBefore = 3;
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStryle range:NSMakeRange(0, attr.length)];
    
    NSAttributedString * attrContent = [[NSAttributedString alloc] initWithString:@"1.充值资金将进入您的海口联合农商银行个人存管账户；\n2.充值前请确认您的银行卡是否已经开通快捷支付等功能；\n3.充值限额由银行、第三方支付平台及用户设定的银行卡快捷支付限额决定，取三者最小值，请多留意，以免造成充值不成功的情况；\n4.如果充值金额没有及时到账，请马上联系客服400-990-7626。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"],NSParagraphStyleAttributeName:paraStryle}];
    [attr appendAttributedString:attrContent];
    
    CGRect rect =  [attr boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics context:nil];
    
    height +=rect.size.height;
    
    
    return  height+=15;
}
- (UIView *)footerView {
    if (!_footerView) {
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), [self footerViewHeight])];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton * rechargeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rechargeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [rechargeButton setTitle:@"立即充值" forState:UIControlStateNormal];
        [rechargeButton addTarget:self action:@selector(rechargeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle money_ImageWithName:@"Registration_btn_nor"];
        rechargeButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [rechargeButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage * disImage = [NSBundle money_ImageWithName:@"Registration_btn_dis"];
        rechargeButton.enabled = NO;
        [rechargeButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        [rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rechargeButton = rechargeButton;
        [_footerView addSubview:rechargeButton];
        
        
        [rechargeButton setFrame:CGRectMake(20, 44, CGRectGetWidth([UIScreen mainScreen].bounds)-40, (CGRectGetWidth([UIScreen mainScreen].bounds)-40) *274.0/1442.0)];
        
        
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
        NSMutableParagraphStyle * paraStryle = [[NSMutableParagraphStyle alloc] init];
        paraStryle.lineSpacing = 5.f;
        paraStryle.paragraphSpacingBefore = 3;
        [attr addAttribute:NSParagraphStyleAttributeName value:paraStryle range:NSMakeRange(0, attr.length)];

        NSAttributedString * attrContent = [[NSAttributedString alloc] initWithString:@"1.充值资金将进入您的海口联合农商银行个人存管账户；\n2.充值前请确认您的银行卡是否已经开通快捷支付等功能；\n3.充值限额由银行、第三方支付平台及用户设定的银行卡快捷支付限额决定，取三者最小值，请多留意，以免造成充值不成功的情况；\n4.如果充值金额没有及时到账，请马上联系客服400-990-7626。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"],NSParagraphStyleAttributeName:paraStryle}];
        
        [attr appendAttributedString:attrContent];
        UILabel * descLabel = [[UILabel alloc] init];
        descLabel.numberOfLines = 0;
        descLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        descLabel.font = [UIFont systemFontOfSize:12.f];
        descLabel.attributedText = attr;
        
        [_footerView addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(rechargeButton.mas_bottom).mas_offset(40.f);
            make.left.right.mas_equalTo(rechargeButton);
        }];
        
    }
    
    return _footerView;
}

@end
