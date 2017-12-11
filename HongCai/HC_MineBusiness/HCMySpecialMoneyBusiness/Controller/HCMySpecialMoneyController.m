//
//  HCMySpecialMoneyController.m
//  HongCai
//
//  Created by Candy on 2017/7/15.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMySpecialMoneyController.h"
#import "HCSpecialMoneyHeaderView.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMySpecialMoneyCell.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "HCPrivilegedCapitalsApi.h"
#import "HCPrivilegedCapitalDetailApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCMyPrivilegedCapitalModel.h"
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
@interface HCMySpecialMoneyController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) HCSpecialMoneyHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, assign) NSInteger page;
@end


static NSString * const cellIdentifier = @"HCMySpecialMoneyCell";

@implementation HCMySpecialMoneyController
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"特权本金" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self requestHeaderViewData];
    self.page = 1;
    [self requestDataWithPage:self.page];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf requestDataWithPage:++weakSelf.page];
    }];
}
- (void)requestDataWithPage:(NSInteger)page {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"page"] = @(page);
    params[@"pageSize"] = @(10);
    HCPrivilegedCapitalDetailApi * api = [[HCPrivilegedCapitalDetailApi alloc] initWithParams:params];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[HCMyPrivilegedCapitalModel class] json:request.responseJSONObject[@"data"]];
            if (array.count) {
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];
            }
            if (self.page == [request.responseJSONObject[@"totalPage"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (void)requestHeaderViewData {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    HCPrivilegedCapitalsApi * api = [[HCPrivilegedCapitalsApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            self.headerView.cumulativeMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[request.responseJSONObject[@"amount"] doubleValue]];
            self.headerView.userfulMoneyLabel.text = [NSString stringWithFormat:@"%.2f",[request.responseJSONObject[@"profit"] doubleValue]];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        
    }];

}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString * desc = @"您还没有特权本金哦～";
    NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    return Attrdesc;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"kby_icon_tqbj_nor"];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.mj_footer.hidden = self.dataArray.count==0;
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HCMySpecialMoneyCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self.dataArray.count) {
        cell.model = self.dataArray[indexPath.section];
    }
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 100;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableHeaderView = self.headerView;
        _tableView.emptyDataSetSource = self;
        [_tableView registerClass:[HCMySpecialMoneyCell class] forCellReuseIdentifier:cellIdentifier];
        
    }
    return _tableView;
}
- (HCSpecialMoneyHeaderView *)headerView {
    if (!_headerView) {
        UIImage * headerImage = [UIImage imageNamed:@"wdtqbj_bg_nor"];
        _headerView= [[HCSpecialMoneyHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds)*headerImage.size.height/headerImage.size.width)];
    }
    return _headerView;
}
@end
