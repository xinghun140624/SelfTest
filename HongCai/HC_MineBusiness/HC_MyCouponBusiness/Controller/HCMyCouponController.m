//
//  HCMyCouponController.m
//  HongCai
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyCouponController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "HCMyCouponCell.h"
#import "HCMyCouponModel.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCMyHistoryCouponController.h"
#import "HCMyCouponListController.h"
#import "NSBundle+HCMyCouponModule.h"
#import <TYAlertController/TYAlertView.h>
#import <TYAlertController/UIView+TYAlertView.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCUserCouponsStatApi.h"

@interface HCMyCouponController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) HCMyCouponListController *listVC1;
@property (nonatomic, strong) HCMyCouponListController *listVC2;
@property (nonatomic, strong) UIPageViewController *pageController;
@property (nonatomic, strong) UIButton * helpButton;
@end

static NSString * const myCouponCellIdentifier = @"myCouponCellIdentifier";

@implementation HCMyCouponController
- (UIPageViewController *)pageController {
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.dataSource = self;
        _pageController.delegate = self;
        _pageController.view.frame = self.view.bounds;
        
    }
    return _pageController;
}

- (HCMyCouponListController *)listVC1 {
    if (!_listVC1) {
        HCMyCouponListController * investmentListVC = [[HCMyCouponListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.index = 0;
        _listVC1 = investmentListVC;
    }
    return _listVC1;
}
- (HCMyCouponListController *)listVC2 {
    if (!_listVC2) {
        HCMyCouponListController * investmentListVC = [[HCMyCouponListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.index = 1;
        _listVC2 = investmentListVC;
    }
    return _listVC2;
}

- (UIButton *)helpButton {
    if (!_helpButton) {
        _helpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_helpButton setImage:[NSBundle couponBusiness_ImageWithName:@"wdyhq_icon_wh_nor"] forState:UIControlStateNormal];
        [_helpButton addTarget:self action:@selector(helpButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpButton;
}
- (void)helpButtonClick {

    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"优惠券使用规则" message:@""];
    alertView.buttonCornerRadius = 5.f;
    alertView.layer.cornerRadius = 5.f;
    
    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"我知道了" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
    }];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"0xff611d"];
    NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc] init];
    para.paragraphSpacing = 5.f;
    para.lineSpacing = 2.f;
    
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:@"1.使用优惠券进行投资时，根据使用条件，单笔投资金额达到规定额度即可获得相应面值的现金奖励或享受相应的额外加息奖励；\n2.投资成功后，现金券奖励将直接发放至账户余额，可用于投资或提现；\n3.投资成功且项目募集完成后，加息券开始生效，加息天数以加息券面标注为准：①显示X天即加息X天，②显示全程加息，则为投资期限内全程加息。加息券产生的额外收益将根据项目回款时间按月发放至账户余额，可用于投资或提现；\n4.单笔投资仅可使用一张优惠券，且现金券不可与加息券同时使用。" attributes:@{NSParagraphStyleAttributeName:para}];
    alertView.messageLabel.attributedText = string;
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addAction:cancel];

    [alertView showInController:self preferredStyle:TYAlertControllerStyleAlert];
    
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    if (index==0) {
        return;
    }
    [self.pageController setViewControllers:@[self.listVC2]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    [self.segmentedControl setSelectedSegmentIndex:index];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItem];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"优惠券" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.segmentedControl];
    [self.segmentedControl addSubview:self.helpButton];
    
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0.f);
        make.centerY.mas_equalTo(self.segmentedControl);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageController.view];
    
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(55, 0, 0, 0));
        
    }];
    [self.pageController setViewControllers:@[self.listVC1]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    


    [self requestUserCouponStatData];
}


- (void)setupNavigationItem {
    UIBarButtonItem * historyItem = [[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(historyItemClick)];
    self.navigationItem.rightBarButtonItem = historyItem;
}
- (void)historyItemClick {
    [self.navigationController pushViewController:[HCMyHistoryCouponController new] animated:YES];
    
}

- (void)segmentedControlAction:(HMSegmentedControl *)segmentedControl {
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0://宏财精选
        {
            [self.pageController setViewControllers:@[self.listVC1]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO
                                         completion:nil];
        }
            break;
        case 1://宏财尊贵
        {
            [self.pageController setViewControllers:@[self.listVC2]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO
                                         completion:nil];
            
        }
            break;
    }
}
//优惠券统计
- (void)requestUserCouponStatData {
    
    NSDictionary *user = [[CTMediator sharedInstance] HCUserBusiness_getUser];

    NSMutableDictionary * xianJinParams = [NSMutableDictionary dictionary];
    xianJinParams[@"token"] = user[@"token"];
    xianJinParams[@"type"] = @(1);//宏财精选
    HCUserCouponsStatApi * xianJinApi = [[HCUserCouponsStatApi alloc] initWithParams:xianJinParams];
   
    NSMutableDictionary * jiaxiParams = [NSMutableDictionary dictionary];
    jiaxiParams[@"token"] = user[@"token"];
    jiaxiParams[@"type"] = @(2);//宏财精选
    HCUserCouponsStatApi * jiaxiApi = [[HCUserCouponsStatApi alloc] initWithParams:jiaxiParams];
    YTKBatchRequest * request = [[YTKBatchRequest alloc] initWithRequestArray:@[xianJinApi,jiaxiApi]];
    [request startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
       
        HCUserCouponsStatApi * jiaxiApi = (HCUserCouponsStatApi *)batchRequest.requestArray.firstObject;
        HCUserCouponsStatApi * xianJinApi = (HCUserCouponsStatApi *)batchRequest.requestArray.lastObject;
        NSString * firstTitle = [NSString stringWithFormat:@"加息券(%zd)",[jiaxiApi.responseJSONObject[@"unUsedCoupon"] integerValue]];
        NSString * secondTitle = [NSString stringWithFormat:@"现金券(%zd)",[xianJinApi.responseJSONObject[@"unUsedCoupon"] integerValue]];
        self.segmentedControl.sectionTitles = @[firstTitle,secondTitle];
        
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        
    }];
}


- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
}
- (HMSegmentedControl*)segmentedControl {
    if (!_segmentedControl){
        NSArray * titles = @[@"加息券(0)",@"现金券(0)"];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]};
        [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 55);
    }
    return _segmentedControl;
}
@end


