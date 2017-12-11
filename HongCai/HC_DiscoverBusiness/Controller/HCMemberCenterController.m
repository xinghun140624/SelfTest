//
//  HCMemberCenterController.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/10.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberCenterController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCAccountApi.h"
#import "HCUserMemberInfoApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import "HCAccountModel.h"
#import "HCMemberInfoModel.h"
#import "HCMemberCenterHeaderView.h"
#import "HCNetworkConfig.h"
#import "HCMemberWelfareApi.h"
#import <TYAlertController/TYAlertView.h>
#import <TYAlertController/UIView+TYAlertView.h>
#import "HCMemberCenterBottomView.h"
#import "HCRaiseRatePrivilegesController.h"
#import "HCBirthdayPrivilegesController.h"
#import "HCWithdrawalPrivilegesController.h"

@interface HCMemberCenterController ()
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic, strong) HCMemberCenterHeaderView * headerView;
@property (nonatomic, strong) HCMemberCenterBottomView * bottomView;

@property (nonatomic,   copy) NSString * userName;
@property (nonatomic, strong) NSArray * listData;
@property (nonatomic, assign) NSInteger selectLevel;
@end

@implementation HCMemberCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.heightConstraint = [NSMutableArray array];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"会员中心" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor whiteColor];
    UIScrollView * scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView = scrollView;
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    UIView * contentView = [UIView new];
    [self.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    [contentView addSubview:self.headerView];
    __weak typeof(self) weakSelf = self;
    
    self.headerView.raiseButtonClickCallBack = ^{
        [weakSelf.scrollView setContentOffset:CGPointMake(0, CGRectGetMinY(weakSelf.bottomView.levelDescImageView.frame)+CGRectGetMaxY(self.headerView.frame)) animated:YES];
    };
    [contentView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.headerView.mas_bottom);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_bottom);
    }];
    [self loadRemoteData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carouselViewDidChange:) name:@"HCICarouselNotification" object:nil];
    self.bottomView.buttonClickCallBack = ^(HCMemberCenterButtonType type) {
        switch (type) {
            case HCMemberCenterButtonTypeRaise:
                {//
                    HCRaiseRatePrivilegesController * controller=  [HCRaiseRatePrivilegesController new];
                    controller.level = weakSelf.headerView.memberInfoModel.currentLevel.level;
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                }
                break;
            case HCMemberCenterButtonTypeBirthDay:
            {//
                HCBirthdayPrivilegesController * controller = [HCBirthdayPrivilegesController new];
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
                break;
            case HCMemberCenterButtonTypeTixian:
            {//
                HCWithdrawalPrivilegesController *controller = [HCWithdrawalPrivilegesController new];
                controller.level = weakSelf.headerView.memberInfoModel.currentLevel.level;
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }
                break;
            case HCMemberCenterButtonTypeWait:
            {//
            }
                break;
        }
    };
}
- (void)carouselViewDidChange:(NSNotification *)notification {
    NSNumber * number = notification.object;
    
    [self updateBottomViewStatus:number];
}
- (void)updateBottomViewStatus:(NSNumber *)number {
    self.selectLevel = number.integerValue;
    NSBundle *mainBundle = [NSBundle bundleForClass:NSClassFromString(@"HCDiscoverController")];
    NSBundle *resourcesBundle = [NSBundle bundleWithPath:[mainBundle pathForResource:@"HCDiscoverBusinessImage" ofType:@"bundle"]];
    switch (number.integerValue) {
        case 1://普通会员
        {
            [self.bottomView.buttonArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                switch (idx) {
                    case 0://加息
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_jiaxiquan_dis"]]
                             forState:UIControlStateNormal];
                        break;
                    case 1:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_birthday_dis"]]
                             forState:UIControlStateNormal];
                        break;
                    case 2:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_tixian_dis"]]
                             forState:UIControlStateNormal];
                        break;
                    case 3:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_wait_dis"]]
                             forState:UIControlStateNormal];
                    default:
                        break;
                }
            }];
        }
            break;
        case 2://青铜会员
        {
            [self.bottomView.buttonArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                switch (idx) {
                    case 0://加息
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_jiaxiquan_normal"]]
                             forState:UIControlStateNormal];
                        break;
                    case 1:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_birthday_dis"]]
                             forState:UIControlStateNormal];
                        break;
                    case 2:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_tixian_dis"]]
                             forState:UIControlStateNormal];
                        break;
                    case 3:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_wait_dis"]]
                             forState:UIControlStateNormal];
                    default:
                        break;
                }
            }];
        }
            break;
        case 3://白银
        {
            [self.bottomView.buttonArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                switch (idx) {
                    case 0://加息
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_jiaxiquan_normal"]]
                             forState:UIControlStateNormal];
                        break;
                    case 1:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_brithday_normal"]]
                             forState:UIControlStateNormal];
                        break;
                    case 2:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_tixian_dis"]]
                             forState:UIControlStateNormal];
                        break;
                    case 3:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_wait_dis"]]
                             forState:UIControlStateNormal];
                    default:
                        break;
                }
            }];
        }
            break;
        case 4://黄金
        case 5:
        case 6:
        {
            [self.bottomView.buttonArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                switch (idx) {
                    case 0://加息
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_jiaxiquan_normal"]]
                             forState:UIControlStateNormal];
                        break;
                    case 1:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_brithday_normal"]]
                             forState:UIControlStateNormal];
                        break;
                    case 2:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_tixian_normal"]]
                             forState:UIControlStateNormal];
                        break;
                    case 3:
                        [obj setImage:[UIImage imageWithContentsOfFile:[[resourcesBundle resourcePath]stringByAppendingPathComponent:@"member_wait_dis"]]
                             forState:UIControlStateNormal];
                    default:
                        break;
                }
            }];
        }
            break;
        default:
            break;
    }
    
}
- (HCMemberCenterHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HCMemberCenterHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.centerController = self;
    }
    return _headerView;
}
- (HCMemberCenterBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[HCMemberCenterBottomView alloc] init];
    }
    return _bottomView;
}
- (void)loadRemoteData {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    [[CTMediator sharedInstance] HCUserBusiness_getUserAuth:@{@"token":user[@"token"]} SuccessCallBack:^(NSDictionary *info) {
        HCAccountApi * accountApi = [[HCAccountApi alloc] initWithParams:@{@"token":user[@"token"]}];
        HCUserMemberInfoApi * memberInfoApi = [[HCUserMemberInfoApi alloc] initWithToken:user[@"token"]];
        
        YTKBatchRequest * request = [[YTKBatchRequest alloc] initWithRequestArray:@[accountApi,memberInfoApi]];
        [request startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
            HCAccountApi * accountRequest =(HCAccountApi *)batchRequest.requestArray.firstObject;
            self.headerView.userName = info[@"realName"];

            if (accountRequest.responseJSONObject) {
                HCAccountModel * accountModel = [HCAccountModel yy_modelWithJSON:accountRequest.responseJSONObject];
                self.headerView.accountModel = accountModel;

            }
            HCUserMemberInfoApi * memberInfoRequest = (HCUserMemberInfoApi *)batchRequest.requestArray.lastObject;
            if (memberInfoRequest.responseJSONObject) {
                HCMemberInfoModel * memberInfoModel = [HCMemberInfoModel yy_modelWithJSON:memberInfoRequest.responseJSONObject];
                if (memberInfoModel.currentLevel.level<6) {
                    __block MASConstraint * heightConstraint = nil;
                    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.top.mas_equalTo(20);
                        heightConstraint = make.height.mas_equalTo(250);
                        [self.heightConstraint removeAllObjects];
                        [self.heightConstraint addObject:heightConstraint];
                    }];
                }else {
                    __block MASConstraint * heightConstraint = nil;
                    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.mas_equalTo(0);
                        make.top.mas_equalTo(20);
                        heightConstraint = make.height.mas_equalTo(200);
                        [self.heightConstraint removeAllObjects];
                        [self.heightConstraint addObject:heightConstraint];
                    }];
                }
                self.headerView.memberInfoModel = memberInfoModel;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
            
        } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (batchRequest.failedRequest.responseJSONObject) {
                [MBProgressHUD showText:batchRequest.failedRequest.responseJSONObject[@"msg"]];
            }else{
                [MBProgressHUD showText:batchRequest.failedRequest.error.localizedDescription];
            }
        }];
        
    }];
}
@end
