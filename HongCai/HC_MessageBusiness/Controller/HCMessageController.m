//
//  HCMessageController.m
//  HC_MessageBusiness
//
//  Created by Candy on 2017/7/3.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMessageController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HMSegmentedControl/HMSegmentedControl.h>
#import "HCUserUnReadMsgsApi.h"
#import "HCUserUnReadNoticesApi.h"
#import "HCUserReadAllNoticesApi.h"
#import "HCUserReadAllMsgsApi.h"


#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCMessageListController.h"
@interface HCMessageController () <UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UIPageViewController * pageController;
@property (nonatomic, strong) HCMessageListController * listVC1;
@property (nonatomic, strong) HCMessageListController * listVC2;
@property (nonatomic, strong) UIView * leftDotView;
@property (nonatomic, strong) UIView * rightDotView;

@end


@implementation HCMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"消息" attributes:[UINavigationBar appearance].titleTextAttributes];
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
    if (self.index==0) {
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.pageController setViewControllers:@[self.listVC1]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
        [self getUserUnReadMsgs];
        [self readAllNotice];

    }else{
        self.segmentedControl.selectedSegmentIndex = 1;
        [self.pageController setViewControllers:@[self.listVC2]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
        [self getUserUnReadNotices];
        [self readAllMsgs];
    }
    

}

- (void)readAllNotice {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSString * token = user[@"token"];
        HCUserReadAllNoticesApi * api = [[HCUserReadAllNoticesApi alloc] initWithToken:token];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                self.leftDotView.hidden = YES;
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
}
- (void)readAllMsgs {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSString * token = user[@"token"];
        HCUserReadAllMsgsApi * api = [[HCUserReadAllMsgsApi alloc] initWithToken:token];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                self.rightDotView.hidden = YES;
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
}
- (void)getUserUnReadNotices {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSString * token = user[@"token"];
        HCUserUnReadNoticesApi * api = [[HCUserUnReadNoticesApi alloc] initWithToken:token];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                
                NSInteger count =[request.responseJSONObject[@"count"] integerValue];
                if (count>0) {
                    self.leftDotView.hidden = NO;
                }else{
                    self.leftDotView.hidden = YES;
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
        
    }
    
}
- (void)getUserUnReadMsgs {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        NSString * token = user[@"token"];
        HCUserUnReadMsgsApi * api = [[HCUserUnReadMsgsApi alloc] initWithToken:token];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                NSInteger count =[request.responseJSONObject[@"count"] integerValue];
                if (count>0) {
                    self.rightDotView.hidden = NO;
                }else{
                    self.rightDotView.hidden = YES;
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
        }];
    }
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
    
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    return nil;
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
- (HCMessageListController *)listVC1 {
    if (!_listVC1) {
        HCMessageListController * listVC = [[HCMessageListController alloc] initWithStyle:UITableViewStyleGrouped];
        listVC.index = 0;
        _listVC1 = listVC;
    }
    return _listVC1;
}
- (HCMessageListController *)listVC2 {
    if (!_listVC2) {
        HCMessageListController * listVC2 = [[HCMessageListController alloc] initWithStyle:UITableViewStyleGrouped];
        listVC2.index = 1;
        _listVC2 = listVC2;
    }
    return _listVC2;
}

- (void)segmentedControlAction:(HMSegmentedControl *)segmentedControl {

    switch (segmentedControl.selectedSegmentIndex) {
        case 0://宏财精选
        {
            [self.pageController setViewControllers:@[self.listVC1]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO
                                         completion:nil];
            [self readAllMsgs];
            [self getUserUnReadMsgs];

        }
            break;
        case 1://宏财尊贵
        {
            [self.pageController setViewControllers:@[self.listVC2]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:NO
                                         completion:nil];
            [self getUserUnReadNotices];
            [self readAllMsgs];
        }
            break;
    }
}

- (UIView *)leftDotView {
    if (!_leftDotView) {
        _leftDotView = [[UIView alloc] init];
        _leftDotView.backgroundColor = [UIColor colorWithHexString:@"0xff0000"];
        _leftDotView.layer.cornerRadius =4;
        _leftDotView.hidden = YES;
    }
    return _leftDotView;
}
- (UIView *)rightDotView {
    if (!_rightDotView) {
        _rightDotView = [[UIView alloc] init];
        _rightDotView.backgroundColor = [UIColor colorWithHexString:@"0xff0000"];
        _rightDotView.layer.cornerRadius =4;
        _rightDotView.hidden = YES;
    }
    return _rightDotView;
}

- (HMSegmentedControl*)segmentedControl {
    if (!_segmentedControl){
        NSArray * titles = @[@"公告",@"提醒"];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]};
        _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 55);
        [_segmentedControl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControl addSubview:self.leftDotView];
        [_segmentedControl addSubview:self.rightDotView];
        [self.leftDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/4.0+20);
            make.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
        [self.rightDotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/4.0*3+20);
            make.top.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(8, 8));
        }];
    }
    return _segmentedControl;
}

@end
