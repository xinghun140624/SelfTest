//
//  HCCreditTransferController.m
//  HongCai
//
//  Created by Candy on 2017/7/4.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCreditTransferController.h"

#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "HCCreditTransferCell.h"
#import "HCCreditTransfer_TransferablesApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCImmediatelyTransferController.h"
#import "HCCreditTransferListController.h"

@interface HCCreditTransferController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) HCCreditTransferListController *listVC1;
@property (nonatomic, strong) HCCreditTransferListController *listVC2;
@property (nonatomic, strong) HCCreditTransferListController *listVC3;;
@property (nonatomic, strong) UIPageViewController *pageController;

@end

static NSString * const cellIdentifier = @"HCCreditTransferCell";
@implementation HCCreditTransferController
- (UIPageViewController *)pageController {
    if (!_pageController) {
        _pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageController.dataSource = self;
        _pageController.delegate = self;
        _pageController.view.frame = self.view.bounds;
        
    }
    return _pageController;
}

- (HCCreditTransferListController *)listVC1 {
    if (!_listVC1) {
        HCCreditTransferListController * investmentListVC = [[HCCreditTransferListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.index = 0;
        _listVC1 = investmentListVC;
    }
    return _listVC1;
}
- (HCCreditTransferListController *)listVC2 {
    if (!_listVC2) {
        HCCreditTransferListController * investmentListVC = [[HCCreditTransferListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.index = 1;
        _listVC2 = investmentListVC;
    }
    return _listVC2;
}
- (HCCreditTransferListController *)listVC3 {
    if (!_listVC3) {
        HCCreditTransferListController * investmentListVC = [[HCCreditTransferListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.index = 2;
        _listVC3 = investmentListVC;
    }
    return _listVC3;
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"债权转让" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    
    [self.view addSubview:self.segmentedControl];
    
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageController.view];
    
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(55, 0, 0, 0));
        
    }];
    [self.pageController setViewControllers:@[self.listVC1]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
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
        case 2://债权转让
        {
            
            [self.pageController setViewControllers:@[self.listVC3]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO
                                         completion:nil];
            
        }
            break;
    }
}

- (HMSegmentedControl*)segmentedControl {
    if (!_segmentedControl){
        NSArray * titles = @[@"可转让",@"转让中",@"已转让"];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]};
        _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 55);
        [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}


@end
