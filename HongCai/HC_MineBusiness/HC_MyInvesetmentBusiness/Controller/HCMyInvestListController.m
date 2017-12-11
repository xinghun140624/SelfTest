//
//  HCMyInvestListController.m
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import "HCMyInvestListController.h"
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCMyInvesetmentFactoryCell.h"
#import "HCUserInvestStatApi.h"
#import "HCMyInvestService.h"
#import "NSBundle+HCMyInvesetmentModule.h"
#import "HCMyInvestDetailController.h"
#import "HCMyInvestModel.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>

@interface HCMyInvestListController ()<DZNEmptyDataSetSource>
@property (nonatomic, strong) NSMutableArray *chiyouArray;
@property (nonatomic, strong) NSMutableArray *jiesuanArray;
@property (nonatomic, assign) NSInteger page;

@end
static NSString * const cellIdentifier = @"HCCreditTransferCell";

@implementation HCMyInvestListController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.tableView.estimatedRowHeight = 130;
    [self.tableView registerClass:[HCMyInvesetmentFactoryCell class] forCellReuseIdentifier:cellIdentifier];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    switch (self.index) {
        case 0: //持有中
        {
            [HCMyInvestService loadMyInvestDataWithPage:self.page type:self.type status:1 success:^(NSArray *models, BOOL isFinish) {
                [self.chiyouArray removeAllObjects];
                [self.chiyouArray addObjectsFromArray:models];
                if (isFinish) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.emptyDataSetSource = self;
                [self.tableView reloadData];
                [self.tableView reloadEmptyDataSet];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
    
        }
            break;
            
        case 1://已结算
        {
            [HCMyInvestService loadMyInvestDataWithPage:self.page type:self.type status:2 success:^(NSArray *models, BOOL isFinish) {
                [self.jiesuanArray removeAllObjects];
                [self.jiesuanArray addObjectsFromArray:models];
                if (isFinish) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                self.tableView.emptyDataSetSource = self;
                [self.tableView reloadData];
                [self.tableView reloadEmptyDataSet];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
            
        }
            break;
        default:
            break;
    }

    __weak typeof(self) weakSelf = self;

    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        switch (weakSelf.index) {
            case 0:
            {
                [HCMyInvestService loadMyInvestDataWithPage:++weakSelf.page type:weakSelf.type status:1 success:^(NSArray *models, BOOL isFinish) {
                    [weakSelf.chiyouArray addObjectsFromArray:models];
                    [weakSelf.tableView reloadData];
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
                [HCMyInvestService loadMyInvestDataWithPage:++weakSelf.page type:weakSelf.type status:2 success:^(NSArray *models, BOOL isFinish) {
                    [weakSelf.jiesuanArray addObjectsFromArray:models];
                    [weakSelf.tableView reloadData];
                    if (isFinish) {
                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [weakSelf.tableView.mj_footer endRefreshing];
                    }
                }];

            }
                
                break;
        }

        
    }];
    
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [NSBundle myInvesetment_ImageWithName:@"kby_icon_zwjl_nor"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString * desc = @"暂无数据";
    NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    
    return Attrdesc;
    
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    CGFloat height = CGRectGetHeight(scrollView.frame);

    return -height*0.2;
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
            self.tableView.mj_footer.hidden = self.chiyouArray.count==0;
            
            return [self.chiyouArray count];
        }
            break;
        case 1:
        {
            self.tableView.mj_footer.hidden = self.jiesuanArray.count==0;
            
            return [self.jiesuanArray count];
        }
            break;

        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMyInvesetmentFactoryCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    switch (self.index) {
        case 0:
        {
            if (self.chiyouArray.count) {
                cell.model = self.chiyouArray[indexPath.section]; 
            }
            
            
        }
            break;
        case 1:
        {
            if (self.jiesuanArray.count) {
                cell.model = self.jiesuanArray[indexPath.section];
                cell.middleLabel.text = @"总收益";
                
            }
            
        }
            break;
       
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.index) {
        case 0:
        {
            HCMyInvestModel * model = self.chiyouArray[indexPath.section];
            HCMyInvestDetailController * detailVC = [[HCMyInvestDetailController alloc] init];
            detailVC.number = model.number;
            [self.navigationController pushViewController:detailVC animated:YES];
            
            
        }
            break;
        case 1:
        {
            HCMyInvestModel * model = self.jiesuanArray[indexPath.section];
            HCMyInvestDetailController * detailVC = [[HCMyInvestDetailController alloc] init];
            detailVC.number = model.number;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
   
    }
    
    
}
- (NSMutableArray *)chiyouArray {
    if (!_chiyouArray) {
        _chiyouArray = [NSMutableArray array];
    }
    return _chiyouArray;
}
- (NSMutableArray *)jiesuanArray {
    if (!_jiesuanArray) {
        _jiesuanArray = [NSMutableArray array];
    }
    return _jiesuanArray;
}


@end

