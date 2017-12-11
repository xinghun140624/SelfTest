//
//  HCBankManagerController.m
//  HongCai
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCBankManagerController.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCUserBankCardModel.h"
#import "HCBankManagerTopCell.h"
#import "HCBankManagerAddCell.h"
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCGetUserBankCardApi.h"
#import "NSBundle+HCMoneyModule.h"
#import "HCNetworkConfig.h"
@interface HCBankManagerController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView * tableView;
@property (nonatomic ,strong) UIView * footerView;
@property (nonatomic, strong) HCUserBankCardModel * model;
@end
static NSString * const topCellIdentifier = @"HCBankManagerTopCell";
static NSString * const mobileCellIdentifier = @"HCBankManagerMobileCell";
static NSString * const jiebangCellIdentifier = @"HCBankManagerJieBangCell";
static NSString * const addCellIdentifier = @"HCBankManagerAddCell";
@implementation HCBankManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"银行卡管理" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self setupNavigationItems];

  
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBankData];
}
- (void)loadBankData {

    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"token"] = user[@"token"];
        [MBProgressHUD showFullScreenLoadingView:self.view];
        HCGetUserBankCardApi * api = [[HCGetUserBankCardApi alloc] initWithParams:params];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (request.responseJSONObject) {
                HCUserBankCardModel * model = [HCUserBankCardModel yy_modelWithJSON:request.responseJSONObject];
                self.model = model;
                [self.tableView reloadData];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (request.responseJSONObject) {
                [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
            }else{
                [MBProgressHUD showText:request.error.localizedDescription];
            }
        }];

    }
}

- (void)setupNavigationItems {
    UIBarButtonItem * xianEItem = [[UIBarButtonItem alloc] initWithTitle:@"限额" style:UIBarButtonItemStyleDone target:self action:@selector(xianEClick)];
    self.navigationItem.rightBarButtonItem = xianEItem;
}
- (void)xianEClick {
    NSString * url = [NSString stringWithFormat:@"%@%@",WebBaseURL,@"user-center/bankcard-limit"];
    UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
    [self.navigationController pushViewController:controller animated:YES];

}
- (void)modifyMobileRequest {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = user[@"token"];
    param[@"controller"] = self;
    [[CTMediator sharedInstance] HCGateWayBusiness_bankCardMobileWithRequestParams:param];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.model&&self.model.verified) {
        return 3;
    }
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.model) {
        return CGFLOAT_MIN;
    }
    return section==0?15:0 ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==0?UITableViewAutomaticDimension:50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    if (self.model.verified) {
        if (indexPath.section==0) {
            HCBankManagerTopCell * cell = [tableView dequeueReusableCellWithIdentifier:topCellIdentifier];
            cell.bankIconView.image = [NSBundle money_ImageWithName:self.model.bankCode];
            cell.bankNameLabel.text = self.model.openBank;
            cell.bankAccountLabel.text = [NSString stringWithFormat:@"**** **** **** %@",[self.model.cardNo substringFromIndex:self.model.cardNo.length-4]];
            return cell;
        }else if (indexPath.section==1) {
            HCBankManagerMobileCell * cell = [tableView dequeueReusableCellWithIdentifier:mobileCellIdentifier];
            if (self.model.mobile.length>0) {
                if (![self.model.mobile containsString:@"*"]) {
                    cell.mobileLabel.text = [NSString stringWithFormat:@"%@****%@",[self.model.mobile substringToIndex:3],[self.model.mobile substringFromIndex:7]];
                }
            }
           
            cell.modifyButtonClickCallBack = ^{
                [weakSelf modifyMobileRequest];
            };
            return cell;
        }else if (indexPath.section==2) {
            HCBankManagerJieBangCell * cell = [tableView dequeueReusableCellWithIdentifier:jiebangCellIdentifier];
            
            __weak typeof(self) weakSelf = self;
            
            cell.jiebangButtonClickCallBack = ^{
                NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
                NSMutableDictionary * params = [NSMutableDictionary dictionary];
                params[@"token"]=  user[@"token"];
                params[@"controller"] =weakSelf;
                [[CTMediator sharedInstance] HCGateWayBusiness_jieBangBankcardWithRequestParams:params];
            };
            return cell;
        }
        
        
    }else {
        HCBankManagerAddCell * cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier];
        __weak typeof(self) weakSelf = self;

        cell.addBankCallBack = ^{
            NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"token"]=  user[@"token"];
            params[@"controller"] =weakSelf;
            [[CTMediator sharedInstance] HCGateWayBusiness_bindBankcardWithRequestParams:params];
        };
        return cell;
    
    
    }

    
    return [UITableViewCell new];
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = self.footerView;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[HCBankManagerTopCell class] forCellReuseIdentifier:topCellIdentifier];
        [_tableView registerClass:[HCBankManagerMobileCell class] forCellReuseIdentifier:mobileCellIdentifier];
        [_tableView registerClass:[HCBankManagerJieBangCell class] forCellReuseIdentifier:jiebangCellIdentifier];
        [_tableView registerClass:[HCBankManagerAddCell class] forCellReuseIdentifier:addCellIdentifier];

        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
    }
    return _tableView;
}



- (UIView *)footerView {
    if (!_footerView) {
        
            CGRect rect = [self.tableView rectForSection:self.model.verified?2:0];
            CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds)- CGRectGetMaxY(rect)-CGRectGetMaxY(self.navigationController.navigationBar.frame);
            _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
        
        
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 1, 1)];
        [_footerView addSubview:line];

        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
        NSMutableParagraphStyle * paraStryle = [[NSMutableParagraphStyle alloc] init];
        paraStryle.lineSpacing = 5.f;
        paraStryle.paragraphSpacingBefore = 3;
        [attr addAttribute:NSParagraphStyleAttributeName value:paraStryle range:NSMakeRange(0, attr.length)];
        
 
        
        NSAttributedString * attrContent = [[NSAttributedString alloc] initWithString:@"1.当前绑定银行卡用于平台充值及提现，为保证投资人资金安全，目前一个账号只可同时绑定一张银行卡；\n2.解绑银行卡：当账户总资产≤2元时，可直接解绑当前银行卡，如遇卡片丢失等不可抗拒因素时，请上传手持身份证等文件至客服邮箱hckf@hoolai.com，或拨打客服热线400-990-7626联系客服进行处理；\n3.更换银行卡：需先解绑当前银行卡，解绑成功后，即可申请绑定新的银行卡。" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x999999"],NSParagraphStyleAttributeName:paraStryle}];
        
        [attr appendAttributedString:attrContent];
        UILabel * descLabel = [[UILabel alloc] init];
        descLabel.numberOfLines = 0;
        descLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        descLabel.font = [UIFont systemFontOfSize:12.f];
        descLabel.attributedText = attr;
        
        [_footerView addSubview:descLabel];
        
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).mas_offset(10.f);
            make.left.mas_equalTo(20.f);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)-40);
        }];
        
    }
    
    return _footerView;
}

@end
