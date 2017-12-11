//
//  HCImmediatelyTransferController.m
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCImmediatelyTransferController.h"
#import "HCImmediatelyNormalCell.h"
#import "HCImmediatelyInputCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCUserCreditRightsAssignApi.h"
#import "HCCreditorTransferService.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCMyInvestCreditDetailApi.h"
#import "HCUserCreditRightDetailModel.h"
#import "NSBundle+HCCreditorTransferModule.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCNetworkConfig.h"
@interface HCImmediatelyTransferController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *rateInputTextField;
@property (nonatomic, strong) UITextField *amountInputTextField;
@property (nonatomic, strong) HCUserCreditRightDetailModel * detailModel;
@property (nonatomic, strong) HCAssignmentRuleModel *ruleModel;
@property (nonatomic, assign) double caculateResult;
@property (nonatomic, strong) UIButton * confirmButton;
@end
static NSString * const normalCellIdentifier = @"HCImmediatelyNormalCell";
static NSString * const inputCellIdentifier = @"HCImmediatelyInputCell";

@implementation HCImmediatelyTransferController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"债权转让" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self getDetaileData];
    
}

-  (void)getDetaileData{
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * detailParams = [NSMutableDictionary dictionary];
    detailParams[@"token"] = user[@"token"];
    detailParams[@"number"] = self.number;
    HCMyInvestCreditDetailApi * detailApi = [[HCMyInvestCreditDetailApi alloc] initWithParams:detailParams];
    NSMutableDictionary * ruleParams = [NSMutableDictionary dictionary];
    ruleParams[@"token"] = user[@"token"];
    HCAssignmentRuleApi * ruleApi = [[HCAssignmentRuleApi alloc] initWithParams: ruleParams];
    YTKBatchRequest * batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[ruleApi,detailApi]];
    [MBProgressHUD showFullScreenLoadingView:self.view];

    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
    
        if ([batchRequest.requestArray.firstObject responseJSONObject] && [batchRequest.requestArray.lastObject responseJSONObject]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.ruleModel =  [HCAssignmentRuleModel  yy_modelWithJSON:[batchRequest.requestArray.firstObject responseJSONObject]];
            self.detailModel =  [HCUserCreditRightDetailModel  yy_modelWithJSON:[batchRequest.requestArray.lastObject responseJSONObject]];
            [self.tableView reloadData];
        }
    } failure:^(YTKBatchRequest *batchRequest) {
        [MBProgressHUD showText:batchRequest.failedRequest.error.localizedDescription];
    }];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:[HCImmediatelyNormalCell class] forCellReuseIdentifier:normalCellIdentifier];
        [_tableView registerClass:[HCImmediatelyInputCell class] forCellReuseIdentifier:inputCellIdentifier];
        _tableView.tableFooterView = self.footerView;
    }
    return _tableView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return CGFLOAT_MIN;
    }
    return 15.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        HCImmediatelyNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        cell.titleLabel.text = @"可转金额";
        if (self.detailModel) {
            cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.detailModel.creditRightModel.transferableAmount doubleValue]];

        }
        return cell;
    }
    if (indexPath.section==1) {
        HCImmediatelyInputCell * cell = [tableView dequeueReusableCellWithIdentifier:inputCellIdentifier];
        cell.rateInputTextField.text = [NSString stringWithFormat:@"%.2f",[self.detailModel.projectModel.annualEarnings doubleValue]];
        self.amountInputTextField = cell.amountInputTextField;
        self.rateInputTextField = cell.rateInputTextField;
        
        if (self.detailModel) {
            cell.remainAmount = self.detailModel.creditRightModel.transferableAmount;
            cell.minRate = self.detailModel.projectModel.annualEarnings;
            cell.detailModel = self.detailModel;
            cell.ruleModel=  self.ruleModel;
        }
        __weak typeof(self) weakSelf=  self;
        cell.caculateResultCallBack = ^(double result, BOOL success) {
            weakSelf.caculateResult = result;
            weakSelf.confirmButton.enabled = success;
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        
        return cell;
    }
    if (indexPath.section==2) {
        HCImmediatelyNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        cell.titleLabel.text = @"预计回款";
        cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",self.caculateResult];
        [cell.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if (indexPath.section==3) {
        HCImmediatelyNormalCell * cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
        cell.titleLabel.text = @"常见问题";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    return [UITableViewCell new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        
        NSString * url = [NSString stringWithFormat:@"%@user-center/help/9?number=%@&amount=%@&annualEarnings=%@",WebBaseURL,self.detailModel.creditRightModel.number,self.amountInputTextField.text.length==0?@"0":self.amountInputTextField.text,self.rateInputTextField.text];
        
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
        [self.navigationController pushViewController:controller animated:YES];
        
        
        
    }
    if (indexPath.section==3) {
        NSString * url = [NSString stringWithFormat:@"%@assignment-question",WebBaseURL];
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
        [self.navigationController pushViewController:controller animated:YES];
    }

}



- (void)protocolClick {
    NSString * url = [NSString stringWithFormat:@"%@assignment-agree",WebBaseURL];

    UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
    [self.navigationController pushViewController:controller animated:YES];

}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 125)];
        
        
        UIButton * protocolButton = [UIButton buttonWithType:UIButtonTypeSystem];
        NSMutableAttributedString *agreeText = [[NSMutableAttributedString alloc] initWithString:@"同意"];
        [agreeText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, agreeText.string.length)];
        [agreeText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x666666"] range:NSMakeRange(0, agreeText.string.length)];
        
        NSMutableAttributedString *protocolText = [[NSMutableAttributedString alloc] initWithString:@"《债权转让服务协议》" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        [protocolText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x006cff"] range:NSMakeRange(0, protocolText.string.length)];
        
        
        
        [agreeText appendAttributedString:protocolText];
        [protocolButton addTarget:self action:@selector(protocolClick) forControlEvents:UIControlEventTouchUpInside];
        
        [protocolButton setAttributedTitle:agreeText forState:UIControlStateNormal];
        
        
        [_footerView addSubview:protocolButton];

        
        
        
        UIButton * confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
        confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [confirmButton setTitle:@"确认转让" forState:UIControlStateNormal];
        UIImage * backgroundImage = [NSBundle creditorTransfer_ImageWithName:@"Registration_btn_nor"];
        confirmButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [confirmButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        UIImage * disImage = [NSBundle creditorTransfer_ImageWithName:@"Registration_btn_dis"];
        confirmButton.enabled = NO;
        [confirmButton setBackgroundImage:disImage forState:UIControlStateDisabled];
        [confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:confirmButton];
        self.confirmButton = confirmButton;
        
       
        
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(20.f);
            make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)-40);
            make.height.mas_equalTo(confirmButton.mas_width).multipliedBy(274.0/1442.0);
        }];
        [protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_footerView);
            make.bottom.mas_equalTo(confirmButton.mas_top).mas_offset(-10);
        }];

        
    }
    return _footerView;
}


- (void)confirmButtonClick {
    

    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] =user[@"token"];
    params[@"amount"] = self.amountInputTextField.text;
    params[@"creditRightId"] = @(self.detailModel.creditRightId);
    params[@"annualEarnings"] = self.rateInputTextField.text;
    params[@"number"] = self.detailModel.creditRightModel.number;

    
    
    HCUserCreditRightsAssignApi * api = [[HCUserCreditRightsAssignApi alloc] initWithParams:params];
    [MBProgressHUD showLoadingFromView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (request.responseObject) {
            [MBProgressHUD showText:@"转出成功！"];
            if (self.hanlderSuccessCallBack) {
                NSDecimalNumber * transferableAmount =  self.detailModel.creditRightModel.transferableAmount;
                if (self.hanlderSuccessCallBack) {
                    NSDictionary * responseData = request.responseObject;
                    NSString * currentStock = [NSString stringWithFormat:@"%zd",[responseData[@"currentStock"] integerValue]*100];
                    
                    NSDecimalNumber * remainAmount =  [transferableAmount decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:currentStock]];
                    self.hanlderSuccessCallBack(remainAmount);
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        
    }];
    
    
}
@end
