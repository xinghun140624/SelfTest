//
//  HCDiscoverController.m
//  HongCai
//
//  Created by Candy on 2017/6/13.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCDiscoverController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCDisvocerTopCell.h"
#import "HCDiscoverMiddleCell.h"
#import "HCDiscoverActivityCell.h"
#import "HCDiscoverService.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "NSBundle+HCDiscoverModule.h"
#import "HCNetworkConfig.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <HCBeForcedOfflineBusiness_Category/CTMediator+HCBeForcedOfflineBusiness.h>
#import "HCUserMemberApi.h"
#import "HCMemberCenterController.h"
@interface HCDiscoverController ()<UITableViewDelegate,UITableViewDataSource,HCDiscoverMiddleCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray * topActivityModels;
@property (nonatomic, strong) NSArray * bottomActivityModels;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) HCUserMemberModel * model;
@end


static NSString *const topUnloginCellIdentifier = @"topUnloginCellIdentifier";
static NSString *const topLoginedCellIdentifier = @"topLoginedCellIdentifier";

static NSString *const middleCellIdentifier = @"HCDiscoverMiddleCell";
static NSString *const activityCellIdentifier = @"HCDiscoverActivityCell";

@implementation HCDiscoverController
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 20)];
    }
    return _footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self configTableView];
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [self loadRemoteData];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [HCRefreshHeader headerWithRefreshingBlock:^{
        [[CTMediator sharedInstance] HCBeForcedOfflineBusiness_checkTokenStatus];
        [weakSelf loadRemoteData];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:@"HC_LoginSuccessNotification" object:nil];

}
- (void)loginSuccess {
    UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if (tabBarVC.selectedIndex==2 && self.navigationController.viewControllers.count==1) {
        HCMemberCenterController * controller = [HCMemberCenterController new];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:controller animated:YES];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        [HCDiscoverService getUserMemberWithToken:user[@"token"] completeHanlder:^(HCUserMemberModel *model) {
            self.model = model;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }else {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)configView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"发现" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
}
- (void)configTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}
- (void)loadRemoteData {
    
    [HCDiscoverService getDiscoverData:^(NSArray *acvitityModels, NSArray *bottomActivityModels) {
        self.topActivityModels = acvitityModels;
        self.bottomActivityModels = bottomActivityModels;
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } errorMessage:^(NSString *errorMessage) {
        [MBProgressHUD showText:errorMessage];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
#pragma -mark HCDiscoverMiddleCellDelegate

- (void)discoverMiddleCell:(HCDiscoverMiddleCell *)middleCell buttonClickAction:(NSInteger)index {
    HCActivityModel * model = self.topActivityModels[index];
    if (model.openSite==1) {
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:model.linkUrl}];
        [self.navigationController pushViewController:controller animated:YES];
    }
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.view.backgroundColor;
        [_tableView registerClass:[HCDisvocerTopUnLoginCell class] forCellReuseIdentifier:topUnloginCellIdentifier];
        [_tableView registerClass:[HCDisvocerTopLoginedCell class] forCellReuseIdentifier:topLoginedCellIdentifier];
        
        [_tableView registerClass:[HCDiscoverMiddleCell class] forCellReuseIdentifier:middleCellIdentifier];
        [_tableView registerClass:[HCDiscoverActivityCell class] forCellReuseIdentifier:activityCellIdentifier];
        _tableView.tableFooterView = self.footerView;
        
    }
    return _tableView;
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
            return 15.f;
            break;
        default:
            return CGFLOAT_MIN;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section==1 || section==2) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 15)];
        headerView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        return headerView;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 75.f;
            break;
        case 1:
            return 81.f;
            break;
        default:
            return ([UIScreen mainScreen].bounds.size.width-30) *250/670.0+15.f;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.bottomActivityModels.count +3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        if (user) {
            HCDisvocerTopLoginedCell * topLoginedCell = [tableView dequeueReusableCellWithIdentifier:topLoginedCellIdentifier];
            if (self.model) {
                topLoginedCell.model = self.model;
            }
            return topLoginedCell;
        }else{
            HCDisvocerTopUnLoginCell * topUnloginCell = [tableView dequeueReusableCellWithIdentifier:topUnloginCellIdentifier];
            return topUnloginCell;
        }
    }
    
    if (indexPath.section==1){
        HCDiscoverMiddleCell * middleCell = [tableView dequeueReusableCellWithIdentifier:middleCellIdentifier];
        if (self.topActivityModels) {
            middleCell.activictyModels = self.topActivityModels;
        }
        middleCell.delegate = self;
        return middleCell;
    }else{
        HCDiscoverActivityCell * cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier];
        
        if (self.bottomActivityModels.count>0) {
            cell = [tableView dequeueReusableCellWithIdentifier:activityCellIdentifier];
            if (indexPath.section-2<self.bottomActivityModels.count) {
                cell.activityModel = self.bottomActivityModels[indexPath.section-2];
            }else{
                cell.activityImageView.image = [NSBundle discover_ImageWithName:@"find_bg_yjfk"];
            }
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        if (user) {
        //  已登录
            HCMemberCenterController * controller = [HCMemberCenterController new];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
       
            UIViewController * loginVC = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:YES completion:NULL];
        }
        
        return;
    }
    if (indexPath.section==1) {
        return;
    }
    if (indexPath.section-2<self.bottomActivityModels.count) {
        HCActivityModel * activityModel =  self.bottomActivityModels[indexPath.section-2];
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:activityModel.linkUrl}];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        //意见反馈；
        
        NSString * url = [NSString stringWithFormat:@"%@%@",WebBaseURL,@"user-center/feedback"];
        UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

@end
