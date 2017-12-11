//
//  HCInvestmentListController.m
//  HongCai
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInvestmentListController.h"
#import "HCInvestmentCell.h"
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import "HCProjectModel.h"
#import "HCAssignmentModel.h"
#import "HCInvestmentService.h"
#import "HCCreditorTransferDetailController.h"
#import "HCInvestWebController.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCNetworkConfig.h"
#import <HCBeForcedOfflineBusiness_Category/CTMediator+HCBeForcedOfflineBusiness.h>
@interface HCInvestmentListController ()
@property (nonatomic, strong) NSMutableArray *jingXuanArray;
@property (nonatomic, strong) NSMutableArray *zunGuiArray;
@property (nonatomic, strong) NSMutableArray *zhaiQuanArray;

@property (nonatomic, assign) NSInteger page;

@end

@implementation HCInvestmentListController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self replaceFirstPageData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.tableView.estimatedRowHeight = 130;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[HCInvestmentCell class] forCellReuseIdentifier:@"InvestmentCellIdentifier"];
    self.tableView.tableFooterView = [UIView new];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [self loadNewData];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header= [HCRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [[CTMediator sharedInstance] HCBeForcedOfflineBusiness_checkTokenStatus];
        [weakSelf loadNewData];
    }];
    
    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        
        switch (weakSelf.index) {
            case 0:
            {
                [HCInvestmentService getInvestmentDataWithPage:++weakSelf.page type:5 successCallBack:^(NSArray *models, BOOL finished) {
                    [weakSelf.jingXuanArray addObjectsFromArray:models];
                    [weakSelf.tableView reloadData];
                    if (finished) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }];
            }
                
                break;
            case 1:
            {
                [HCInvestmentService getInvestmentDataWithPage:++weakSelf.page type:6 successCallBack:^(NSArray *models, BOOL finished) {
                    [weakSelf.zunGuiArray addObjectsFromArray:models];
                    [weakSelf.tableView reloadData];
                    if (finished) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }];
            }
                
                break;
            case 2:
            {
                [HCInvestmentService getAssignmentsDataWithPage:++weakSelf.page successCallBack:^(NSArray *models, BOOL finished) {
                    [weakSelf.zhaiQuanArray addObjectsFromArray:models];
                    [weakSelf.tableView reloadData];
                    if (finished) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }];
            }
        }
    }];

    
}
- (void)replaceFirstPageData {

    switch (self.index) {
        case 0:
        {
            if (self.jingXuanArray.count>=5) {
                [HCInvestmentService getInvestmentDataWithPage:1 type:5 successCallBack:^(NSArray *models, BOOL finished) {
                    [self.jingXuanArray replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:models];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                    if (finished) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }
            
            
        }
            break;
            
        case 1:
        {
            if (self.zunGuiArray.count>=5) {
                [HCInvestmentService getInvestmentDataWithPage:1 type:6 successCallBack:^(NSArray *models, BOOL finished) {
                    [self.zunGuiArray replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:models];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                    if (finished) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }
            
            
        }
            break;
        case 2:
        {
            if (self.zhaiQuanArray.count >=5) {
                [HCInvestmentService getAssignmentsDataWithPage:1 successCallBack:^(NSArray *models, BOOL finished) {
                    [self.zhaiQuanArray replaceObjectsInRange:NSMakeRange(0, 5) withObjectsFromArray:models];
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                    if (finished) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
            }
            
        }
            break;
    }


}
- (void)loadNewData {
    switch (self.index) {
        case 0:
        {
            [HCInvestmentService getInvestmentDataWithPage:self.page type:5 successCallBack:^(NSArray *models, BOOL finished) {
                [self.jingXuanArray removeAllObjects];
                [self.jingXuanArray addObjectsFromArray:models];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if (finished) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
            
        }
            break;
            
        case 1:
        {
            [HCInvestmentService getInvestmentDataWithPage:self.page type:6 successCallBack:^(NSArray *models, BOOL finished) {
                [self.zunGuiArray removeAllObjects];
                [self.zunGuiArray addObjectsFromArray:models];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if (finished) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }
            break;
        case 2:
        {
            [HCInvestmentService getAssignmentsDataWithPage:self.page successCallBack:^(NSArray *models, BOOL finished) {
                [self.zhaiQuanArray removeAllObjects];
                [self.zhaiQuanArray addObjectsFromArray:models];
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                if (finished) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }
            break;
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    switch (self.index) {
        case 0:
        {
            self.tableView.mj_footer.hidden = self.jingXuanArray.count==0;
            
            return [self.jingXuanArray count];
        }
            break;
        case 1:
        {
            self.tableView.mj_footer.hidden = self.zunGuiArray.count==0;
            
            return [self.zunGuiArray count];
        }
            break;
        case 2:
        {
            self.tableView.mj_footer.hidden = self.zhaiQuanArray.count==0;
            return [self.zhaiQuanArray count];
        }
            break;
        default:
            return 0;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.index) {
        case 0:
        {
            HCProjectSubModel * project = self.jingXuanArray[indexPath.section];
            NSString * projectUrl = [NSString stringWithFormat:@"%@project/%@",WebBaseURL,[project number]];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            HCInvestWebController * investWebVC = [[HCInvestWebController alloc] initWithAddress:projectUrl];
            investWebVC.growingAttributesPageName = @"宏财精选详情";
            investWebVC.projectNumber = [project number];
            investWebVC.webTitle = [project name];
            [self.navigationController pushViewController:investWebVC animated:YES];

        
        }
            break;
        case 1:
        {
            HCProjectSubModel * project = self.zunGuiArray[indexPath.section];
            NSString * projectUrl = [NSString stringWithFormat:@"%@project/%@",WebBaseURL,[project number]];
            self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
            HCInvestWebController * investWebVC = [[HCInvestWebController alloc] initWithAddress:projectUrl];
            investWebVC.projectNumber = [project number];
            investWebVC.growingAttributesPageName = @"宏财尊贵详情";
            investWebVC.webTitle = [project name];
            [self.navigationController pushViewController:investWebVC animated:YES];
        
        }
            break;
        case 2:
        {
        
            HCCreditorTransferDetailController * detailVC = [HCCreditorTransferDetailController new];
            detailVC.growingAttributesPageName = @"债权转让详情";
            HCAssignmentModel * model = self.zhaiQuanArray[indexPath.section];
            detailVC.model = model;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }
            break;
  
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * const cellIdentifier = @"InvestmentCellIdentifier";
    HCInvestmentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (self.index) {
        case 0:
        {
            HCProjectSubModel * mainProject = self.jingXuanArray[indexPath.section];
            cell.project =mainProject;
            cell.statusLabel.text = mainProject.typeName;
        }
            break;
        case 1:
        {
            
            HCProjectSubModel * mainProject = self.zunGuiArray[indexPath.section];
            cell.project =mainProject;
            cell.statusLabel.text = mainProject.typeName;
            //1 转让中 4 已转让
        }
            break;
        case 2:
        {
            HCAssignmentModel * assignMent = self.zhaiQuanArray[indexPath.section];
            cell.assignment =assignMent;
        }
            break;
    }
    return cell;
}


- (NSMutableArray<HCProjectModel *> *)jingXuanArray {
    if (!_jingXuanArray) {
        _jingXuanArray = [NSMutableArray array];
    }
    return _jingXuanArray;
}
- (NSMutableArray<HCProjectModel *> *)zunGuiArray {
    if (!_zunGuiArray) {
        _zunGuiArray = [NSMutableArray array];
    }
    return _zunGuiArray;
}
- (NSMutableArray *)zhaiQuanArray {
    if (!_zhaiQuanArray) {
        _zhaiQuanArray = [NSMutableArray array];
    }
    return _zhaiQuanArray;
}

@end
