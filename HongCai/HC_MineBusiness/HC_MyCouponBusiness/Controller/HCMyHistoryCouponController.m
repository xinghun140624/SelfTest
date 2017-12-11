//
//  HCMyHistoryCouponController.m
//  HongCai
//
//  Created by Candy on 2017/7/2.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyHistoryCouponController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMyHistoryCouponCell.h"
#import "HCMyCouponModel.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCCouponService.h"
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "NSBundle+HCMyCouponModule.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
@interface HCMyHistoryCouponController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *couponArray;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) UIView * headerView;
@end
static NSString * const myHistoryCouponCellIdentifier = @"myHistoryCouponCellIdentifier";

@implementation HCMyHistoryCouponController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"历史" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.page = 1;

    [MBProgressHUD showFullScreenLoadingView:self.view];
    [HCCouponService getCouponsWithType:0 Page:self.page status:@[@"2",@"3",@"4"] success:^(NSArray *coupons, BOOL finished) {
        [self.couponArray addObjectsFromArray:coupons];
        self.tableView.emptyDataSetSource = self;
        if (finished) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
            
        }else{
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

    
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [HCCouponService getCouponsWithType:0 Page:++strongSelf.page status:@[@"2",@"3",@"4"] success:^(NSArray *coupons, BOOL finished) {
            [strongSelf.couponArray addObjectsFromArray:coupons];
            strongSelf.tableView.emptyDataSetSource = strongSelf;
            if (finished) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                [strongSelf.tableView reloadData];
                
            }else{
                [strongSelf.tableView reloadData];
                [strongSelf.tableView.mj_footer endRefreshing];
            }
        }];
    }];
}
#pragma -mark DZNEmptyDataSetSource

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString * desc = @"您还没有历史记录哦～";
    NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    return Attrdesc;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [NSBundle couponBusiness_ImageWithName:@"kby_icon_yhq_nor"];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat height = CGRectGetHeight(scrollView.frame);
    
    
    return -height*0.2;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?7.5:15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.mj_footer.hidden = self.couponArray.count==0;
    return self.couponArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMyHistoryCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:myHistoryCouponCellIdentifier];
    if (self.couponArray.count) {
        cell.model = self.couponArray[indexPath.section];
    }
    
    return cell;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        [_tableView registerClass:[HCMyHistoryCouponCell class] forCellReuseIdentifier:myHistoryCouponCellIdentifier];

        
    }
    return _tableView;
}
- (NSMutableArray *)couponArray {
    if (!_couponArray) {
        _couponArray = [NSMutableArray array];
    }
    return _couponArray;
}
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 30)];
        _headerView.backgroundColor = [UIColor colorWithRed:241/255.0 green:205/255.0 blue:192/255.0 alpha:1];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setImage:[NSBundle couponBusiness_ImageWithName:@"srje_iocn_ts_nor"] forState:UIControlStateNormal];
        [button setTitle:@"仅展示最近两周历史记录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_headerView addSubview:button];
        [button sizeToFit];
        button.center = _headerView.center;
    }
    return _headerView;
}
@end
