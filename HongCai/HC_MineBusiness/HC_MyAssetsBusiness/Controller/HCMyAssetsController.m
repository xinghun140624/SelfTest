//
//  HCMyAssetsController.m
//  HC_MyAssetsBuiness
//
//  Created by Candy on 2017/6/26.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyAssetsController.h"
#import <HMSegmentedControl/HMSegmentedControl.h>
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <SCChart/SCChart.h>
#import "HCMyAssetsPiedCell.h"
#import "HCMyAssetsEarningsCell.h"
#import "HCMyAssetsShouYiCell.h"
#import "HCMyAssetsBalanceCell.h"
#import "HCMyAssetsInvesetmentCell.h"
#import "HCActivityEarningsController.h"
#import "HCInvestmentEarningsController.h"
#import "HCPrivilegeEarningsController.h"
#import "NSBundle+MyAssetsModule.h"
#import "HCAccountModel.h"
#import "HCPrivilegedCapitalsApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCMeService.h"
@interface HCMyAssetsController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (nonatomic, strong) UITableView *tableView;
//利息
@property (nonatomic, strong) NSArray *intersetArray;
@property (nonatomic, strong) NSArray *firstArray;
@property (nonatomic, strong) NSArray *leijiProfitArray;

@property (nonatomic, strong) NSArray *intersetColorArray;

//收益
@property (nonatomic, strong) NSArray *earningsArray;
@property (nonatomic, strong) NSArray *earningsColorArray;
@property (nonatomic, strong) NSDecimalNumber * tequanShouyiAmount;
@property (nonatomic, strong) NSDecimalNumber * tequanShouyiProfit;



@end
static NSString *const cellChartViewIdentifier = @"cellChartViewIdentifier";
static NSString *const cellMyAssetsEarningsIdentifier = @"cellMyAssetsEarningsIdentifier";
static NSString *const cellMyAssetsEarningsIdentifier2 = @"cellMyAssetsEarningsIdentifier2";
static NSString *const cellMyAssetsEarningsIdentifier3 = @"cellMyAssetsEarningsIdentifier3";

static NSString *const cellMyAssetsBalanceCell = @"cellMyAssetsBalanceCell";
static NSString *const cellMyAssetsInvesetmentCell = @"cellMyAssetsInvesetmentCell";

@implementation HCMyAssetsController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"资产总览" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentedControl];
    self.segmentedControl.selectedSegmentIndex = self.selectIndex;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(CGRectGetHeight(self.segmentedControl.frame), 0, 0, 0));
    }];
    
    if (self.model) {
        [self loadData];
    }else {
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        
        [HCMeService getUserAccountInformationWithToken:user[@"token"] success:^(HCAccountModel *model) {
            self.model = model;
            [self loadData];
        }];

    }
    
    
}
- (void)loadData {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    
    
    HCPrivilegedCapitalsApi * api = [[HCPrivilegedCapitalsApi alloc] initWithParams:params];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            self.tequanShouyiProfit = request.responseJSONObject[@"profit"];
            self.tequanShouyiAmount = request.responseJSONObject[@"amount"];
            double decimail = [self.model.receivedProfit doubleValue]-[self.model.activityProfit doubleValue];
            double  investProfit = decimail - [self.tequanShouyiProfit doubleValue];
            self.leijiProfitArray = @[@(investProfit),self.tequanShouyiProfit,self.model.activityProfit];
            if (self.selectIndex==1) {
                [self.tableView reloadData];
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
- (void)setModel:(HCAccountModel *)model {
    _model = model;
    if (model) {
        self.firstArray = @[[model.waitingCapital decimalNumberByAdding:model.freezeCapital],model.waitingProfit,model.balance];

    }
    
}


- (void)segmentedControlAction:(NSInteger )index {
    [self.tableView reloadData];
}


- (HMSegmentedControl*)segmentedControl {
    if (!_segmentedControl){
        NSArray * titles = @[@"总资产",@"已收收益",@"可用余额"];
        _segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:titles];
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
        _segmentedControl.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0x666666"]};
        _segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xff611d"]};
        
        __weak typeof(self) weakSelf = self;
        _segmentedControl.indexChangeBlock = ^(NSInteger index) {
            [weakSelf segmentedControlAction:index];
        };
        _segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, 55);
    }
    return _segmentedControl;
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
        [_tableView registerClass:[HCMyAssetsPiedCell class] forCellReuseIdentifier:cellChartViewIdentifier];
        [_tableView registerClass:[HCMyAssetsShouYiCell class] forCellReuseIdentifier:cellMyAssetsEarningsIdentifier3];

        [_tableView registerClass:[HCMyAssetsEarningsCell class] forCellReuseIdentifier:cellMyAssetsEarningsIdentifier];
        [_tableView registerClass:[HCMyAssetsEarningsCell class] forCellReuseIdentifier:cellMyAssetsEarningsIdentifier2];

        [_tableView registerClass:[HCMyAssetsBalanceCell class] forCellReuseIdentifier:cellMyAssetsBalanceCell];
        [_tableView registerClass:[HCMyAssetsInvesetmentCell class] forCellReuseIdentifier:cellMyAssetsInvesetmentCell];


    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        case 1:
            return 4;
            break;
        case 2:
            return 2;
            break;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        case 1:
            switch (indexPath.row) {
                case 0:
                    return 260;
                    break;
                    
                default:
                    return 55.f;
                    break;
            }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UIImage * bgImage = [NSBundle myAssets_ImageWithName:@"zhzl_ibg_kyye_nor"];
                    CGFloat height = SCREEN_WIDTH * bgImage.size.height/bgImage.size.width;
                    return height+30;
                }
                    break;
                    
                default:
                    return 255.f;
                    break;
            }
            break;
            
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
            if (indexPath.row==0) {
                HCMyAssetsPiedCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellChartViewIdentifier];
                if (self.model) {
                    cell.model = self.model;
                }
                return cell;
            }else{
                HCMyAssetsEarningsCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellMyAssetsEarningsIdentifier];
                cell.titleLabel.text = self.intersetArray[indexPath.row-1];
                cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.firstArray[indexPath.row-1] doubleValue]];
            
                cell.iconView.backgroundColor = [UIColor colorWithHexString:self.intersetColorArray[indexPath.row - 1]];
                
                return cell;
                
            }
            break;
        case 1://已收收益
            if (indexPath.row==0) {
                HCMyAssetsShouYiCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellMyAssetsEarningsIdentifier3];
                if (self.model && self.tequanShouyiAmount) {
                    cell.tequanShouyiProfit =  self.tequanShouyiProfit;
                    cell.model = self.model;

                }
                return cell;
            }else{
                HCMyAssetsEarningsCell *  cell = [tableView dequeueReusableCellWithIdentifier:cellMyAssetsEarningsIdentifier2];
                if (self.earningsArray) {
                    cell.titleLabel.text = self.earningsArray[indexPath.row-1];
                    cell.iconView.backgroundColor = [UIColor colorWithHexString:self.earningsColorArray[indexPath.row - 1]];
                    if (fabs([self.leijiProfitArray[indexPath.row-1] doubleValue])>=0.01) {
                        cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.leijiProfitArray[indexPath.row-1] doubleValue]];
                    }else{
                        cell.descLabel.text = @"0.00元";
                    }
                }
                return cell;
                
            }
        case 2:{
            if (indexPath.row==0) {
                HCMyAssetsBalanceCell * cell = [tableView dequeueReusableCellWithIdentifier:cellMyAssetsBalanceCell];
                if (self.model) {
                    cell.usefulBalanceLabel.text = [NSString stringWithFormat:@"%.2f元",[self.model.balance doubleValue]];
                }
                return cell;
            }else {
                HCMyAssetsInvesetmentCell * cell = [tableView dequeueReusableCellWithIdentifier:cellMyAssetsInvesetmentCell];
            
                return cell;
            }
        
        
        }

    }
    return [UITableViewCell new];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    switch (self.segmentedControl.selectedSegmentIndex) {
//        case 1:
//        {
//            switch (indexPath.row) {
//                case 1:
//                    //投资收益
//                {
//                    HCInvestmentEarningsController * invesetmentVC = [[HCInvestmentEarningsController alloc] init];
//                    [self.navigationController pushViewController:invesetmentVC animated:YES];
//                }
//                    break;
//                case 2:
//                    //特权本金收益
//                {
//                    HCPrivilegeEarningsController * privilegeEarningVC = [[HCPrivilegeEarningsController alloc] init];
//                    [self.navigationController pushViewController:privilegeEarningVC animated:YES];
//                }
//                    break;
//                case 3:
//                    //活动收益
//                {
//                    HCActivityEarningsController * activityVC = [[HCActivityEarningsController alloc] init];
//                    [self.navigationController pushViewController:activityVC animated:YES];
//                }
//                    break;
//
//            }
//        }
//            break;
//  
//    }
//}


- (NSArray *)intersetArray {
    if (!_intersetArray) {
        _intersetArray = @[@"待收本金",@"待收利息",@"可用余额"];
    }
    return _intersetArray;
}
- (NSArray *)intersetColorArray {
    if (!_intersetColorArray) {
        _intersetColorArray = @[@"0x478bc5",@"0x3a6cab",@"0x7abff3"];
    }
    return _intersetColorArray;
}
- (NSArray *)earningsArray {
    if (!_earningsArray) {
        _earningsArray = @[@"投资收益",@"特权本金收益",@"活动收益"];
    }
    return _earningsArray;
}
- (NSArray *)earningsColorArray {
    if (!_earningsColorArray) {
        _earningsColorArray = @[@"0xf2784d",@"0xf4d03f",@"0xf5b34f"];
    }
    return _earningsColorArray;
}
@end
