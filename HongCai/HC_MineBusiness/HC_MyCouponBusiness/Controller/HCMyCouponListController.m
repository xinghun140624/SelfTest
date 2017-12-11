//
//  HCMyCouponListController.m
//  HongCai
//
//  Created by Candy on 2017/7/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyCouponListController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "HCMyCouponCell.h"
#import "HCMyCouponModel.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCCouponService.h"
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import "NSBundle+HCMyCouponModule.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>


@interface HCMyCouponListController ()<DZNEmptyDataSetSource>
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *cashCouponArray;
@property (nonatomic, strong) NSMutableArray *increaseRateCouponArray;

@end
static NSString * const cellIdentifier = @"HCMyCouponCell";

@implementation HCMyCouponListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[HCMyCouponCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.page = 1;
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    
    switch (self.index) {
        case 0:
        {
            //加息券
            [HCCouponService getCouponsWithType:1 Page:self.page status:@[@"1"] success:^(NSArray *coupons, BOOL finished) {
                self.tableView.emptyDataSetSource = self;
                [self.increaseRateCouponArray addObjectsFromArray:coupons];
                if (finished) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [self.tableView reloadData];
                    
                }else{
                    [self.tableView reloadData];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];

            
            
            
        }
            break;
        case 1:
        {
            [HCCouponService getCouponsWithType:2 Page:self.page status:@[@"1"] success:^(NSArray *coupons, BOOL finished) {
                self.tableView.emptyDataSetSource = self;
                [self.cashCouponArray addObjectsFromArray:coupons];
                if (finished) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    [self.tableView reloadData];
                    
                }else{
                    [self.tableView reloadData];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];

        }
            break;
        default:
            break;
    }
    
    
    __weak typeof(self) weakSelf = self;
    
    switch (self.index) {
        case 0:
        {
            self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                [HCCouponService getCouponsWithType:1 Page:++strongSelf.page status:@[@"1"] success:^(NSArray *coupons, BOOL finished) {
                    [strongSelf.increaseRateCouponArray addObjectsFromArray:coupons];
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
            break;
        case 1:
        {
        
            self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
                //加息
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                [HCCouponService getCouponsWithType:2 Page:++strongSelf.page status:@[@"1"] success:^(NSArray *coupons, BOOL finished) {
                    [strongSelf.cashCouponArray addObjectsFromArray:coupons];
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
            break;
        default:
            break;
    }
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?7.5:15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.index) {
        case 0:
            tableView.mj_footer.hidden = self.increaseRateCouponArray.count==0;
            return self.increaseRateCouponArray.count;
            break;
        case 1:
            tableView.mj_footer.hidden = self.cashCouponArray.count==0;
            return self.cashCouponArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMyCouponCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    HCMyCouponModel * model = nil;
    
    if (self.index==0) {
        model = self.increaseRateCouponArray[indexPath.section];
    }else{
        model = self.cashCouponArray[indexPath.section];
    }
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    
    HCMyCouponModel * model = nil;
    
    if (self.index==0) {
        model = self.increaseRateCouponArray[indexPath.section];
    }else{
        model = self.cashCouponArray[indexPath.section];
    }
    
    UITabBarController * tabBarVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarVC.selectedIndex = 1;
    UINavigationController * nav= tabBarVC.selectedViewController;
    UIViewController * viewController = nav.visibleViewController;
    
    NSArray *typeName = [model.investProductType componentsSeparatedByString:@","];
    
    __block NSInteger type = 0;
    if (typeName.count>1) {
        type =0;
        
    }else{
        NSString * string = typeName.firstObject;
        if ([string isEqualToString:@"5"]) {
            type = 0;
        }else if ([string isEqualToString:@"6"]){
            type = 1;
        }
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [viewController performSelector:NSSelectorFromString(@"selectIndex:") withObject:@(type)];
#pragma clang diagnostic pop
    [self.navigationController popToRootViewControllerAnimated:NO];

}
#pragma -mark DZNEmptyDataSetSource

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString * desc = @"";
    
    
    switch (self.index) {
        case 0:
            desc = @"您还没有加息券哦~";
            break;
        case 1:
            desc = @"您还没有现金券哦~";
            break;
    }
    if (desc.length>0) {
            NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
        return Attrdesc;
    }
    return nil;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [NSBundle couponBusiness_ImageWithName:@"kby_icon_yhq_nor"];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat height = CGRectGetHeight(scrollView.frame);
    
    
    return -height*0.2;
}

- (NSMutableArray *)cashCouponArray {
    if (!_cashCouponArray) {
        _cashCouponArray = [NSMutableArray array];
    }
    return _cashCouponArray;
}
- (NSMutableArray *)increaseRateCouponArray {
    if (!_increaseRateCouponArray) {
        _increaseRateCouponArray = [NSMutableArray array];
    }
    return _increaseRateCouponArray;
}

@end
