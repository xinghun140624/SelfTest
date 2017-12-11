//
//  HCInvestmentController.m
//  HongCai
//
//  Created by Candy on 2017/6/12.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInvestmentController.h"
#import "HCInvestmentCell.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <GrowingIO/Growing.h>

#import "HCInvestmentListController.h"


@interface HCInvestmentController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) UIPageViewController *pageController;


@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) HCInvestmentListController *listVC1;
@property (nonatomic, strong) HCInvestmentListController *listVC2;
@property (nonatomic, strong) HCInvestmentListController *listVC3;



@end

@implementation HCInvestmentController
- (HCInvestmentListController *)listVC1 {
    if (!_listVC1) {
        HCInvestmentListController * investmentListVC = [[HCInvestmentListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.growingAttributesPageName = @"宏财精选";
        investmentListVC.index = 0;
        _listVC1 = investmentListVC;
    }
    return _listVC1;
}
- (HCInvestmentListController *)listVC2 {
    if (!_listVC2) {
        HCInvestmentListController * investmentListVC = [[HCInvestmentListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.index = 1;
        investmentListVC.growingAttributesPageName = @"宏财尊贵";

        _listVC2 = investmentListVC;
    }
    return _listVC2;
}
- (HCInvestmentListController *)listVC3 {
    if (!_listVC3) {
        HCInvestmentListController * investmentListVC = [[HCInvestmentListController alloc] initWithStyle:UITableViewStyleGrouped];
        investmentListVC.index = 2;
        investmentListVC.growingAttributesPageName = @"宏财转让";

        _listVC3 = investmentListVC;
    }
    return _listVC3;
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

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
       return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

    return nil;
}
- (void)selectIndex:(NSNumber *)index {
    [self.segmentedControl setSelectedSegmentIndex:index.integerValue];
    [self segmentedControlAction:index.integerValue];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.titleView = self.segmentedControl;

    HCInvestmentListController * investmentListVC = [[HCInvestmentListController alloc] initWithStyle:UITableViewStyleGrouped];
    investmentListVC.index = 0;
    [self addChildViewController:self.pageController];
    
    [self.view addSubview:self.pageController.view];
    [self.pageController setViewControllers:@[self.listVC1]
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];

}
// Sent when a gesture-initiated transition begins.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers NS_AVAILABLE_IOS(6_0) {

}

// Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {

}

#pragma -mark events 


- (void)segmentedControlAction:(NSInteger )index {
    
    
    
    switch (index) {
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
        NSArray * titles = @[@"宏财精选",@"宏财尊贵",@"债权转让"];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentedControl.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xffd0bc"]};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
        __weak typeof(self) weakSelf = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            [weakSelf segmentedControlAction:index];
        };
        _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    }
    return _segmentedControl;
}




@end
