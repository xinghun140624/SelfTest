//
//  HCPasswordManagerController.m
//  HongCai
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCPasswordManagerController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCPasswordCell.h"
#import "HCUserHadPasswordApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCGetUserBankAndAuthApi.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCGesturePasswordCell.h"
#import "HCSettingLockController.h"
#import "HCGetUserGesturePasswordApi.h"
@interface HCPasswordManagerController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isHave;
@property (nonatomic, strong) NSDictionary * successParams;
@property (nonatomic, assign) BOOL isHaveGesturePassword;
@end
static NSString * const passwordManagerCellIdentifier = @"passwordManagerCellIdentifier";
static NSString * const gesturePasswordCellIdentifier = @"gesturePasswordCellIdentifier";

@implementation HCPasswordManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"密码管理" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self.view);
    }];
    [MBProgressHUD showFullScreenLoadingView:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)loadData {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSMutableDictionary * userHadPassowrdParams = [NSMutableDictionary dictionary];
        userHadPassowrdParams[@"mobile"] = user[@"originMobile"];
        HCUserHadPasswordApi * userHadPassowrdApi = [[HCUserHadPasswordApi alloc] initWithMobile:user[@"originMobile"]];
        HCGetUserBankAndAuthApi * authApi = [[HCGetUserBankAndAuthApi alloc] initWithParams:@{@"token":user[@"token"]}];
        HCGetUserGesturePasswordApi * getUserGestureApi = [[HCGetUserGesturePasswordApi alloc] initWithToken:user[@"token"]];
        YTKBatchRequest * request = [[YTKBatchRequest alloc] initWithRequestArray:@[userHadPassowrdApi,authApi,getUserGestureApi]];
        [request startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            HCUserHadPasswordApi * userHadPassowrdApi = (HCUserHadPasswordApi *)batchRequest.requestArray.firstObject;
            
            self.isHave = ([userHadPassowrdApi.responseJSONObject[@"status"] integerValue]==1);
            HCGetUserBankAndAuthApi * authApi = (HCGetUserBankAndAuthApi *)batchRequest.requestArray[1];
            if (authApi.responseJSONObject) {
                self.successParams = authApi.responseJSONObject;
            }
            HCGetUserGesturePasswordApi * userGestureApi = (HCGetUserGesturePasswordApi *)batchRequest.requestArray[2];
            if (userGestureApi.responseJSONObject) {
                //是否有手势密码；
                self.isHaveGesturePassword = [userGestureApi.responseJSONObject[@"gesture"] integerValue]>0?YES:NO;
            }
            [self.tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [MBProgressHUD showText:request.failedRequest.error.localizedDescription];
        }];

    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HCPasswordCell class] forCellReuseIdentifier:passwordManagerCellIdentifier];
        [_tableView registerClass:[HCGesturePasswordCell class] forCellReuseIdentifier:gesturePasswordCellIdentifier];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.successParams) {
        if ([self.successParams[@"auth"] integerValue]==1) {
            return 2;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?CGFLOAT_MIN:15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            if (self.isHaveGesturePassword) {
                return 3;
            }else{
                return 2;
            }
        }
            break;
        default:
            return 1;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCPasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:passwordManagerCellIdentifier];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
            {
                cell.titleLabel.text = @"登录密码";
                if (self.isHave) {
                    cell.descLabel.text = @"去修改";
                    cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
                }else{
                    cell.descLabel.text = @"未设置";
                    cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
                }
                
            }
                break;
            case 1:
            {
                HCGesturePasswordCell * cell = [tableView dequeueReusableCellWithIdentifier:gesturePasswordCellIdentifier];
                cell.mySwitch.on = self.isHaveGesturePassword;
                [cell.mySwitch addTarget:self action:@selector(mySwitchChange:) forControlEvents:UIControlEventValueChanged];
                cell.titleLabel.text = @"手势密码";
                return cell;
            }
            case 2:
            {
                cell.titleLabel.text = @"修改手势密码";
            }
                
        }
        
    }else {
        cell.titleLabel.text = @"支付密码";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row==0) {
                if (self.isHave) {
                    UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_modifyLoginPasswordController];
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_settingLoginPasswordController];
                    [self.navigationController pushViewController:controller animated:YES];
                }
            }else if (indexPath.row==2){
                //
                HCSettingLockController * settingLock  = [[HCSettingLockController alloc] init];
                settingLock.type = GestureViewControllerTypeVerify;
                [self.navigationController presentViewController:settingLock animated:YES completion:NULL];
            }else{
                return;
            }
        }
            break;
        case 1:{
            [self resetPayPassword];
            
        }
            break;
            
    }
    
}
- (void)mySwitchChange:(UISwitch *)mySwitch {
    if (mySwitch.isOn) {
        HCSettingLockController * settingLock  = [[HCSettingLockController alloc] init];
        settingLock.type = GestureViewControllerTypeSetting;
        [self.navigationController presentViewController:settingLock animated:YES completion:NULL];
    }else{
        HCSettingLockController * settingLock  = [[HCSettingLockController alloc] init];
        settingLock.type = GestureViewControllerTypeVerifyAndDelete;
        [self.navigationController presentViewController:settingLock animated:YES completion:NULL];
    }
}
- (void)resetPayPassword {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = user[@"token"];
    param[@"controller"] = self;
    [[CTMediator sharedInstance] HCGateWayBusiness_resetPayPasswordWithRequestParams:param];
    
}

@end
