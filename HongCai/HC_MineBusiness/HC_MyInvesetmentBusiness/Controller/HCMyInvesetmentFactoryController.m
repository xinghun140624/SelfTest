//
//  HCMyInvesetmentFactoryController.m
//  Pods
//
//  Created by Candy on 2017/6/27.
//
//

#import "HCMyInvesetmentFactoryController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCMyInvesetmentFatctoryHeaderView.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "HCMyInvesetmentFactoryCell.h"
#import <Masonry/Masonry.h>
#import "HCUserInvestStatApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCMyInvestApi.h"
#import "HCMyInvestListController.h"

@interface HCMyInvesetmentFactoryController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) HCMyInvesetmentFatctoryHeaderView *headerView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) HCMyInvestListController *listVC1;
@property (nonatomic, strong) HCMyInvestListController *listVC2;
@property (nonatomic, strong) UIPageViewController *pageController;

@end
static NSString * const cellIdentifier = @"HCMyInvesetmentFactoryCell";

@implementation HCMyInvesetmentFactoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
 
    switch (self.type) {
        case 7:
        {
            titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"宏财精选资产详情" attributes:[UINavigationBar appearance].titleTextAttributes];

        }
            break;
        case 8:
        {
            titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"宏财尊贵资产详情" attributes:[UINavigationBar appearance].titleTextAttributes];

        }
            break;
        case 6:
        {
            titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"债权转让资产详情" attributes:[UINavigationBar appearance].titleTextAttributes];
        }
            break;
    }
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.segmentedControl];
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(CGRectGetMaxY(self.segmentedControl.frame), 0, 0, 0));
        
    }];
    [self.pageController setViewControllers:@[self.listVC1]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];

    [self requestUserInvestStatData];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
}
- (void)segmentedControlAction:(HMSegmentedControl *)segmentedControl {
    
    
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0://持有中
        {
            [self.pageController setViewControllers:@[self.listVC1]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO
                                         completion:nil];
        }
            break;
        case 1://已结清
        {
            [self.pageController setViewControllers:@[self.listVC2]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO
                                         completion:nil];
            
        }
            break;
       
            break;
    }
}


- (UIPageViewController *)pageController {
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.dataSource = self;
        _pageController.delegate = self;
        _pageController.view.frame = self.view.bounds;
        
    }
    return _pageController;
}
- (HCMyInvestListController *)listVC1 {
    if (!_listVC1) {
        HCMyInvestListController * investmentListVC = [[HCMyInvestListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.type = self.type;
        investmentListVC.index = 0;
        _listVC1 = investmentListVC;
    }
    return _listVC1;
}
- (HCMyInvestListController *)listVC2 {
    if (!_listVC2) {
        HCMyInvestListController * investmentListVC = [[HCMyInvestListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.type = self.type;
        investmentListVC.index = 1;
        _listVC2 = investmentListVC;
    }
    return _listVC2;
}
//统计
- (void)requestUserInvestStatData {
    
    NSDictionary *user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"type"] = @(self.type);//宏财精选
    HCUserInvestStatApi * api = [[HCUserInvestStatApi alloc] initWithParams:params];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            self.headerView.data = [request.responseJSONObject firstObject];
            
            NSString * firstTitle = [NSString stringWithFormat:@"持有中(%zd)",[[request.responseJSONObject firstObject][@"holdingCount"] integerValue]];
            NSString * secondTitle = [NSString stringWithFormat:@"已结清(%zd)",[[request.responseJSONObject firstObject][@"endProfitCount"] integerValue]];

            self.segmentedControl.sectionTitles = @[firstTitle,secondTitle];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (HCMyInvesetmentFatctoryHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HCMyInvesetmentFatctoryHeaderView alloc] initWithFrame:CGRectZero];
        UIImage * image = _headerView.bgImageView.image;
        CGFloat height = [UIScreen mainScreen].bounds.size.width *image.size.height/image.size.width;
        _headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), height);
    }
    return _headerView;
}
- (HMSegmentedControl*)segmentedControl {
    if (!_segmentedControl){
        NSArray * titles = @[@"持有中(0)",@"已结清(0)"];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]};
        [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.view.frame.size.width, 55);
    }
    return _segmentedControl;
}
@end
