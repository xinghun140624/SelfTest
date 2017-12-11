//
//  HCCreditTransferListController.m
//  HongCai
//
//  Created by Candy on 2017/7/11.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCreditTransferListController.h"
#import "HCInvestmentCell.h"
#import "HCProjectModel.h"
#import "HCAssignmentModel.h"
#import "HCInvestmentService.h"
#import "HCInvestWebController.h"
#import "HCCreditorTransferService.h"
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import "HCCreditTransferCell.h"
#import "HCImmediatelyTransferController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCCreditTransferDetailController.h"
#import "NSBundle+HCCreditorTransferModule.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <HCBeForcedOfflineBusiness_Category/CTMediator+HCBeForcedOfflineBusiness.h>
@interface HCCreditTransferListController ()<DZNEmptyDataSetSource>
@property (nonatomic, strong) NSMutableArray *keZhuanRangArray;
@property (nonatomic, strong) NSMutableArray *zhuanRangZhongArray;
@property (nonatomic, strong) NSMutableArray *yiZhuanRangArray;
@property (nonatomic, assign) NSInteger page;

@end
static NSString * const cellIdentifier = @"HCCreditTransferCell";

@implementation HCCreditTransferListController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadNewData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 130;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HCCreditTransferCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.tableFooterView = [UIView new];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [HCRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
        [[CTMediator sharedInstance] HCBeForcedOfflineBusiness_checkTokenStatus];
        
    }];
    
    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        
        switch (weakSelf.index) {
            case 0:
            {
          
                
                [HCCreditorTransferService loadTransferableDataWithPage:++weakSelf.page success:^(NSArray *models, BOOL isFinish) {
                    if (models.count) {
                        [weakSelf.keZhuanRangArray addObjectsFromArray:models];
                        [weakSelf.tableView reloadData];
                    }
                    if (isFinish) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                    
                }];
            }
                
                break;
            case 1:
            {
                [HCCreditorTransferService loadAssignmentTransferDataWithPage:++weakSelf.page types:@[@1,@2,@5] success:^(NSArray *models, BOOL isFinish)  {
                    if (models.count) {
                        [weakSelf.keZhuanRangArray addObjectsFromArray:models];
                        [weakSelf.tableView reloadData];
                    }
                    if (isFinish) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                    
                }];
            }
                
                break;
            case 2:
            {
                [HCCreditorTransferService loadAssignmentTransferDataWithPage:++weakSelf.page types:@[@3,@4] success:^(NSArray *models, BOOL isFinish) {
                    if (models.count) {
                        [weakSelf.yiZhuanRangArray addObjectsFromArray:models];
                        [weakSelf.tableView reloadData];
                    }
                    if (isFinish) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                    
                }];
            }
            default:
                break;
        }

    }];
    
    
}
- (void)loadNewData {
    self.page = 1;
    switch (self.index) {
        case 0: //可转让
        {
            
            [HCCreditorTransferService loadTransferableDataWithPage:self.page success:^(NSArray *models, BOOL isFinish) {
                self.tableView.emptyDataSetSource = self;

                [self.keZhuanRangArray removeAllObjects];
                [self.keZhuanRangArray addObjectsFromArray:models];
                [self.tableView reloadData];
                if (isFinish) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableView.mj_header endRefreshing];
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }];
            
        }
            break;
            
        case 1://转让中
        {
            [HCCreditorTransferService loadAssignmentTransferDataWithPage:self.page types:@[@1,@2,@5] success:^(NSArray *models, BOOL isFinish) {
                
                self.tableView.emptyDataSetSource = self;

                [self.zhuanRangZhongArray removeAllObjects];
                [self.zhuanRangZhongArray addObjectsFromArray:models];
                [self.tableView reloadData];
                if (isFinish) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableView.mj_header endRefreshing];
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }];
            
            
        }
            break;
        case 2://已转让
        {
            [HCCreditorTransferService loadAssignmentTransferDataWithPage:self.page types:@[@3,@4] success:^(NSArray *models, BOOL isFinish) {
                self.tableView.emptyDataSetSource = self;
                [self.yiZhuanRangArray removeAllObjects];
                [self.yiZhuanRangArray addObjectsFromArray:models];
                [self.tableView reloadData];
                if (isFinish) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [self.tableView.mj_header endRefreshing];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
            break;
        default:
            break;
    }

}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [NSBundle creditorTransfer_ImageWithName:@"kby_icon_zwjl_nor"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString * desc = @"";
    switch (self.index) {
        case 0:
        {
            desc = @"暂无可转让项目";
        }
            break;
        case 1:
        {
            desc = @"暂无转让中项目";

        }
            break;
        case 2:
        {
            desc = @"暂无已转让项目";

        }
            break;
    }
    
    NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    return Attrdesc;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - CGRectGetHeight(scrollView.bounds)*0.2;
}

#pragma mark - Table view data source




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.index) {
        case 0:
        {
            self.tableView.mj_footer.hidden = self.keZhuanRangArray.count==0;
            
            return [self.keZhuanRangArray count];
        }
            break;
        case 1:
        {
            self.tableView.mj_footer.hidden = self.zhuanRangZhongArray.count==0;
            
            return [self.zhuanRangZhongArray count];
        }
            break;
        case 2:
        {
            self.tableView.mj_footer.hidden = self.yiZhuanRangArray.count==0;
            return [self.yiZhuanRangArray count];
        }
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCCreditTransferCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    __weak typeof(self) weakSelf=  self;
    switch (self.index) {
        case 0:
        {
            if (self.keZhuanRangArray.count) {
                HCMyInvestModel * model = self.keZhuanRangArray[indexPath.section];
                cell.model = model;
                cell.transferButtonCallBack = ^{
                    HCImmediatelyTransferController * controller = [[HCImmediatelyTransferController alloc] init];
                    controller.number = model.number;
                    controller.hanlderSuccessCallBack = ^(NSDecimalNumber * remainingAmount) {
                        if (remainingAmount.integerValue>0) {
                            model.amount = remainingAmount;
                            [weakSelf.keZhuanRangArray replaceObjectAtIndex:indexPath.section withObject:model];
                            [weakSelf.tableView  reloadData];
                        }else{
                            [weakSelf.keZhuanRangArray removeObject:model];
                            [weakSelf.tableView  reloadData];
                        }
                    };
                    [weakSelf.navigationController pushViewController:controller animated:YES];
                };
                
            }
            
       
        }
            break;
        case 1:
        {
            if (self.zhuanRangZhongArray.count) {
                HCAssignmentModel * model = self.zhuanRangZhongArray[indexPath.section];
                cell.assignModel = model;
            }
            
        }
            break;
        case 2:
        {
            if (self.yiZhuanRangArray.count) {
                HCAssignmentModel * model = self.yiZhuanRangArray[indexPath.section];
                cell.assignModel = model;
            }
            
        }
            break;
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf=  self;

    switch (self.index) {
        case 0:
        {
            HCCreditTransferCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            
            if (cell.transferButton.userInteractionEnabled) {
                HCMyInvestModel * model = self.keZhuanRangArray[indexPath.section];
                HCImmediatelyTransferController * controller = [[HCImmediatelyTransferController alloc] init];
                controller.number = model.number;
                controller.hanlderSuccessCallBack = ^(NSDecimalNumber * remainingAmount) {
                    if (remainingAmount.integerValue>0) {
                        model.amount = remainingAmount;
                        [weakSelf.keZhuanRangArray replaceObjectAtIndex:indexPath.section withObject:model];
                        [weakSelf.tableView  reloadData];
                    }else{
                        [weakSelf.keZhuanRangArray removeObject:model];
                        [weakSelf.tableView  reloadData];
                    }
                };
                [weakSelf.navigationController pushViewController:controller animated:YES];
            }else {
            
                [MBProgressHUD showText:@"该笔债权持有时间不足10天，不能转让哦~"];
                
            }
            
            
        }
            break;
        case 1:
        {
            HCAssignmentModel * model = self.zhuanRangZhongArray[indexPath.section];
            
            HCCreditTransferDetailController * detailVC = [[HCCreditTransferDetailController alloc] init];
            detailVC.number = model.number;
            
            __weak typeof(self) weakSelf =self;
            detailVC.cancelTransferCallBack = ^{
                [weakSelf.zhuanRangZhongArray removeObject:model];
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
        case 2:
        {
            HCAssignmentModel * model = self.yiZhuanRangArray[indexPath.section];
            HCCreditTransferDetailController * detailVC = [[HCCreditTransferDetailController alloc] init];
            detailVC.number = model.number;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
    }

    
}
- (NSMutableArray *)keZhuanRangArray {
    if (!_keZhuanRangArray) {
        _keZhuanRangArray = [NSMutableArray array];
    }
    return _keZhuanRangArray;
}
- (NSMutableArray *)zhuanRangZhongArray {
    if (!_zhuanRangZhongArray) {
        _zhuanRangZhongArray = [NSMutableArray array];
    }
    return _zhuanRangZhongArray;
}
- (NSMutableArray *)yiZhuanRangArray {
    if (!_yiZhuanRangArray) {
        _yiZhuanRangArray = [NSMutableArray array];
    }
    return _yiZhuanRangArray;
}

@end

