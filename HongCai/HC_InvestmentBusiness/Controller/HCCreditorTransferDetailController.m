//
//  HCBondsTransferDetailController.m
//  HongCai
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCreditorTransferDetailController.h"
#import "HCCreditorTRansferDetailCell.h"
#import "HCCreditorTRansferDetailHeaderView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HCGoToInvestBusiness_Category/CTMediator+HCGoToInvestBusiness.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCAssignmentOrderApi.h"
#import "HCUserNotPayOrderApi.h"
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import "HCInvestWebController.h"
#import "HCCheckUserService.h"
#import "HCNetworkConfig.h"
typedef void(^successCallBack)(id notPayOrderdata);


@interface HCCreditorTransferDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) HCCreditorTRansferDetailHeaderView *headerView;

@end
static NSString *const cellIdentifier = @"HCCreditorTRansferDetailCell";

@implementation HCCreditorTransferDetailController
- (HCCreditorTRansferDetailHeaderView *)headerView {
    if (!_headerView) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 194);
        _headerView = [[HCCreditorTRansferDetailHeaderView alloc] initWithFrame:frame];
        _headerView.interestRateNumber = self.model.annualEarnings;
        _headerView.moneyNumber  = self.model.amount;
        _headerView.timeNumber = self.model.remainDay;
    }
    return _headerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (CGRectGetHeight([UIScreen mainScreen].bounds)==812.0) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49+34, 0));
        }else {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 49, 0));
        }
    }];
    
    
    UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [confirmButton setTintColor:[UIColor whiteColor]];
    confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    if ([self.model.status integerValue]==1) {
        [confirmButton setTitle:@"立即认购" forState:UIControlStateNormal];
        confirmButton.backgroundColor = [UIColor colorWithHexString:@"0xFA4918"];
        confirmButton.userInteractionEnabled = YES;

    }else{
        [confirmButton setTitle:@"已转让" forState:UIControlStateNormal];
        confirmButton.backgroundColor = [UIColor colorWithHexString:@"0x999999"];
        confirmButton.userInteractionEnabled = NO;
    }
    [confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];

    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.height.mas_equalTo(49);
    }];
    
    
    
    
    NSDictionary * param = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    if ([param[@"token"] length] >0) {
        [MBProgressHUD showFullScreenLoadingView:self.view];
        
        [self checkUserNotPayOrder:@{@"token":param[@"token"]} success:^(id notPayOrderdata) {
            if (notPayOrderdata) {
                [self showNotPayOrderViewWithData:notPayOrderdata];
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }

    
}

- (void)showNotPayOrderViewWithData:(id)data {
    
    UIViewController * controller = [[CTMediator sharedInstance] HCShowNotPayViewBusiness_viewControllerWithCountinueButtonClickCallBack:^(NSDictionary *info) {
        
        UIViewController * vc = info[@"controller"];
        [vc dismissViewControllerAnimated:YES completion:NULL];
        
        NSMutableDictionary *payParams = [NSMutableDictionary dictionary];
        NSDictionary *user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        payParams[@"token"] = user[@"token"];
        payParams[@"orderNumber"] = data[@"number"];
        payParams[@"controller"] = self;
        [[CTMediator sharedInstance] HCGateWayBusiness_paymentWithRequestParams:payParams];
        
        
    } detailParams:data];
    
    [self presentViewController:controller animated:YES completion:NULL];
    
    
}
- (void)checkUserNotPayOrder:(NSDictionary *)params success:(successCallBack)success {
    
    
    HCUserNotPayOrderApi * api = [[HCUserNotPayOrderApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        success(request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        success(nil);

        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
}

- (void)confirmButtonClick:(UIButton *)button {
   
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if ([user[@"token"] length] >0) {
        [self checkUserNotPayOrder:@{@"token":user[@"token"]} success:^(id notPayOrderdata) {
            if (notPayOrderdata) {
                [self showNotPayOrderViewWithData:notPayOrderdata];
            }else{
                [self prepareToInvest];
            }
        }];
    }else{
        UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
        [self presentViewController:controller animated:YES completion:NULL];
    }
    
    
}
- (void)prepareToInvest {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    [HCCheckUserService checkUserAuthStatusAndBankcard:self success:^(BOOL success) {
        
        if (success) {
            UIViewController * controller = [[CTMediator sharedInstance] HCGoToTransferBusiness_viewControllerWithgotoInvestButtonClickCallBack:^(NSDictionary *information) {
                
                NSMutableDictionary *investmentParam = [NSMutableDictionary dictionary];
                investmentParam[@"number"] = self.model.number;
                investmentParam[@"token"] = user[@"token"];
                investmentParam[@"amount"] = information[@"investAmount"];
                
                [self gotoInvestWithInvestParams:investmentParam success:^(id data) {
                    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
                    NSMutableDictionary * payParams = [NSMutableDictionary dictionary];
                    payParams[@"token"] =user[@"token"];
                    payParams[@"orderNumber"] = data [@"number"];
                    payParams[@"controller"] = self;
                    UIViewController * alertVC = information[@"controller"];
                    [alertVC dismissViewControllerAnimated:YES completion:NULL];

                    [[CTMediator sharedInstance] HCGateWayBusiness_paymentWithRequestParams:payParams];
                    
                }];
                
            } detailParams:[self.model yy_modelToJSONObject]];
            [self presentViewController:controller animated:YES completion:NULL];
        }
        
    }];
   
}

- (void)gotoInvestWithInvestParams:(NSDictionary *)params success:(successCallBack)success {
    
    HCAssignmentOrderApi * api = [[HCAssignmentOrderApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject && success) {
            success(request.responseJSONObject);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        
    }];
}


- (void)setModel:(HCAssignmentModel *)model {
    _model = model;
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if (model.name) {
        titleLabel.attributedText = [[NSAttributedString alloc]initWithString:model.name attributes:[UINavigationBar appearance].titleTextAttributes];
        [titleLabel sizeToFit];
        self.navigationItem.titleView =titleLabel;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?1:2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerClass:[HCCreditorTRansferDetailCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCCreditorTRansferDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.section==0) {
        cell.titleLabel.text = @"剩余可投";
        cell.contentLabel.hidden = NO;
        cell.contentLabel.text = [NSString stringWithFormat:@"%zd元",[self.model.currentStock integerValue]*100];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.bottomLine.hidden = YES;
    }else{
        cell.contentLabel.hidden = YES;
        cell.bottomLine.hidden = YES;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row==0) {
            cell.titleLabel.text = @"原项目详情";
            cell.bottomLine.hidden = NO;

        }else{
            cell.titleLabel.text = @"转让记录";
            cell.bottomLine.hidden =YES;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            NSString * projectUrl = [NSString stringWithFormat:@"%@project/%@",WebBaseURL,self.model.projectNumber];
            HCInvestWebController * investWebVC = [[HCInvestWebController alloc] initWithAddress:projectUrl];
            investWebVC.projectNumber = self.model.projectNumber;
            investWebVC.webTitle = self.model.name;
            
            [self.navigationController pushViewController:investWebVC animated:YES];
            
        }else{
            NSString * url = [NSString stringWithFormat:@"%@%@%@",WebBaseURL,@"user-center/assignment-list/",self.model.number];
            UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
            [self.navigationController pushViewController:controller animated:YES];
        
        }
     

    }
}

@end
