//
//  HCWithDrawViewController.m
//  HongCai
//
//  Created by Candy on 2017/7/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCWithDrawViewController.h"



#import "HCRechargeCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMoneyService.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCUserBankCardModel.h"
#import "NSBundle+HCMoneyModule.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <TYAlertController/TYAlertView.h>
#import <TYAlertController/UIView+TYAlertView.h>
@interface HCWithDrawViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) NSDecimalNumber * userBalance;
@property (nonatomic, strong) UITextField * inputTextField;
@property (nonatomic, strong) UIButton * rechargeButton;
@property (nonatomic, strong) HCWithDrawModel *drawModel;
@property (nonatomic, assign) NSInteger  freeWithdrawCount;

@end
static NSString * const cellIdentifier1 = @"HCRechargeCellIdentifer1";
static NSString * const cellIdentifier2 = @"HCRechargeCellIdentifer2";
static NSString * const cellIdentifier3 = @"HCRechargeCellIdentifer3";

@implementation HCWithDrawViewController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    
    
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"提现" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [HCMoneyService getAvailableCashData:^(HCWithDrawModel *model, NSDictionary *freeCount) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.freeWithdrawCount = [freeCount[@"freeWithdrawCount"] integerValue];
        self.userBalance = model.account.balance;
        self.drawModel = model;
        [self.tableView reloadData];
    } errorMessage:^(NSString *errorMessage) {
        [MBProgressHUD showText:errorMessage];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];
    
}
- (void)withDrawButtonClick {
    
    
    double inputAmount = [self.inputTextField.text doubleValue];
    if (self.freeWithdrawCount==0) {
        if (inputAmount -([self.userBalance doubleValue]-2) > 0.001) {
            [MBProgressHUD showText:self.inputTextField.attributedPlaceholder.string];
            return;
        }
    }else{
        if (inputAmount -[self.userBalance doubleValue] > 0.001) {
            [MBProgressHUD showText:self.inputTextField.attributedPlaceholder.string];
            return;
        }
    }
    
    if (self.inputTextField.isFirstResponder) {
        [self.inputTextField resignFirstResponder];
    }
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"amount"] = self.inputTextField.text;
    params[@"token"] = user[@"token"];
    params[@"controller"] = self;
    [[CTMediator sharedInstance] HCGateWayBusiness_withDrawWithRequestParams:params];
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    
    
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
- (void)textDidChangeNotification {
    if (self.drawModel.withdrawFee>0) {
        if ([self.userBalance doubleValue] > 0.001) {
            self.rechargeButton.enabled = YES;
        }else{
            self.rechargeButton.enabled = NO;
            
        }
    }else{
        if ([self.userBalance doubleValue]-2 > 0.001) {
            self.rechargeButton.enabled = YES;
        }else{
            self.rechargeButton.enabled = NO;
            
        }
    }
   
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
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
        case 3:
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
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 40)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20,0, [UIScreen mainScreen].bounds.size.width, 40)];
        label.font =[UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"0x999999"];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"可提现金额："];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        param[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"0xfc6120"];
        
        if (self.userBalance!=nil) {
            if (self.freeWithdrawCount==0) {
                
                NSDecimalNumber * userBalance = [NSDecimalNumber decimalNumberWithString:[self.userBalance stringValue]];
                if (userBalance.doubleValue>=2.00) {
                    userBalance = [userBalance decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"2"]];
                }
                
                NSString * balance = [NSString stringWithFormat:@"%.2f",[userBalance doubleValue]];
                NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:balance attributes:param];
                
                [attr appendAttributedString:attr2];
            }else{
                NSDecimalNumber * userBalance = [NSDecimalNumber decimalNumberWithString:[self.userBalance stringValue]];
                NSString * balance = [NSString stringWithFormat:@"%.2f",[userBalance doubleValue]];
                NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:balance attributes:param];
                [attr appendAttributedString:attr2];
            }
            NSAttributedString * attr3 = [[NSAttributedString alloc] initWithString:@"元" attributes:param];
            [attr appendAttributedString:attr3];
            label.attributedText =attr;
            
        }

        
        [view addSubview:label];
        return view;
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section==2) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 60)];
        view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        UILabel * label = [[UILabel alloc] init];
        label.font =[UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"0x999999"];
        
        [view addSubview:label];

        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"手续费："];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[NSFontAttributeName] = [UIFont systemFontOfSize:12];
        param[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"0xfc6120"];
        
        if (self.freeWithdrawCount>0) {
            param [NSStrikethroughStyleAttributeName] = @(NSUnderlineStyleSingle);
            
            NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:@"2.00" attributes:param];
            [attr appendAttributedString:attr2];
            
            
            NSAttributedString * attr3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"(本次免手续费，本月还剩%zd次免费提现)",self.freeWithdrawCount-1]];
            [attr appendAttributedString:attr3];
            label.attributedText =attr;
        }else {
            NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:@"2.00" attributes:param];
            [attr appendAttributedString:attr2];
            
            NSAttributedString * attr3 = [[NSAttributedString alloc] initWithString:@"(第三方支付收取)"];
            [attr appendAttributedString:attr3];
            label.attributedText =attr;
        }

        
        
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(10);
        }];
        
        UIButton * freeWithDrawButton =[UIButton buttonWithType:UIButtonTypeSystem];
        freeWithDrawButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [freeWithDrawButton setTitle:@" 如何免手续费" forState:UIControlStateNormal];
        [freeWithDrawButton setTintColor:[UIColor colorWithHexString:@"0x666666"]];
        [freeWithDrawButton setImage:[NSBundle money_ImageWithName:@"wdyhq_icon_wh_nor"] forState:UIControlStateNormal];
        [freeWithDrawButton addTarget:self action:@selector(freeWithDrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:freeWithDrawButton];
        
        [view addSubview:freeWithDrawButton];
        [freeWithDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(label.mas_bottom).mas_offset(10);
        }];
        return view;
        
    }
    return nil;
}
- (void)freeWithDrawButtonClick {
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"如何免手续费" message:@""];
    alertView.buttonCornerRadius = 5.f;
    alertView.layer.cornerRadius = 5.f;
    
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"我知道了" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
    }];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"0xff611d"];
    NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc] init];
    para.paragraphSpacing = 5.f;
    para.lineSpacing = 2.f;
    
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:@"免费提现是平台为黄金及以上等级会员提供的的专属特权，不同会员等级每个月拥有的免费提现次数不同，等级越高，免费提现次数越多，赶快去投资提升会员等级吧～" attributes:@{NSParagraphStyleAttributeName:para}];
    alertView.messageLabel.attributedText = string;
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addAction:cancel];
    
    [alertView showInController:self preferredStyle:TYAlertControllerStyleAlert];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section==2?60:CGFLOAT_MIN;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell;
    if (indexPath.section==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"账户余额："];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        param[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"0xfc6120"];
        HCRechargeTopCell * topCell = (HCRechargeTopCell *)cell;
        
        if (self.userBalance) {
            NSString * balance = [NSString stringWithFormat:@"%.2f",[self.userBalance doubleValue]];

            NSAttributedString * attr2 = [[NSAttributedString alloc] initWithString:balance attributes:param];
            [attr appendAttributedString:attr2];
            
            NSAttributedString * attr3 = [[NSAttributedString alloc] initWithString:@"元" attributes:param];
            [attr appendAttributedString:attr3];

            topCell.accountBalanceLabel.attributedText =attr;
            
        }
        return topCell;
    } else if (indexPath.section==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
        HCRechargeBankCell * bankCell = (HCRechargeBankCell *)cell;
        
        if (self.drawModel.bankcard) {
            bankCell.bankIconView.image= [NSBundle money_ImageWithName:self.drawModel.bankcard.bankCode];
            bankCell.bankNameLabel.text = self.drawModel.bankcard.openBank;
            bankCell.bankAccountLabel.text = [NSString stringWithFormat:@"**** **** **** %@",[self.drawModel.bankcard.cardNo substringFromIndex:self.drawModel.bankcard.cardNo.length-4]];
        }
        
        return bankCell;
    } else if (indexPath.section==2) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        HCRechargeInputCell * inputCell = (HCRechargeInputCell *)cell;
        inputCell.jinELabel.text = @"提现金额";
        NSString * desc  = nil;
        if (self.freeWithdrawCount>0) {
            desc = [NSString stringWithFormat:@"该卡本次最高可提现：%.2f元",[self.userBalance doubleValue]];
        }else {
            desc = [NSString stringWithFormat:@"该卡本次最高可提现：%.2f元",[self.userBalance doubleValue]>2?[self.userBalance doubleValue]-2:0.00];
        }
        
        NSAttributedString * placeholderText = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"]}];
        inputCell.rechargeTextField.attributedPlaceholder = placeholderText;
        
        inputCell.rechargeTextField.delegate = self;
        self.inputTextField = inputCell.rechargeTextField;
        return inputCell;
        
    }
    return cell;
}


- (CGFloat )footerViewHeight {
    CGFloat height = 44+(CGRectGetWidth([UIScreen mainScreen].bounds)-40) *274.0/1442.0+40;
    
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    NSMutableParagraphStyle * paraStryle = [[NSMutableParagraphStyle alloc] init];
    paraStryle.lineSpacing = 5.f;
    paraStryle.paragraphSpacingBefore = 3;
    [attr addAttribute:NSParagraphStyleAttributeName value:paraStryle range:NSMakeRange(0, attr.length)];
     NSAttributedString * attrContent = [[NSAttributedString alloc] initWithString:@"1.由第三方支付机构收取提现手续费，每笔2元(金额不限);\n2.一般提现T+1即可到账，最晚T+2到账(双休日及节假日顺延);\n3.银行卡挂失、注销等状态异常导致提现失败，会在收到银行通知后解除该笔资金冻结，并在两个工作日内回到账户余额。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"],NSParagraphStyleAttributeName:paraStryle}];
    [attr appendAttributedString:attrContent];
    
    CGRect rect =  [attr boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics context:nil];
    
    height +=rect.size.height;
    
    
    return  height+=15;
}

- (UIView *)footerView {
    if (!_footerView) {
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), [self footerViewHeight])];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton * withDrawButton = [UIButton buttonWithType:UIButtonTypeSystem];
        withDrawButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [withDrawButton setTitle:@"申请提现" forState:UIControlStateNormal];
        [withDrawButton addTarget:self action:@selector(withDrawButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle money_ImageWithName:@"Registration_btn_nor"];
        withDrawButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [withDrawButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage * disImage = [NSBundle money_ImageWithName:@"Registration_btn_dis"];
        withDrawButton.enabled = NO;
        [withDrawButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        [withDrawButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.rechargeButton = withDrawButton;
        [_footerView addSubview:withDrawButton];
        
        
        [withDrawButton setFrame:CGRectMake(20, 44, CGRectGetWidth([UIScreen mainScreen].bounds)-40, (CGRectGetWidth([UIScreen mainScreen].bounds)-40) *274.0/1442.0)];
        
        
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
        NSMutableParagraphStyle * paraStryle = [[NSMutableParagraphStyle alloc] init];
        paraStryle.lineSpacing = 5.f;
        paraStryle.paragraphSpacingBefore = 3;
        [attr addAttribute:NSParagraphStyleAttributeName value:paraStryle range:NSMakeRange(0, attr.length)];
        
        NSAttributedString * attrContent = [[NSAttributedString alloc] initWithString:@"1.由第三方支付机构收取提现手续费，每笔2元(金额不限);\n2.一般提现T+1即可到账，最晚T+2到账(双休日及节假日顺延);\n3.银行卡挂失、注销等状态异常导致提现失败，会在收到银行通知后解除该笔资金冻结，并在两个工作日内回到账户余额。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"],NSParagraphStyleAttributeName:paraStryle}];
        
        [attr appendAttributedString:attrContent];
        UILabel * descLabel = [[UILabel alloc] init];
        descLabel.numberOfLines = 0;
        descLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        descLabel.font = [UIFont systemFontOfSize:12.f];
        descLabel.attributedText = attr;
        
        [_footerView addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(withDrawButton.mas_bottom).mas_offset(40.f);
            make.left.right.mas_equalTo(withDrawButton);
        }];
        
    }
    
    return _footerView;
}


@end
