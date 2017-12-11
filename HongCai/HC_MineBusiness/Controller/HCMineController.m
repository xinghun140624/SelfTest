//
//  HCMineController.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMineController.h"

#import "HCMineHeaderCell.h"
#import "HCMineCell.h"
#import "HCMinePhoneCell.h"

#import "HCMineFlowLayout.h"
#import <Masonry/Masonry.h>

#import "HCMyCouponController.h"
#import "HCCreditTransferController.h"
#import "HCCalendarController.h"

#import <HCMyInvesetmentBusiness_Category/CTMediator+HCMyInvesetmentBusiness.h>
#import <HCSettingBusiness_Category/CTMediator+HCSettingBusiness.h>
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <HCMessageBusiness_Category/CTMediator+HCMessageBusiness.h>
#import "HCMyDealController.h"
#import "HCUserIdentityView.h"
#import <TYAlertController/TYAlertController.h>
#import <JSToastBusiness/MBProgressHUD+Reminding.h>
#import "HCCheckUserService.h"
#import "HCMyAssetsController.h"
#import "HCMeService.h"
#import "HCRechargeController.h"
#import "HCWithDrawViewController.h"
#import "HCMySpecialMoneyController.h"
#import "HCCheckUserService.h"
#import <JSBadgeView/JSBadgeView.h>
#import "HCNetworkConfig.h"
@interface HCMineController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <NSDictionary *>*buttonConfigs;
@property (nonatomic, assign) NSInteger userCouponCount;
@property (nonatomic, strong) HCAccountModel * model;
@end

@implementation HCMineController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        [HCMeService getUserUnReadMsgsWithToken:user[@"token"] success:^(BOOL isHaveUnReadCount) {
            
            if (isHaveUnReadCount) {
                
                UIImage * messageImage = [[UIImage imageNamed:@"mine_icon_xx_highlight"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIBarButtonItem * messageItem = [[UIBarButtonItem alloc] initWithImage:messageImage style:UIBarButtonItemStylePlain target:self action:@selector(messageBarClick)];
                self.navigationItem.rightBarButtonItem = messageItem;
            }else{
                UIImage * messageImage = [[UIImage imageNamed:@"mine_icon_znx_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                UIBarButtonItem * messageItem = [[UIBarButtonItem alloc] initWithImage:messageImage style:UIBarButtonItemStylePlain target:self action:@selector(messageBarClick)];
                self.navigationItem.rightBarButtonItem = messageItem;
            }
            
            
        }];
    }
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    if (user) {
        [HCMeService getUserAccountInformationWithToken:user[@"token"] success:^(HCAccountModel *model) {
            HCMineHeaderCell * cell = (HCMineHeaderCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            self.model = model;
            cell.model = model;
        }];
        [HCMeService getUserCouponStatWithToken:user[@"token"] success:^(NSInteger unUsedCouponCount) {
            self.userCouponCount = unUsedCouponCount;
            HCMineCell * cell = (HCMineCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
            if (self.userCouponCount >0) {
                cell.badgeView.badgeText = [NSString stringWithFormat:@"%zd",self.userCouponCount];
            }else{
                cell.badgeView.badgeText = nil;
            }
        }];
        NSString * remindingKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"mine_Reminding"];
        if ((remindingKey==nil || [remindingKey integerValue]!=1 )) {
            [MBProgressHUD showMineRemindingViewFromView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
            [self.collectionView layoutIfNeeded];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:1] atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        }
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeButtonClick) name:@"HCLoginBusinessCloseClickNotification" object:nil];
            UIViewController * loginVC = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:loginVC animated:NO completion:NULL];
    }
}
- (UITabBarController *)getRootController {
    return (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}
- (void)closeButtonClick {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self getRootController].selectedIndex = 0;
}
- (void)userExitLogin {
    self.model = nil;
    HCMineHeaderCell * cell = (HCMineHeaderCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell clearData];
    self.userCouponCount = 0;
    [self.collectionView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userExitLogin) name:@"HC_UserExitLoginNotification" object:nil];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"我的" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self setupNavigationItems];
}

- (void)setupNavigationItems {
    UIImage * settingImage = [[UIImage imageNamed:@"mine_icon_sz_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * settingItem = [[UIBarButtonItem alloc] initWithImage:settingImage style:UIBarButtonItemStylePlain target:self action:@selector(settingBarClick)];
    self.navigationItem.leftBarButtonItem = settingItem;
    UIImage * messageImage = [[UIImage imageNamed:@"mine_icon_znx_nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem * messageItem = [[UIBarButtonItem alloc] initWithImage:messageImage style:UIBarButtonItemStylePlain target:self action:@selector(messageBarClick)];
    self.navigationItem.rightBarButtonItem = messageItem;
}
- (void)messageBarClick {
    UIViewController * controller = [[CTMediator sharedInstance] HCMessageBusiness_viewControllerWithIndex:0];
    
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)tixianAction {

    [HCCheckUserService checkUserAuthStatusAndBankcard:self success:^(BOOL success) {
        if (success) {
            HCWithDrawViewController * rechargeVC = [[HCWithDrawViewController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];

        }
    }];
}
- (void)rechargeAction {
    [HCCheckUserService checkUserAuthStatusAndBankcard:self success:^(BOOL success) {
        if (success) {
            HCRechargeController * rechargeVC = [[HCRechargeController alloc] init];
            [self.navigationController pushViewController:rechargeVC animated:YES];
        }
    }];
}

/**
 存管通
 */
- (void)cunguantong {
    HCUserIdentityView * view = [[HCUserIdentityView alloc] initWithFrame:CGRectZero];
    
    TYAlertController * alert = [TYAlertController alertControllerWithAlertView:view preferredStyle:TYAlertControllerStyleAlert transitionAnimation:TYAlertTransitionAnimationFade];
    alert.alertViewOriginY = [UIScreen mainScreen].bounds.size.height *0.2;
    
    [self presentViewController:alert animated:YES completion:NULL];
    __weak typeof(TYAlertController *) weakVC = alert;
    __weak typeof(self) weakSelf = self;
    
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
        param[@"controller"] = weakSelf;
        [[CTMediator sharedInstance] HCGateWayBusiness_yeePayRegisterWithRequestParams:param ];
    };
 
}

- (void)settingBarClick {
    
    UIViewController * controller = [[CTMediator sharedInstance] HCSettingBusiness_viewController];
    [self.navigationController pushViewController:controller animated:YES];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        HCMineFlowLayout * flowLayout = [[HCMineFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = CGFLOAT_MIN;
        flowLayout.minimumInteritemSpacing = CGFLOAT_MIN;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource=self;
        _collectionView.delegate=self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = self.view.backgroundColor;
        [_collectionView registerClass:[HCMineHeaderCell class] forCellWithReuseIdentifier:@"HCMineHeaderCell"];
        [_collectionView registerClass:[HCMineCell class] forCellWithReuseIdentifier:@"HCMineCell"];
        [_collectionView registerClass:[HCMinePhoneCell class] forCellWithReuseIdentifier:@"HCMinePhoneCell"];

    }
    return _collectionView;
}

#pragma mark -- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.buttonConfigs.count;
            break;
        case 2:
            return 1;
            break;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        HCMineHeaderCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HCMineHeaderCell" forIndexPath:indexPath];
        if (self.model) {
            cell.model = self.model;
        }
        __weak typeof(self) weakSelf = self;
        
        cell.tixianCallBack = ^{
            [weakSelf tixianAction];
        };
        cell.kaitongCgtCallBack = ^{
            [weakSelf cunguantong];
        };
        cell.rechargeCallBack = ^{
            [weakSelf rechargeAction];
        };
        cell.moneyClickCallBack = ^(NSInteger type) {
            [weakSelf assetViewClick:type];
        };
        return cell;

    } else if (indexPath.section==1) {
        HCMineCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HCMineCell" forIndexPath:indexPath];
        if (indexPath.row<8) {
            NSDictionary * configs = self.buttonConfigs[indexPath.row];
            [cell.button setTitle:configs[@"title"] forState:UIControlStateNormal];
            UIImage * image = [UIImage imageNamed:configs[@"imageName"]];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            [cell.button setImage:image forState:UIControlStateNormal];
        }
        if (indexPath.row==3) {
        
        }else{
            cell.badgeView.badgeText = nil;
        }

        return cell;
    }else {
    
        HCMinePhoneCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HCMinePhoneCell" forIndexPath:indexPath];

        return cell;
    }

}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        UIImage * headerImage = [UIImage imageNamed:@"mine_bg_nor"];
        
        return CGSizeMake(self.view.frame.size.width, self.view.frame.size.width *headerImage.size.height/headerImage.size.width+74);

    }else if (indexPath.section==1) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width/3.0;
        return  CGSizeMake(width, width*0.85);
    }
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 40);
    
}


#pragma mark --UICollectionViewDelegate

- (void)assetViewClick:(NSInteger)type {

    HCMyAssetsController * controller = [HCMyAssetsController new];
    controller.selectIndex = type;
    controller.model = self.model;
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        if (indexPath.item==0) {
            UIViewController * controller = [[CTMediator sharedInstance] HCMyInvesetmentBusiness_viewController];
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.item==1){
            [self.navigationController pushViewController:[HCCreditTransferController new] animated:YES];
        }else if (indexPath.item==2){
            [self.navigationController pushViewController:[HCMyDealController new] animated:YES];
        }else if (indexPath.item==3){
            [self.navigationController pushViewController:[HCMyCouponController new] animated:YES];
        }else if (indexPath.item==4){
            [self.navigationController pushViewController:[HCMySpecialMoneyController new] animated:YES];
        }else if (indexPath.item==5){
            UIViewController * controller = [[HCCalendarController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.item==6){
            NSString * url = [NSString stringWithFormat:@"%@user-center/invite-rebate",WebBaseURL];
            UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
            [self.navigationController pushViewController:controller animated:YES];
        }else if (indexPath.item==7){
            NSString * url = [NSString stringWithFormat:@"%@user-center/help-center",WebBaseURL];
            UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
            [self.navigationController pushViewController:controller animated:YES];
            
        }

    }
}


-(NSArray<NSDictionary *> *)buttonConfigs {
    if (!_buttonConfigs) {
        
        NSArray * titlesArray = @[@"我的投资",@"债权转让",@"资金流水",@"我的优惠券",@"特权本金",@"回款日历",@"我的邀请",@"帮助中心"];
        NSArray * imageArray = @[@"mine_icon_wdtz_nor",
                                 @"mine_icon_zqzr_nor",
                                 @"mine_icon_zjls_nor",
                                 @"mine_icon_wdyhq_nor",
                                 @"mine_icon_tqbj_nor",
                                 @"mine_icon_hkrl_nor",
                                 @"mine_icon_wdyq_nor",
                                 @"mine_icon_bzzx_nor"];
        
        NSMutableArray * mutArray = [NSMutableArray array];
        for (NSInteger i = 0; i<titlesArray.count; i++) {
            NSString * title = titlesArray[i];
            NSString * imageName = imageArray[i];
            
            NSMutableDictionary * configs = [NSMutableDictionary dictionary];
            configs[@"title"] = title;
            configs[@"imageName"] = imageName;
            [mutArray addObject:configs];
        }
        _buttonConfigs = mutArray;
    }
    return _buttonConfigs;
}

@end
