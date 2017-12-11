//
//  HCMessageListController.m
//  HongCai
//
//  Created by Candy on 2017/7/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMessageListController.h"
// API
#import "HCNoticesApi.h"
#import "HCUserMessagesApi.h"



// Views
#import "HCUserMessageCell.h"
#import "HCNoticeCell.h"


#import "HCUserMessageModel.h"
#import "HCNoticeModel.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import "NSBundle+HCMessageModule.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
@interface HCMessageListController ()<DZNEmptyDataSetSource>
@property (nonatomic, strong) NSMutableArray *userMessageArray;
@property (nonatomic, strong) NSMutableArray *noticeArray;
@property (nonatomic, assign) NSInteger page;

@end
NSString *const messageCellIdentifier = @"HCUserMessageCell";
NSString *const noticeCellIdentifier = @"HCNoticeCell";
@implementation HCMessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[HCUserMessageCell class] forCellReuseIdentifier:messageCellIdentifier];
    [self.tableView registerClass:[HCNoticeCell class] forCellReuseIdentifier:noticeCellIdentifier];
    self.page = 1;
    [MBProgressHUD showFullScreenLoadingView:self.view];
    switch (self.index) {
        case 0:
        {
            [self loadNoticeDataWithPage:self.page];
        }
            break;
        case 1:
        {
            [self loadMessageDataWithPage:self.page];

        }
            break;
    }
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        switch (weakSelf.index) {
            case 0:
            {
                [weakSelf loadNoticeDataWithPage:++weakSelf.page];
            }
                break;
            case 1:
            {
                [weakSelf loadMessageDataWithPage:++weakSelf.page];
            }
                break;
        }
    }];
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [NSBundle message_ImageWithName:@"kby_icon_zwjl_nor"];
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

- (void)loadMessageDataWithPage:(NSInteger)page {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"]= @(page);
    params[@"pageSize"] = @(10);
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (!user) {
        
        self.tableView.emptyDataSetSource = self;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.userMessageArray removeAllObjects];
        [self.tableView reloadData];
        return;
    }
    
    HCUserMessagesApi * api = [[HCUserMessagesApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            NSArray * array =  [NSArray yy_modelArrayWithClass:[HCUserMessageModel class] json:request.responseJSONObject[@"data"]];
            self.tableView.emptyDataSetSource = self;
            if (array.count) {
                [self.userMessageArray addObjectsFromArray:array];
            }
            
            if (page== [request.responseJSONObject[@"totalPage"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
            }else{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}
- (void)loadNoticeDataWithPage:(NSInteger)page {
    HCNoticesApi * api = [[HCNoticesApi alloc] initWithPage:page pageSize:10];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if ( request.responseJSONObject) {
            self.tableView.emptyDataSetSource = self;
            NSArray * array =  [NSArray yy_modelArrayWithClass:[HCNoticeModel class] json:request.responseJSONObject[@"data"]];
            if (array.count) {
                [self.noticeArray addObjectsFromArray:array];
            }
            if (page== [request.responseJSONObject[@"totalPage"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.tableView reloadData];
            }else{
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.index==0) {
        self.tableView.mj_footer.hidden = self.noticeArray.count==0;
        return self.noticeArray.count;
    }
    self.tableView.mj_footer.hidden = self.userMessageArray.count==0;

    return self.userMessageArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section  {
    return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.index == 0) {
        HCNoticeCell * cell = [tableView dequeueReusableCellWithIdentifier:noticeCellIdentifier];
        if (self.noticeArray.count) {
            HCNoticeModel * model = self.noticeArray[indexPath.section];
            cell.model = model;
        }
        return cell;
    }else{
        HCUserMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:messageCellIdentifier];
        if (self.userMessageArray.count) {
            HCUserMessageModel * model = self.userMessageArray[indexPath.section];
            cell.model = model;
        }
        return cell;
    }
    
}



- (NSMutableArray *)userMessageArray {
    if (!_userMessageArray) {
        _userMessageArray = [NSMutableArray array];
    }
    return _userMessageArray;
}

- (NSMutableArray *)noticeArray {
    if (!_noticeArray) {
        _noticeArray = [NSMutableArray array];
    }
    return _noticeArray;
}

@end
