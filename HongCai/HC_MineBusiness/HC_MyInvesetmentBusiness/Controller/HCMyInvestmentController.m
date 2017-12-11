
//
//  HCMyInvestmentController.m
//  HongCai
//
//  Created by Candy on 2017/6/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyInvestmentController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCMyInvestmentCell.h"
#import "NSBundle+HCMyInvesetmentModule.h"
#import "HCMyInvesetmentFactoryController.h"
#import "HCUserInvestStatApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "HCMyInvestHeaderView.h"
@interface HCMyInvestmentController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) HCMyInvestHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataArray;

@end
static NSString * const myInvestmentCellIdentifier = @"myInvestmentCellIdentifier";

@implementation HCMyInvestmentController


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"我的投资" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(self.view);
    }];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadData];
    
}
- (void)loadData {
    NSDictionary *user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    HCUserInvestStatApi * api = [[HCUserInvestStatApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (request.responseObject) {
            NSArray * array = (NSArray *)request.responseJSONObject;
            if (array.count==0) {
                self.headerView.statusLabel.text = @"0.00";
                [self.tableView reloadData];
                [self.headerView.chartView strokeChart];
            }else {
                __block NSInteger totalInvestAmount = 0;
                [array enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.allKeys containsObject:@"creditRightType"]) {
                        switch ([obj[@"creditRightType"] integerValue]) {
                            case 6:
                            {
                                NSMutableDictionary *data = [NSMutableDictionary dictionary];
                                data[@"type"] = @(6);
                                data[@"amount"] = obj[@"totalInvestAmount"];
                                [self.dataArray replaceObjectAtIndex:2 withObject:data];
                                totalInvestAmount += [obj[@"totalInvestAmount"] integerValue];
                            }
                                break;
                            case 7:
                            {
                                NSMutableDictionary *data = [NSMutableDictionary dictionary];
                                data[@"type"] = @(7);
                                data[@"amount"] = obj[@"totalInvestAmount"];
                                [self.dataArray replaceObjectAtIndex:0 withObject:data];
                                totalInvestAmount += [obj[@"totalInvestAmount"] integerValue];
                            }
                                break;
                            case 8:
                            {
                                NSMutableDictionary *data = [NSMutableDictionary dictionary];
                                data[@"type"] = @(8);
                                data[@"amount"] = obj[@"totalInvestAmount"];
                                [self.dataArray replaceObjectAtIndex:1 withObject:data];
                                totalInvestAmount += [obj[@"totalInvestAmount"] integerValue];
                            }
                                break;
                        }
                    }
                }];
                self.headerView.statusLabel.text = [NSString stringWithFormat:@"%.2f",totalInvestAmount*1.0];

                [self.tableView reloadData];
                
                NSMutableArray * tempArray = [NSMutableArray array];
                [self.dataArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [tempArray addObject:@([obj[@"amount"] floatValue])];
                }];
                [self.headerView.chartView updateChartByNumbers:tempArray];
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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HCMyInvestmentCell class] forCellReuseIdentifier:myInvestmentCellIdentifier];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableHeaderView = self.headerView;
        
        UIView * footerView = [UIView new];
        footerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 50);
        footerView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        _tableView.tableFooterView= footerView;
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?CGFLOAT_MIN:15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMyInvestmentCell * cell = [tableView dequeueReusableCellWithIdentifier:myInvestmentCellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = self.titleArray[indexPath.section];
    
    
    NSInteger amount =  [self.dataArray[indexPath.section][@"amount"] integerValue];
    if (amount==0) {
        cell.amountLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }else{
        cell.amountLabel.textColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    cell.amountLabel.text = [NSString stringWithFormat:@"%.2f元",amount*1.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMyInvesetmentFactoryController * controller = [HCMyInvesetmentFactoryController new];
    switch (indexPath.section) {
        case 0:
        {
            controller.type = 7;

        }
            break;
        case 1:
        {
            controller.type = 8;
        }
            break;
        case 2:
        {
            controller.type = 6;
        }
            break;
    }
    [self.navigationController pushViewController:controller animated:YES];
}
- (HCMyInvestHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[HCMyInvestHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 280)];
        
    }
    return _headerView;

}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"宏财精选",@"宏财尊贵",@"债权转让"];
    }
    return _titleArray;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [@[@{@"type":@"7",@"amount":[NSDecimalNumber decimalNumberWithString:@"0.00"]},
                        @{@"type":@"8",@"amount":[NSDecimalNumber decimalNumberWithString:@"0.00"]},
                        @{@"type":@"6",@"amount":[NSDecimalNumber decimalNumberWithString:@"0.00"]}] mutableCopy];
    }
    return _dataArray;
}
@end
