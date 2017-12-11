//
//  HCCreditTransferDetailController.m
//  HongCai
//
//  Created by Candy on 2017/7/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCCreditTransferDetailController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "NSBundle+HCCreditorTransferModule.h"
#import "HCAssignmentDetailApi.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCAssignmentsCancelApi.h"
#import "HCAssignmentsRevokeValidateApi.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCNetworkConfig.h"
@interface HCCreditTransferDetailCell : UITableViewCell
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * descLabel;

@end

@implementation HCCreditTransferDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        [self layout_Masonry];
    }
    return self;
}

- (void)layout_Masonry {
    
 
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(20.f);
        make.bottom.mas_equalTo(-20.f);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20.f);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    UIView * bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(20.f);
        make.right.mas_equalTo(-20.f);
        make.height.mas_equalTo(0.5);
    }];
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

@interface HCCreditTransferDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSDictionary * data;
@property (nonatomic, strong) UIView * footerView;
@end

@implementation HCCreditTransferDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"转让详情" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self loadCreditTransferDetail];
}
- (void)loadCreditTransferDetail {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"number"] = self.number;
    [MBProgressHUD showFullScreenLoadingView:self.view];
    HCAssignmentDetailApi * api = [[HCAssignmentDetailApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            self.data = request.responseJSONObject;
            if ([self.data[@"status"] integerValue]==3 || [self.data[@"status"] integerValue]==4) {
                self.tableView.tableFooterView = [UIView new];
            }else{
                self.tableView.tableFooterView = self.footerView;
            }
            [self.tableView reloadData];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        NSString * url = [NSString stringWithFormat:@"%@%@%@",WebBaseURL,@"user-center/assignment-list/",self.number];
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
        [self.navigationController pushViewController:controller animated:YES];
    }

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * array = self.titleArray[section];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?CGFLOAT_MIN:15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCCreditTransferDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        switch (indexPath.row) {
            case 0:
            {
                if (self.data) {
                    cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.data[@"amount"] doubleValue]];
                }
            }
                break;
            case 1:
            {
                if (self.data) {
                    cell.descLabel.text = [NSString stringWithFormat:@"%.2f%%",[self.data[@"annualEarnings"] doubleValue]];
                }
            }
                break;
            case 2:
            {
                if (self.data) {
                    cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.data[@"soldStock"] doubleValue]*100.0];
                }
            }
                break;
            case 3:
            {
                if (self.data) {
                    cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.data[@"transferedIncome"] doubleValue]];
                }
            }
                break;
            default:
                break;
        }
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)cancelTransferClick {

    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"number"] = self.number;
    params[@"token"] = user[@"token"];
    
    [MBProgressHUD showLoadingFromView:self.view];
    HCAssignmentsRevokeValidateApi * api  =[[HCAssignmentsRevokeValidateApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary * data = request.responseObject;
        NSString * message = [NSString stringWithFormat:@"已转让债权金额：%.2f元，未转让债权金额：%.2f元，是否确认撤销？",[data[@"soldStock"] integerValue] *100.0,[data[@"currentStock"] integerValue] *100.0];
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
        UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self assignmentCancel];
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:confirmAction];
        
        [self presentViewController:alertVC animated:YES completion:NULL];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
 
}
- (void)assignmentCancel {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"number"] = self.number;
    params[@"token"] = user[@"token"];
    
    [MBProgressHUD showLoadingFromView:self.view];
    HCAssignmentsCancelApi * api  =[[HCAssignmentsCancelApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD showText:@"撤销成功"];
        if (self.cancelTransferCallBack) {
            self.cancelTransferCallBack();
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];


}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 1)];
        [_footerView addSubview:line];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [button setTitle:@"撤销转让" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(cancelTransferClick) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle creditorTransfer_ImageWithName:@"Registration_btn_nor"];
        button.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerView addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).mas_offset(45.f);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20.f);
            make.height.mas_equalTo(button.mas_width).multipliedBy(274.0/1442.0);
        }];
    }
    return _footerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HCCreditTransferDetailCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.estimatedRowHeight = 60.f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray =@[@[@"转让金额",@"转让利率",@"已转让金额",@"转让收入"],@[@"债权转让记录"]];
    }
    return _titleArray;
}

@end
