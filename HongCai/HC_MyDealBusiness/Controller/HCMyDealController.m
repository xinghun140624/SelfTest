//
//  HCMyDealController.m
//  HC_MyDealBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyDealController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCMyDealCell.h"
#import <Masonry/Masonry.h>
#import "HCMyDealApi.h"
#import "HCMyDealModel.h"
#import "HCMyDealTypeApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <TYAlertController/TYAlertController.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HC_RefreshBusiness/HCRefreshBusiness.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "HCMyDealFilterView.h"
#import "NSBundle+HCMyDealModule.h"
@interface HCMyDealController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *dealType;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger filterType;
@property (nonatomic, strong) HCMyDealFilterView * filterView;
@property (nonatomic, strong) UIView * backgroundView;
@end
static NSString * cellIdentifier = @"HCMyDealCell";
@implementation HCMyDealController
- (UIView *)filterView {
    if (!_filterView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat itemHeight =  width/3.1*82/206.0;
        _filterView = [[HCMyDealFilterView alloc] initWithFrame:CGRectMake(0, -(itemHeight*3+20), CGRectGetWidth(self.view.frame), itemHeight*3+20)];
        _filterView.backgroundColor = [UIColor whiteColor];
        __weak typeof(self) weakeSelf = self;
        __weak typeof(HCMyDealFilterView *) weakView = _filterView;
        
        _filterView.selectCallback = ^(NSString *buttonTitles) {
            weakeSelf.page = 1;
            if ([buttonTitles isEqualToString:@"全部"]) {
                weakeSelf.filterType = 0;
                
                [weakeSelf loadRemoteDataWithPage:weakeSelf.page filterType:weakeSelf.filterType];
            }else if ([buttonTitles isEqualToString:@"充值"]){
                weakeSelf.filterType = 1;
                [weakeSelf loadRemoteDataWithPage:weakeSelf.page filterType:weakeSelf.filterType];

            }else if ([buttonTitles isEqualToString:@"提现"]){
                weakeSelf.filterType = 2;
                [weakeSelf loadRemoteDataWithPage:weakeSelf.page filterType:weakeSelf.filterType];
                
            }else if ([buttonTitles isEqualToString:@"投资"]){
                weakeSelf.filterType = 3;
                [weakeSelf loadRemoteDataWithPage:weakeSelf.page filterType:weakeSelf.filterType];
                
            }else if ([buttonTitles isEqualToString:@"回款"]){
                weakeSelf.filterType = 4;
                [weakeSelf loadRemoteDataWithPage:weakeSelf.page filterType:weakeSelf.filterType];
                
            }else if ([buttonTitles isEqualToString:@"奖励"]){
                weakeSelf.filterType = 5;
                [weakeSelf loadRemoteDataWithPage:weakeSelf.page filterType:weakeSelf.filterType];
                
            }else if ([buttonTitles isEqualToString:@"其他"]){
                weakeSelf.filterType = 6;
                [weakeSelf loadRemoteDataWithPage:weakeSelf.page filterType:weakeSelf.filterType];
                
            }

            [UIView  animateWithDuration:0.4 animations:^{
                weakeSelf.tableView.scrollEnabled = YES;
                weakeSelf.navigationItem.rightBarButtonItem.enabled = YES;
                weakeSelf.backgroundView.backgroundColor = [UIColor clearColor];
                [weakeSelf.backgroundView removeFromSuperview];
               weakView.frame = CGRectMake(0, -(itemHeight*3+20), CGRectGetWidth(weakeSelf.view.frame), itemHeight*3+20);
            }];
        };
        [_filterView.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
    return _filterView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = 1;
    self.filterType = 0;
    self.view.backgroundColor =  [UIColor colorWithHexString:@"0xefeef4"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"资金流水" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    [self loadDealType:^(BOOL success) {
        if (success) {
            [self loadRemoteDataWithPage:self.page filterType:self.filterType];
        }
        
    }];
    __weak typeof(self) weakSelf = self;

    self.tableView.mj_footer = [HCRefreshFooter footerWithRefreshingBlock:^{
        ++weakSelf.page;
        [weakSelf loadRemoteDataWithPage:weakSelf.page filterType:weakSelf.filterType];
    }];
  
    [self setupRightBarItem];
    [self.view addSubview:self.filterView];

}

- (void)setupRightBarItem {
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(selectBarClick)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}
- (void)loadDealType:(void(^)(BOOL success))success {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    HCMyDealTypeApi * api = [[HCMyDealTypeApi alloc] initWithParams: params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if(request.responseJSONObject) {
            self.dealType = request.responseJSONObject;
            if (success) {
                success(YES);
            }
        }else{
            if (success) {
                success(NO);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (success) {
            success(NO);
        }
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];

        }
    }];

}
- (void)selectBarClick {
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.tableView.frame];
    self.tableView.scrollEnabled = NO;
     self.backgroundView .backgroundColor = [UIColor clearColor];
    [self.tableView insertSubview: self.backgroundView  belowSubview:self.filterView];
    
    [UIView  animateWithDuration:0.4 animations:^{
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [ self.backgroundView  setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        self.filterView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.filterView.frame));
    }];
    
}



- (void)loadRemoteDataWithPage:(NSInteger)page filterType:(NSInteger)filterType {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"page"] = @(page);
    params[@"pageSize"] = @(20);
    params[@"filterType"] = filterType>0?@(filterType):nil;
    HCMyDealApi * api = [[HCMyDealApi alloc] initWithParams: params];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if(request.responseJSONObject) {
            NSArray *array = [NSArray yy_modelArrayWithClass:[HCMyDealModel class] json:request.responseJSONObject[@"data"]];
            if (page==1) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
     
            [self.tableView reloadData];
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;

            [self.tableView reloadEmptyDataSet];
            [self.tableView.mj_header endRefreshing];
            if (page == [request.responseJSONObject[@"totalPage"] integerValue]) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
            
        }
    }];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
   UITabBarController * tabVC = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabVC.selectedIndex = 1;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [NSBundle myDeal_ImageWithName:@"kby_icon_zjls_nor"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString * desc = @"";
    switch (self.filterType) {
        case 0:
            desc = @"您还没有资金流水记录哦～";
            break;
        case 1:
            desc = @"您还没有充值记录哦～";
            break;
        case 2:
            desc = @"您还没有提现记录哦～";
            break;
        case 3:
            desc = @"您还没有投资记录哦～";
            break;
        case 4:
            desc = @"您还没有回款记录哦～";
            break;
        case 5:
            desc = @"您还没有奖励记录哦～";
            break;
        case 6:
            desc = @"您还没有其他记录哦～";
            break;
    }
    
    NSAttributedString * Attrdesc = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]}];
    
    return Attrdesc;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.filterType==0) {
        return [[NSAttributedString alloc] initWithString:@"去投资" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor]}];
 
    }
    return nil;
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    if (self.filterType==0) {
        UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
        UIEdgeInsets rectInsets = UIEdgeInsetsZero;
        
        capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
        rectInsets = UIEdgeInsetsMake(-10, 0, 0.0, 0);
        UIImage * image = [NSBundle myDeal_ImageWithName:@"Registration_btn_nor"];
        
        
        return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];

    }
    return nil;
    
}
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
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
        [_tableView registerClass:[HCMyDealCell class] forCellReuseIdentifier:cellIdentifier];
        _tableView.estimatedRowHeight = 60;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden =self.dataArray.count==0;
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMyDealCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (indexPath.row%2==0) {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithHexString:@"0xf8f9fb"];
    }
    if (self.dataArray.count && self.dealType) {
        HCMyDealModel * model = self.dataArray[indexPath.row];
        model.dealTypeDesc = self.dealType[model.type.stringValue];
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
