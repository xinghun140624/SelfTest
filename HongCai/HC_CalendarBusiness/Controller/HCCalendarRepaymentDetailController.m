//
//  HCCalendarRepaymentDetailController.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/29.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCalendarRepaymentDetailController.h"
#import "HCRepaymentDetailTopCell.h"
#import "HCRepaymentDetaiCell.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "HCCalendarRepaymentDetailsApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "HCCalendarRepaymentDetailModel.h"
#import "NSBundle+HCCalendarModule.h"
#import "HCMyInvestDetailController.h"
@interface HCCalendarRepaymentDetailController ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * topDataArray;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) HCCalendarRepaymentDetailModel * model;
@end

@implementation HCCalendarRepaymentDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString * title = nil;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM月dd日";
    if (self.type==1) {
        self.topDataArray = @[@"当日回款总额",@"回款本金",@"回款利息"];
        
        title = [NSString stringWithFormat:@"%@回款总额",[formatter stringFromDate:self.selectDate]];
        
    }else {
        title = [NSString stringWithFormat:@"%@待收回款",[formatter stringFromDate:self.selectDate]];
        
        self.topDataArray = @[@"当日待收回款",@"本金",@"利息"];
    }
    titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:[UINavigationBar appearance].titleTextAttributes];
    
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    HCCalendarRepaymentDetailsApi * api = nil;
    if (self.type==1) {
        NSTimeInterval date = [self.selectDate timeIntervalSince1970]*1000;
        api = [[HCCalendarRepaymentDetailsApi alloc] initWithToken:user[@"token"] userId:[user[@"id"] intValue] type:self.type startTime:date endTime:date];
    }else {
        NSTimeInterval date = [self.selectDate timeIntervalSince1970]*1000;
        api = [[HCCalendarRepaymentDetailsApi alloc] initWithToken:user[@"token"] userId:[user[@"id"] intValue] type:self.type startTime:date endTime:date];
    }
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (request.responseJSONObject) {
            self.tableView.emptyDataSetSource = self;
            HCCalendarRepaymentDetailModel * model = [HCCalendarRepaymentDetailModel yy_modelWithJSON:request.responseObject];
            self.model = model;
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
}
#pragma -mark DZNEmptyDataSetSource

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:@"暂无数据" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    return Attrdesc;
    
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [NSBundle calendar_ImageWithName:@"kby_icon_zwjl_nor"];
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    CGFloat height = CGRectGetHeight(scrollView.frame);
    return -height*0.2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        HCRepaymentDetailTopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"topCell"];
        cell.titleLabel.text = self.topDataArray[indexPath.row];
        switch (indexPath.row) {
            case 0:
            {
                if (self.model) {
                    cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.type==1?self.model.anticipateAmount.floatValue:self.model.waitingAmount.floatValue];
                }else{
                    cell.moneyLabel.text = @"0.00元";
                }
            }
                break;
            case 1:
            {
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.model?self.model.principalAmount.floatValue:0.00];
            }
                break;
            case 2:
            {
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.model?self.model.interestAmount.floatValue:0.00];
            }
                break;
        }
        return cell;
    }
    HCRepaymentDetaiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
    if (self.model.details.count) {
        cell.model = self.model.details[indexPath.row];
        cell.type = self.type;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return;
    }
    HCCalendarDetailVoModel * model = self.model.details[indexPath.row];

    HCMyInvestDetailController * detailVC = [[HCMyInvestDetailController alloc] init];
    detailVC.number = model.creditRightNum;
    [self.navigationController pushViewController:detailVC animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.details.count==0) {
        return 0;
    }
    return section==0?3:self.model.details.count;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.separatorStyle=  UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [_tableView registerClass:[HCRepaymentDetailTopCell class] forCellReuseIdentifier:@"topCell"];
        [_tableView registerClass:[HCRepaymentDetaiCell class] forCellReuseIdentifier:@"detailCell"];
        
    }
    return _tableView;
}
@end
