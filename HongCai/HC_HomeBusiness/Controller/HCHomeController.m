//
//  HCHomeController.m
//  HongCai
//
//  Created by Candy on 2017/5/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCHomeController.h"
#import "HCHomeHeaderView.h"
#import "HCHomeViewCell.h"
#import "HCBannerModel.h"
#import "HCActivityModel.h"
#import "HCProjectModel.h"
#import "WMDragView.h"
#import "HCHomeNoticeView.h"
#import "HCHomeActivityView.h"

#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCHomeService.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import <HCBeForcedOfflineBusiness_Category/CTMediator+HCBeForcedOfflineBusiness.h>
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import "HCInvestWebController.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <TYAlertController/UIView+TYAlertView.h>
#import <SDWebImage/SDWebImageDownloader.h>

#import <Masonry/Masonry.h>
#import "HCNetworkConfig.h"
#import "HCNavigationController.h"
#import "HCSettingLockController.h"
#import "HCSettingGestureService.h"

#import "HCVipBirthdayView.h"
#import "HCVipBirthdayApi.h"
#import "HCVipBirthdayModel.h"

#import "HCBannerActivityApi.h"
#import "NSObject+YYModel.h"
#import "AppDelegate.h"
@interface HCHomeController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HCHomeHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <HCProjectModel *>*projectListArray;
@property (nonatomic, strong) WMDragView * dragView;
@property (nonatomic, strong) HCHomeActivityView * homeActivityView;
@property (nonatomic, strong) HCVipBirthdayView * vipBirthdayView;
@property (nonatomic, strong) NSDateFormatter * dateFormatter;

@end

@implementation HCHomeController
#pragma -mark LifeCycle
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
    [self.headerView.cycleScrollView adjustWhenControllerViewWillAppera];
    [self.headerView.homeNoticeView.headLine start];
    [self loadHomeData];
    [HCHomeService getUserShowNewUserFloat:^(BOOL isAppear) {
        self.dragView.hidden = !isAppear;
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(VipBirthDayDidDisappear) name:@"HC_VIPBirthdayNotification" object:nil];
    if (self.isFirstLoad) {
        [self requestActivityBirthday];
        self.isFirstLoad = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.headerView.homeNoticeView.headLine stop];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
// 点击广告页右上角，关闭倒计时，收到通知显示生日礼
-(void)VipBirthDayDidDisappear{
    [self requestActivityBirthday];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstLoad = YES;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.view.backgroundColor =  [UIColor colorWithHexString:@"0x000000"];
    __weak typeof(self) weakSelf = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0,*)) {
            if (CGRectGetHeight([UIScreen mainScreen].bounds)==812) {
                make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            }else{
                make.top.mas_equalTo(self.mas_topLayoutGuideTop);
            }
        }else{
            make.top.mas_equalTo(self.mas_topLayoutGuideTop);
        }
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuideTop);
    }];
    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.dragView];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    self.tableView.mj_header = [HCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadHomeData];
        [[CTMediator sharedInstance] HCBeForcedOfflineBusiness_checkTokenStatus];
    }];
    [self checkUserGesture];
    if (![[CTMediator sharedInstance] HCUserBusiness_getUser]) {
        [HCHomeService getUpdateSystemVersion:self];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hc_applicationDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
}
#pragma mark -- 请求生日礼弹窗
- (void)requestActivityBirthday{
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        __weak typeof(self) weakSelf = self;
        HCVipBirthdayApi *api = [[HCVipBirthdayApi alloc] initWithUserId:[user[@"id"] intValue]];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseObject) {
                NSLog(@"%@",request.responseObject);
                HCVipBirthdayModel *vipModel = [HCVipBirthdayModel yy_modelWithJSON:request.responseObject];
                BOOL isShow = vipModel.isShow;
                
                isShow=YES;
                
                BOOL isClick = [[NSUserDefaults standardUserDefaults] objectForKey:@"vipBirthdayImageClick"];
                if (isShow && !isClick) {//显示生日礼弹窗
                    self.vipBirthdayView.imageView.image = [UIImage imageNamed:@"vip_birthday_banner"];
                    self.vipBirthdayView.closeButtonClick = ^{
                    };
                    
                    self.vipBirthdayView.imageClick = ^{
                        [weakSelf.vipBirthdayView removeFromSuperview];
                        [[NSUserDefaults standardUserDefaults]setObject:@(1) forKey:@"vipBirthdayImageClick"];
                        NSString * url = [NSString stringWithFormat:@"%@activity/happy-birthday",WebBaseURL];
                        UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
                        [weakSelf.navigationController pushViewController:controller animated:YES];
                    };
                    //NSLog(@"%@",NSStringFromClass([self.navigationController.topViewController class]));
                    //[[UIApplication sharedApplication].keyWindow addSubview:self.vipBirthdayView];
                    if ([self.view.window isKeyWindow]&& [self.navigationController.topViewController isEqual:self]) {
                        [self.view.window addSubview:self.vipBirthdayView];
                    }
                }else{//不是生日或者点击了生日礼
                    [weakSelf requestActivity];
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            //显示活动弹窗
            [weakSelf requestActivity];
        }];
    }else{
        //未登录
        [self requestActivity];
    }
}
#pragma mark -- 请求活动弹窗
- (void)requestActivity{
    NSDictionary * user  = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    HCBannerActivityApi * activityRemindingApi = [[HCBannerActivityApi alloc] initWithToken:user?user[@"token"]:nil type:3 locale:5 count:1];
    [activityRemindingApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSArray * activityRemaindingModels = [NSArray yy_modelArrayWithClass:[HCActivityModel class] json:request.responseObject[@"data"]];
        HCActivityModel * activityRemindingModel = [activityRemaindingModels firstObject];
        if (activityRemindingModel) {
            NSInteger lastActivityRemindingId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityRemindingId"] integerValue];
            NSInteger lastActivityRemindingStatus = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityRemindingStatus"] integerValue];
            NSString * todayDate = [self.dateFormatter stringFromDate:[NSDate date]];
            NSString * closeActivityRemindingDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"closeActivityRemindingDate"];
            
            if (lastActivityRemindingId==activityRemindingModel.activityId) {
                if (lastActivityRemindingStatus==0&&![todayDate isEqualToString:closeActivityRemindingDate]) {
                    [self downloadActivityImage:activityRemindingModel];
                }
            }else {
                [self downloadActivityImage:activityRemindingModel];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
      
    }];
}
#pragma -mark 检查手势密码
- (void)checkUserGesture{
    __weak typeof(self) weakSelf = self;
    [HCSettingGestureService getUserGesture:^(BOOL success, NSString *gesture) {
        if (success && gesture) {
            self.isFirstLoad = NO;
            HCSettingLockController * settingLock =[[HCSettingLockController alloc] init];
            settingLock.type = GestureViewControllerTypeLogin;
            settingLock.dimissCallBack = ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HCHomeService getUpdateSystemVersion:weakSelf];
                });
                AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
                if ([[app getCurrentVC] isKindOfClass:[HCHomeController class]]) {
                    HCHomeController *homeVC = (HCHomeController*)[app getCurrentVC];
                    [homeVC requestActivityBirthday];
                }
            };
            [self.view.window.rootViewController presentViewController:settingLock animated:NO completion:NULL];
        }else{
            [HCHomeService getUpdateSystemVersion:self];
//            AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
//            if ([[app getCurrentVC] isKindOfClass:[HCHomeController class]]) {
//                HCHomeController *homeVC = (HCHomeController*)[app getCurrentVC];
//                [homeVC requestActivityBirthday];
//            }
        }
    }];
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user==nil) {
        [self requestActivity];
    }
}
- (void)hc_applicationDidBecomeActive {
    [HCHomeService getHomeProjectData:^(NSArray *projectModels) {
        [self.projectListArray removeAllObjects];
        [self.projectListArray addObjectsFromArray:projectModels];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } errorMessage:^(NSString *errorMessage) {
        [MBProgressHUD showText:errorMessage];
    }];
    NSString * forceLevel = [[NSUserDefaults standardUserDefaults] valueForKey:@"forceLevel"];
    if (forceLevel==nil || [forceLevel integerValue]==2) {
        return;
    }else{
        [HCHomeService getUpdateSystemVersion:self];
    }
}
- (void)loadHomeData {
    [HCHomeService getHomeData:^(NSArray *bannerModels, NSArray *noticeModels, NSArray *activiyModels, NSArray *projectModels,HCActivityModel * activityRemindingModel) {
      
        NSMutableArray * bannerArray = [NSMutableArray array];
        self.headerView.bannerModelArray = bannerModels;
        [bannerModels enumerateObjectsUsingBlock:^(HCBannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [bannerArray addObject:obj.imageUrl];
        }];
        self.headerView.imageURLStringsGroup = bannerArray;
        self.headerView.activictyModels = activiyModels;
        self.headerView.homeNoticeView.noticeModels = noticeModels;
        [self.projectListArray removeAllObjects];
        [self.projectListArray addObjectsFromArray:projectModels];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
/*
        if (activityRemindingModel) {
            NSInteger lastActivityRemindingId = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityRemindingId"] integerValue];
            NSInteger lastActivityRemindingStatus = [[[NSUserDefaults standardUserDefaults] valueForKey:@"lastActivityRemindingStatus"] integerValue];
            NSString * todayDate = [self.dateFormatter stringFromDate:[NSDate date]];
            NSString * closeActivityRemindingDate = [[NSUserDefaults standardUserDefaults] valueForKey:@"closeActivityRemindingDate"];
         
            if (lastActivityRemindingId==activityRemindingModel.activityId) {
                if (lastActivityRemindingStatus==0&&![todayDate isEqualToString:closeActivityRemindingDate]) {
                    [self downloadActivityImage:activityRemindingModel];
                }
            }else {
                [self downloadActivityImage:activityRemindingModel];
            }
        }
 */
    } errorMessage:^(NSString *errorMesage) {
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showNetWorkView:self.view reloadClick:^{
            [MBProgressHUD showFullScreenLoadingView:self.view];
            [self loadHomeData];
        }];
        [MBProgressHUD showText:errorMesage];
    }];
}
- (void)downloadActivityImage:(HCActivityModel *)activityRemindingModel {
    NSString * todayDate = [self.dateFormatter stringFromDate:[NSDate date]];
    __weak typeof(self) weakSelf = self;
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:activityRemindingModel.imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        self.homeActivityView.imageView.image = image;
        self.homeActivityView.closeButtonClick = ^{
            [[NSUserDefaults standardUserDefaults] setObject:todayDate forKey:@"closeActivityRemindingDate"];
        };
        self.homeActivityView.imageClick = ^{
            [weakSelf.homeActivityView removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"lastActivityRemindingStatus"];
            UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:activityRemindingModel.linkUrl}];
            [weakSelf.navigationController pushViewController: controller animated:YES];
        };
        [[NSUserDefaults standardUserDefaults] setObject:@(activityRemindingModel.activityId) forKey:@"lastActivityRemindingId"];
        if ([self.view.window isKeyWindow]&& [self.navigationController.topViewController isEqual:self]) {
            [self.view.window addSubview:self.homeActivityView];
        }
    }];
}

#pragma -mark UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.projectListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HCProjectModel * project = self.projectListArray[indexPath.section];
    NSString * projectUrl = [NSString stringWithFormat:@"%@project/%@",WebBaseURL,[project.projectList[0] number]];
    HCInvestWebController * investWebVC = [[HCInvestWebController alloc] initWithAddress:projectUrl];
    investWebVC.projectNumber = [project.projectList[0] number];
    investWebVC.webTitle = [project.projectList[0] name];
    [self.navigationController pushViewController:investWebVC animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = @"HCHomeCellIdentifer";
    HCHomeViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.project = self.projectListArray[indexPath.section];
    cell.moreButtonClickCallBack = ^{
        UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 1;
        UINavigationController * nav= tabBarVC.selectedViewController;
        UIViewController * viewController = nav.visibleViewController;
        NSInteger type = indexPath.section==0?0:1;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [viewController performSelector:NSSelectorFromString(@"selectIndex:") withObject:@(type)];
#pragma clang diagnostic pop
    };
    
    if (indexPath.section==0) {
        cell.logoImageView.image = [UIImage imageNamed:@"home_icon_hcjx_nor"];
        cell.logoTextLabel.text = @"宏财精选";
        cell.leftLabel.text =@"中短期";
        cell.middleLabel.text =@"即投即计息";
        cell.rightLabel.text =@"精选资产";
    }else{
        cell.logoImageView.image = [UIImage imageNamed:@"home_icon_hczg_nor"];
        cell.logoTextLabel.text = @"宏财尊贵";
        cell.leftLabel.text =@"中长期";
        cell.middleLabel.text =@"即投即计息";
        cell.rightLabel.text =@"臻选资产";
    }
    return cell;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma -mark LazyLoadings
- (HCHomeHeaderView*)headerView {
    if (!_headerView){
        CGFloat scrollViewHeight = self.view.frame.size.width*(171.0/360.0);
        _headerView = [[HCHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28+scrollViewHeight+0.5+75)];
        _headerView.controller = self;
    }
    return _headerView;
}
- (NSMutableArray<HCProjectModel *> *)projectListArray {
    if (!_projectListArray) {
        _projectListArray = [NSMutableArray array];
    }
    return _projectListArray;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        _tableView.tableFooterView = [self footerView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight= UITableViewAutomaticDimension;
        [_tableView registerClass:[HCHomeViewCell class] forCellReuseIdentifier:@"HCHomeCellIdentifer"];
    }
    return _tableView;
}
- (UIView *)footerView {
    CGFloat width =  CGRectGetWidth([UIScreen mainScreen].bounds);
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,width, 40)];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, width, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font =[UIFont systemFontOfSize:13];
    label.text = @"期望回报可能存在市场波动 , 请谨慎投资 !";
    label.textColor = [UIColor colorWithHexString:@"444444"];
    [view addSubview:label];
    return view;
}
- (WMDragView *)dragView {
    if (!_dragView) {
        CGFloat width =  CGRectGetWidth([UIScreen mainScreen].bounds);
        _dragView = [[WMDragView alloc] initWithFrame:CGRectMake(width-113,CGRectGetMidY([UIScreen mainScreen].bounds)-29, 113, 58)];
        _dragView.backgroundColor = [UIColor clearColor];
        _dragView.dragDirection = WMDragDirectionVertical;
        _dragView.imageView.image = [UIImage imageNamed:@"新手专享"];
        __weak typeof(self) weakSelf = self;
        _dragView.hidden = YES;
        _dragView.clickDragViewBlock = ^(WMDragView *dragView) {
            NSString * url = [NSString stringWithFormat:@"%@activity/novice-landing",WebBaseURL];
            UIViewController * webVC = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
            [weakSelf.navigationController pushViewController:webVC animated:YES];
        };
    }
    return _dragView;
}
- (HCVipBirthdayView *)vipBirthdayView {
    if (!_vipBirthdayView) {
        _vipBirthdayView = [[HCVipBirthdayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _vipBirthdayView;
}
- (HCHomeActivityView *)homeActivityView {
    if (!_homeActivityView) {
        _homeActivityView = [[HCHomeActivityView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _homeActivityView;
}
@end
