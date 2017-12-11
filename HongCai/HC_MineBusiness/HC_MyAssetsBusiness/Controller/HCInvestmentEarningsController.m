//
//  HCInvestmentEarningsController.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInvestmentEarningsController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCInvesetmentEarningCell.h"
#import "HCInvestProfitDealsApi.h"
#import "NSBundle+MyAssetsModule.h"

#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCMyDealModel.h"
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>

@interface HCInvestmentEarningsController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *dealType;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger filterType;
@end

static NSString *const cellIdentifier = @"invesetmentEarningsCell";

@implementation HCInvestmentEarningsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"投资收益" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.filterType = 8;
    self.page = 1;
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    [self loadRemoteDataWithPage:self.page filterType:self.filterType];
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadRemoteDataWithPage: ++ weakSelf.page filterType:weakSelf.filterType];
        
    }];
}

- (void)loadRemoteDataWithPage:(NSInteger)page filterType:(NSInteger)filterType {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"page"] = @(1);
    params[@"pageSize"] = @(20);
    params[@"filterType"] = @(filterType);
    
    HCInvestProfitDealsApi * api = [[HCInvestProfitDealsApi alloc] initWithParams: params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if(request.responseJSONObject) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[HCMyDealModel class] json:request.responseJSONObject[@"data"]];
            if (page==1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            self.tableView.emptyDataSetSource = self;
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (page == [request.responseJSONObject[@"totalPage"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [NSBundle myAssets_ImageWithName:@"kby_icon_zwjl_nor"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString * desc = nil;
    desc = @"暂无投资收益记录";
    
    NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    return Attrdesc;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - CGRectGetHeight(scrollView.bounds)*0.2;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HCInvesetmentEarningCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    tableView.mj_footer.hidden = self.dataArray.count==0;
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCInvesetmentEarningCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self.dataArray) {
        HCMyDealModel * model = self.dataArray[indexPath.row];
        cell.model = model;
    }
    return cell;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
