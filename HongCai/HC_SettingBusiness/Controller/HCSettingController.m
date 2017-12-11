//
//  HCSettingController.m
//  HongCai
//
//  Created by Candy on 2017/6/21.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSettingController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCSettingCell.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import "HCSettingExitCell.h"
#import "HCSettingBankCell.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCSettingService.h"
#import "HCBankManagerController.h"
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCAutoTenderController.h"
#import "HCUserGetAutoTenderApi.h"
#import "HCUserIdentityView.h"
#import <TYAlertController/TYAlertController.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCGetUserBankAndAuthApi.h"
#import "HCCheckUserService.h"
#import "HCNetworkConfig.h"
@interface HCSettingController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) HCUserBankCardModel * bankCardModel;
@property (nonatomic, strong) NSString * questionDesc;
@property (nonatomic, strong) HCUserAutoTenderModel * userAutoTenderModel;
@property (nonatomic, strong) NSDictionary * userAuth;
@end
static NSString * const settingCellIdentifier = @"HCSettingCell";
static NSString * const settingBankCellIdentifier = @"HCSettingBankCell";
static NSString * const settingExitCellIdentifier = @"HCSettingExitCell";

@implementation HCSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"设置" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:HC_LoginSuccessNotification object:nil];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self.view);
    }];
    
    
    //[MBProgressHUD showFullScreenLoadingView:self.view];

 
 
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
    
    
}
- (void)loginSuccess {
    [self requestData];
}
- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)requestData  {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        [HCSettingService getUserBankCardWithToken:user[@"token"] success:^(HCUserBankCardModel *model) {
            self.bankCardModel = model;
            [self.tableView reloadData];
        }];
        
        
        [HCSettingService getUserQuestionWithToken:user[@"token"] success:^(NSString *desc) {
            self.questionDesc = desc;
            [self.tableView reloadData];
        }];
        
        [HCSettingService getUserAutoTenderWithToken:user[@"token"] success:^(HCUserAutoTenderModel *model) {
            self.userAutoTenderModel = model;
            [self.tableView reloadData];
        }];
        [[CTMediator sharedInstance] HCUserBusiness_getUserAuth:@{@"token":user[@"token"]} SuccessCallBack:^(NSDictionary *info) {
            self.userAuth = info;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
            
        }];
    }
}
- (void)openCGT:(UIViewController *)controller {
    
    HCUserIdentityView * view = [[HCUserIdentityView alloc] initWithFrame:CGRectZero];
    TYAlertController * alert = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationFade];
    alert.alertViewOriginY = [UIScreen mainScreen].bounds.size.height *0.2;
    
    [controller presentViewController:alert animated:YES completion:NULL];
    __weak typeof(TYAlertController *) weakVC = alert;
    view.cancelButtonClickCallBack = ^{
        [weakVC dismissViewControllerAnimated:YES];
    };
    view.confirmButtonClickCallBack = ^(NSDictionary *params) {
        [weakVC dismissViewControllerAnimated:YES];
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"realName"] = params[@"realName"];
        param[@"idCardNo"] = params[@"idCardNo"];
        param[@"token"] = user[@"token"];
        param[@"controller"] = controller;
        
        [[CTMediator sharedInstance] HCGateWayBusiness_yeePayRegisterWithRequestParams:param];
    };
    
    
}

- (void)activeCGT:(UIViewController *)controller {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = user[@"token"];
    param[@"controller"] = controller;
    [[CTMediator sharedInstance] HCGateWayBusiness_cgtActiveWithRequestParams:param];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_modifyBingdingMobileViewController];
        [self.navigationController pushViewController:controller animated:YES];
    } else if (indexPath.section==1 && indexPath.row==0){
        NSDictionary * userAuth = self.userAuth;

        if (self.userAuth) {
            if ([userAuth[@"authStatus"] integerValue]==2) {
                if ([userAuth[@"active"] integerValue]==1) {
                    return;
                }else{
                    //未激活
                    [self activeCGT:self];
                }
            }else{
                [self openCGT:self];
            }
        }
    } else if (indexPath.section==1 && indexPath.row==1){
        //银行卡
        HCBankManagerController * bankManager = [[HCBankManagerController alloc] init];
        [self.navigationController pushViewController:bankManager animated:YES];

    }else if (indexPath.section==2 && indexPath.row==1){
        
        [HCCheckUserService checkUserAuthStatusAndBankcard:self success:^(BOOL success) {
            if (success) {
                
                if ([self.userAuth[@"autoTransfer"] integerValue]==0) {
                    [self authorizeAutoTransfer];
                }else{
                    HCAutoTenderController * autoVC = [[HCAutoTenderController alloc] init];
                    if ([self.userAutoTenderModel.minInvestAmount doubleValue]>0) {
                        autoVC.model = self.userAutoTenderModel;
                    }
                    [self.navigationController pushViewController:autoVC animated:YES];
                }
                
            }
        }];

    }else if (indexPath.section==2 && indexPath.row==2){
        NSString * url = [NSString stringWithFormat:@"%@user-center/questionnaire",WebBaseURL];
        UIViewController * controller =  [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
        [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.section==2 && indexPath.row==3){
        return;
    }else{
        UIViewController * controller = [NSClassFromString(@"HCPasswordManagerController") new];
        
        [self.navigationController pushViewController:controller animated:YES];

    }
}
//用户授权自动投标;
- (void)authorizeAutoTransfer {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * param = [NSMutableDictionary dictionary];
    param[@"token"] = user[@"token"];
    param[@"controller"] = self;
    [[CTMediator sharedInstance] HCGateWayBusiness_userAuthorizeAutoTransferWithRequestParams:param];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1 && indexPath.row==0) {
        NSDictionary * userAuth = self.userAuth;
        
        if (userAuth) {
            if ( [userAuth[@"authStatus"] integerValue]==2) {
                return 80;
            }else{
                return 50.f;
            }
        }

    }
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==3) {
        return 50;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?CGFLOAT_MIN:15.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray * array = self.titleArray[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section==0 || indexPath.section ==2) {
        HCSettingCell * cell = [tableView dequeueReusableCellWithIdentifier:settingCellIdentifier];
        NSArray * array = self.titleArray[indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        NSString * title = array[indexPath.row];
        cell.titleLabel.text = title;
        if (indexPath.section==0 && indexPath.row==0) {
            NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
            cell.descLabel.text = user[@"mobile"];
            cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            

        }else if (indexPath.section==1 && indexPath.row==0) {
            cell.descLabel.text = @"去开通";
            cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.section==2 && indexPath.row==0) {
            cell.descLabel.text = @"";
        }else if (indexPath.section==2 && indexPath.row==1){
            
            BOOL isOpen  = [self.userAutoTenderModel.startTime integerValue] > [[NSDate date] timeIntervalSince1970]*1000;
            //还没到开启时间
            if (self.userAutoTenderModel.status==1||(self.userAutoTenderModel.status==0 && isOpen)) {
                cell.descLabel.text = @"已开启";
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
            }else if (self.userAutoTenderModel.status ==2) {
                cell.descLabel.text = @"已过期";
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
            }else if (self.userAutoTenderModel.status ==3) {
                cell.descLabel.text = @"去开启";
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
            }else {
                cell.descLabel.text = @"去开启";
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }
        else if (indexPath.section==2 && indexPath.row==2) {
            
            cell.descLabel.text = self.questionDesc;
            if ([self.questionDesc isEqualToString:@"去测评"]) {
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
            }else{
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }else if (indexPath.section==2 && indexPath.row==3){
            cell.accessoryType = UITableViewCellAccessoryNone;
            NSString * version = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
            cell.descLabel.text = [NSString stringWithFormat:@"v%@",version];
            cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
            [cell.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
            }];
        }
        return cell;
    }
    if (indexPath.section==1) {
        HCSettingBankCell * cell = [tableView dequeueReusableCellWithIdentifier:settingBankCellIdentifier];
        NSArray * array = self.titleArray[indexPath.section];
        NSString * title = array[indexPath.row];
        cell.titleLabel.text = title;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
        if (indexPath.row==0) {
            
            NSDictionary * userAuth = self.userAuth;

            if (userAuth) {
                if ([userAuth[@"authStatus"] integerValue]==2) {
                    
                    
                    if ([userAuth[@"active"] integerValue]==1) {
                        [cell.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.right.mas_equalTo(-15);
                        }];
                        cell.descLabel.text = @"已开通";
                        cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                        cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
                        cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",userAuth[@"realName"],userAuth[@"idNo"]];
                    }else{
                        cell.descLabel.text = @"去激活";
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",userAuth[@"realName"],userAuth[@"idNo"]];
                        cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];

                    }
                    
                }else{
                    cell.descLabel.text = @"未开通";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
                    [cell.nameLabel removeFromSuperview];
                    
                    [cell.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(20.f);
                        make.centerY.mas_equalTo(cell.contentView);
                    }];
                }
                

            }
            
        }else if (indexPath.row==1) {
            cell.titleLabel.text = @"银行卡";
            
            NSString * sring = [self.bankCardModel.cardNo substringWithRange:NSMakeRange(self.bankCardModel.cardNo.length-4, 4)];
            if (self.bankCardModel.verified) {
                cell.descLabel.text = [NSString stringWithFormat:@"%@(%@)",self.bankCardModel.openBank,sring];
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];

            }else{
                cell.descLabel.text = [NSString stringWithFormat:@"去绑卡"];
                cell.descLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];

            }
            
        }
     
        return cell;
    }
    if (indexPath.section==3) {
        HCSettingExitCell * cell = [tableView dequeueReusableCellWithIdentifier:settingExitCellIdentifier];
        __weak typeof(self) weakSelf = self;
        cell.exitButtonClickCallBack = ^{
            [weakSelf hanlderExitAccount];
        };
        return cell;
    }
    
    return [UITableViewCell new];
}



- (void)hanlderExitAccount {

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认退出该账号？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       
        NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        [storage.cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [storage deleteCookie:obj];
        }];
        
        [[CTMediator sharedInstance] HCUserBusiness_removeUser];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HC_UserExitLoginNotification" object:nil];
        [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:@"isHideMoney"];
    
        UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
        [self.navigationController presentViewController:controller animated:YES completion:^{
            self.navigationController.viewControllers = @[self.navigationController.viewControllers.firstObject];
            UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            tabBarVC.selectedIndex = 0;
        }];

        
      
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self presentViewController:alert animated:YES completion:NULL];
}


- (NSArray *)titleArray {
    if (!_titleArray) {
        
        if (self.userAuth) {
            if ([self.userAuth[@"authStatus"] integerValue]==2&& [self.userAuth[@"active"] integerValue]==1) {
                _titleArray = @[@[@"手机号"],@[@"银行存管账户",@"银行卡"],@[@"密码管理",@"自动投标",@"风险测评",@"当前版本"],@[@"123"]];
            }else {
                _titleArray = @[@[@"手机号"],@[@"银行存管账户"],@[@"密码管理",@"自动投标",@"风险测评",@"当前版本"],@[@"123"]];
                
            }
            
        }
    }
    return _titleArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:[HCSettingCell class] forCellReuseIdentifier:settingCellIdentifier];
        [_tableView registerClass:[HCSettingExitCell class] forCellReuseIdentifier:settingExitCellIdentifier];
        [_tableView registerClass:[HCSettingBankCell class] forCellReuseIdentifier:settingBankCellIdentifier];
        _tableView.separatorColor = [UIColor colorWithHexString:@"0xeeeeee"];
        _tableView.estimatedRowHeight = 40;
    }
    return _tableView;
}
@end
