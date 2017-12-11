//
//  HCMyInvestDetailController.m
//  HongCai
//
//  Created by Candy on 2017/7/17.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMyInvestDetailController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import "NSBundle+HCMyInvesetmentModule.h"
#import "HCMyInvestDetailListModel.h"
#import "HCMyInvestDetailCreditRightBillsApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCMyInvestCreditDetailApi.h"
#import "HCTimeTool.h"
#import "HCUserCreditRightDetailModel.h"
#import "HCInvestWebController.h"
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCTimeTool.h"
#import "HCNetworkConfig.h"
#import <TYAlertController/TYAlertView.h>
#import <TYAlertController/UIView+TYAlertView.h>
@interface HCMyInvestDetailHeaderView : UIView

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * projectOriginalButton;
@property (nonatomic, strong) UILabel * rateLabel;
@property (nonatomic, strong) UILabel * projectDayLabel;
@property (nonatomic, strong) UILabel * leftLabel;
@property (nonatomic, strong) UILabel * rightLabel;

@end

@implementation HCMyInvestDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rateLabel];
        [self addSubview:self.projectOriginalButton];
        [self addSubview:self.projectDayLabel];
        [self addSubview:self.leftLabel];
        [self addSubview:self.rightLabel];
        
        [self layout_Masonry];
    }
    return self;
}
- (void)layout_Masonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.f);
        make.centerX.mas_equalTo(self);
    }];
    [self.projectOriginalButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10.f);
        make.centerX.mas_equalTo(self.titleLabel);
        self.projectOriginalButton.layer.cornerRadius = 12.5f;
        make.size.mas_equalTo(CGSizeMake(80, 25));
    }];
    [self.rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0);
        make.top.mas_equalTo(self.projectOriginalButton.mas_bottom).mas_offset(20.f);
    }];
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rateLabel);
        make.top.mas_equalTo(self.rateLabel.mas_bottom).mas_offset(10.f);
    }];
    [self.projectDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(CGRectGetWidth([UIScreen mainScreen].bounds)/2.0);
        make.top.mas_equalTo(self.projectOriginalButton.mas_bottom).mas_offset(20.f);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.projectDayLabel);
        make.top.mas_equalTo(self.projectDayLabel.mas_bottom).mas_offset(10.f);
    }];
    
    UIView * sepView = [UIView new];
    sepView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(15.f);
    }];
}
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:17.f];
    }
    return _titleLabel;
}
- (UILabel *)rateLabel {
    if(!_rateLabel) {
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
        _rateLabel.font = [UIFont systemFontOfSize:18.f];
        _rateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rateLabel;
}
- (UILabel *)projectDayLabel {
    if(!_projectDayLabel) {
        _projectDayLabel = [[UILabel alloc] init];
        _projectDayLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
        _projectDayLabel.font = [UIFont systemFontOfSize:15];
        _projectDayLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _projectDayLabel;
}
- (UILabel *)leftLabel {
    if(!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.textColor = [UIColor colorWithHexString:@"0xffffff"];
        _leftLabel.text = @"期望年均回报率";
        _leftLabel.font = [UIFont systemFontOfSize:10.5];
    }
    return _leftLabel;
}
- (UILabel *)rightLabel {
    if(!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textColor = [UIColor whiteColor];
        _rightLabel.text = @"项目期限";
        _rightLabel.font = [UIFont systemFontOfSize:10.5f];
    }
    return _rightLabel;
}
- (UIButton *)projectOriginalButton {
    if (!_projectOriginalButton) {
        _projectOriginalButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_projectOriginalButton setTitle:@"查看原项目" forState:UIControlStateNormal];
        [_projectOriginalButton setTitleColor:[UIColor colorWithHexString:@"0xffef00"] forState:UIControlStateNormal];
        _projectOriginalButton.titleLabel.font = [UIFont systemFontOfSize:11.f];
        _projectOriginalButton.layer.borderWidth = 1.f;
        _projectOriginalButton.layer.borderColor = _projectOriginalButton.currentTitleColor.CGColor;
    }
    return _projectOriginalButton;
}

@end


@interface HCMyInvestDetailCell:UITableViewCell
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * pointImageView;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UIButton * helpButton;

@property (nonatomic,   copy) void(^helpButtonClick)(void);

@end

@implementation HCMyInvestDetailCell
{
    UIButton *_helpButton;

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.pointImageView];
        [self.contentView addSubview:self.descLabel];
        self.helpButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.helpButton setImage:[NSBundle myInvesetment_ImageWithName:@"wdyhq_icon_wh_nor"] forState:UIControlStateNormal];
        [self.helpButton addTarget:self action:@selector(helpButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.helpButton.hidden = YES;
        [self.contentView addSubview:self.helpButton];
        [self layout_Masonry];
    }
    return self;
}

- (void)layout_Masonry {
    
    CGSize size = [@"预计8888-88-88" sizeWithAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]}];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(self.line.mas_left).mas_offset(-20.f);
        make.width.mas_equalTo(size.width +10);
    }];
    [self.pointImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.line);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pointImageView.mas_right).mas_offset(20.f);
        make.right.lessThanOrEqualTo(@(-5));
        make.top.mas_equalTo(self.pointImageView);
    }];
    [self.helpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.descLabel.mas_right).mas_offset(3);
        make.centerY.mas_equalTo(self.descLabel);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pointImageView.mas_bottom).mas_offset(0);
        make.height.mas_greaterThanOrEqualTo(60).priorityHigh();
        make.width.mas_equalTo(1.f);
        make.centerX.mas_equalTo(self.contentView).mas_offset(-CGRectGetWidth([UIScreen mainScreen].bounds)*0.10);
    }];
    
}
- (UILabel *)timeLabel {
    if(!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _timeLabel.font = [UIFont systemFontOfSize:12.5];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.numberOfLines = 0;
    }
    return _timeLabel;
}

- (UIImageView *)pointImageView {
    if (!_pointImageView) {
        _pointImageView = [[UIImageView alloc] initWithImage:[NSBundle myInvesetment_ImageWithName:@"xq_yd_nor"]];
    }
    return _pointImageView;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        _line.bounds = CGRectMake(0, 0, 1, 60);
    }
    return _line;
}
- (UILabel *)descLabel {
    if(!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}
- (void) helpButtonClick:(UIButton *)button {
    if (self.helpButtonClick) {
        self.helpButtonClick();
    }
}

@end



@interface HCMyInvestDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) HCMyInvestDetailHeaderView * headerView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) HCUserCreditRightDetailModel * detailModel;
@property (nonatomic, strong) UIView * footerView;
@property (nonatomic, strong) UIButton * protocolButton;
@end

@implementation HCMyInvestDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"详情" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    
    [self loadData];
    
}
- (void)loadData {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * detailCreditRightBillsParams = [NSMutableDictionary dictionary];
    detailCreditRightBillsParams[@"token"] = user[@"token"];
    detailCreditRightBillsParams[@"number"] = self.number;
    HCMyInvestDetailCreditRightBillsApi * detailCreditRightBillsApi = [[HCMyInvestDetailCreditRightBillsApi alloc] initWithParams:detailCreditRightBillsParams];
    
    
    NSMutableDictionary * detailParams = [NSMutableDictionary dictionary];
    detailParams[@"token"] = user[@"token"];
    detailParams[@"number"] = self.number;
    
    
    HCMyInvestCreditDetailApi * detailApi = [[HCMyInvestCreditDetailApi alloc] initWithParams:detailParams];
    
    YTKBatchRequest * request = [[YTKBatchRequest alloc] initWithRequestArray:@[detailCreditRightBillsApi,detailApi]];
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [request startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        
        HCMyInvestDetailCreditRightBillsApi * detailCreditRightBillsApi = (HCMyInvestDetailCreditRightBillsApi *)batchRequest.requestArray.firstObject;
        if (detailCreditRightBillsApi.responseObject) {
            NSArray * array = [NSArray yy_modelArrayWithClass:[HCMyInvestDetailListModel class] json:detailCreditRightBillsApi.responseObject[@"data"]];
            if (array.count) {
                [self.dataArray addObjectsFromArray:array];
            }
           
        }
        HCMyInvestCreditDetailApi * detailApi = (HCMyInvestCreditDetailApi *)batchRequest.requestArray.lastObject;
        if ( detailApi.responseJSONObject) {
            self.detailModel = [HCUserCreditRightDetailModel yy_modelWithJSON:detailApi.responseObject];
            self.headerView.titleLabel.text = self.detailModel.projectModel.name;
            if (self.detailModel.creditRightModel.type==6) {
                NSInteger day = [HCTimeTool getTimeDistanceDate1:self.detailModel.projectModel.repaymentDate date2:self.detailModel.creditRightModel.createTime.integerValue];
                self.headerView.projectDayLabel.text = [NSString stringWithFormat:@"%zd天",day];
            }else{
                self.headerView.projectDayLabel.text = [NSString stringWithFormat:@"%zd天",self.detailModel.projectModel.projectDays];
            }
            
            NSString * original = [NSString stringWithFormat:@"%.2f%%",[self.detailModel.creditRightModel.baseRate doubleValue]];
            
            NSMutableAttributedString * originalAnnualEarningString = [[NSMutableAttributedString alloc] initWithString:original attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            
            if ([self.detailModel.couponModel.type integerValue]==1 && self.detailModel.couponModel) {
                NSString * addAnnualEarning = nil;
                if (self.detailModel.couponModel.duration.integerValue==-1) {
                    addAnnualEarning = [NSString stringWithFormat:@"+%.2f%%全程加息",[self.detailModel.couponModel.value doubleValue]];
                }else {
                    addAnnualEarning = [NSString stringWithFormat:@"+%.2f%%加息%zd天",[self.detailModel.couponModel.value doubleValue],self.detailModel.couponModel.duration.integerValue];
                }
                NSAttributedString * string = [[NSAttributedString alloc] initWithString:addAnnualEarning attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
                [originalAnnualEarningString appendAttributedString:string];
                
            }
            self.headerView.rateLabel.attributedText = originalAnnualEarningString;
            
        }
        if (self.detailModel.creditRightModel.type==6) {
            
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"查看《债权转让服务协议》"];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x666666"] range:NSMakeRange(0, 2)];
            
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x1371fb"] range:NSMakeRange(2, string.string.length-2)];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.string.length)];

            [self.protocolButton setAttributedTitle:string forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showText:batchRequest.failedRequest.error.localizedDescription];
    }];
    
    
}

- (void)projectOriginalButtonClick {

    NSString * projectUrl = [NSString stringWithFormat:@"%@project/%@",WebBaseURL,self.detailModel.projectModel.number];
    HCInvestWebController * investWebVC = [[HCInvestWebController alloc] initWithAddress:projectUrl];
    investWebVC.projectNumber = self.detailModel.projectModel.number;
    investWebVC.webTitle = self.detailModel.projectModel.name;
    [self.navigationController pushViewController:investWebVC animated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMyInvestDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    __weak typeof(self) weakSelf = self;
    if (self.dataArray.count) {
        HCMyInvestDetailListModel * model = self.dataArray[indexPath.row];
        
        [self setCell:cell status:model.status indexPath:indexPath];
        
        if (model.status==1) {
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",model.date];
        }else{
            cell.timeLabel.text = [NSString stringWithFormat:@"预计%@",model.date];
        }
        switch (model.type) {
            case 1://投资
            {
           
                if (self.detailModel.creditRightModel.type==6 ) {
                    cell.helpButton.hidden = NO;
                    cell.helpButtonClick = ^{
                        [weakSelf handlerHelpButton];
                    };
                    cell.descLabel.text = [NSString stringWithFormat:@"投资：本金%zd元\n实付：%.2f元",[model.amount integerValue],self.detailModel.creditRightModel.payAmount.doubleValue];
                }else{
                    cell.descLabel.text = [NSString stringWithFormat:@"投资：本金%zd元",[model.amount integerValue]];
                }
            }
                break;
            case 2://投资
            {
                cell.descLabel.text = @"项目募集中";
            }
                break;
            case 3:
            {
                cell.descLabel.text = @"开始计息";
            }
                break;
            case 4:
            {
                if (model.couponProfit.doubleValue *100 > 1) {
                    
                    NSString * desc =  [NSString stringWithFormat:@"回款：利息%.2f元\n加息：%.2f元",[model.amount doubleValue],[model.couponProfit doubleValue]];
                    
                    NSMutableParagraphStyle * paraStyle = [[NSMutableParagraphStyle alloc] init];
                    paraStyle.lineSpacing = 5.f;
                    
                    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:desc attributes:@{NSParagraphStyleAttributeName:paraStyle}];
                    
                    cell.descLabel.attributedText = attrString;
                }else{
                    if (self.detailModel.creditRightModel.type==6 &&self.detailModel.feeModel.receiveProfit.doubleValue >=0.01 && model== self.dataArray[2]) {
                        cell.descLabel.text = [NSString stringWithFormat:@"回款：利息%.2f元\n认购垫资：%.2f元",[model.amount doubleValue]-self.detailModel.feeModel.receiveProfit.doubleValue,self.detailModel.feeModel.receiveProfit.doubleValue];
                    }else{
                        cell.descLabel.text = [NSString stringWithFormat:@"回款：利息%.2f元",[model.amount doubleValue]];
                    }
                }
            }
                break;
            case 5:
            {
                cell.descLabel.text = [NSString stringWithFormat:@"回款：本金%.2f元",[model.amount doubleValue]];
            }
                break;
            case 6:
            {
                cell.descLabel.text = [NSString stringWithFormat:@"募集期贴息：%.2f元",[model.amount doubleValue]];

            }
                break;
            case 7:
            {
                cell.descLabel.text = [NSString stringWithFormat:@"特权加息收益：%.2f元",[model.amount doubleValue]];

            }
                break;
            case 8:
            {
                if (model.profit.doubleValue>=0.01) {
                    cell.descLabel.text = [NSString stringWithFormat:@"回款：债权转让%.2f元\n(含当期利息%.2f元)",[model.amount doubleValue],model.profit.doubleValue];
                }else {
                    cell.descLabel.text = [NSString stringWithFormat:@"回款：债权转让%.2f元",[model.amount doubleValue]];
                }

            }
                break;
            default:
                break;
        }
        if (model.type !=1) {
            cell.helpButton.hidden = YES;
        }
        [cell.descLabel layoutIfNeeded];
    }
    
    return cell;
}
- (void)handlerHelpButton {
    NSString * descString = nil;
    double spreadProfit = self.detailModel.feeModel.spreadProfit.doubleValue;
    double profit = self.detailModel.creditRightModel.profit.doubleValue;
    
    if (spreadProfit>=0.01) {
        //有利差
        double receiveProfit = self.detailModel.feeModel.receiveProfit.doubleValue;
        
        if (receiveProfit==0) {
            descString = [NSString stringWithFormat:@"您获得转让奖金%.2f元，实际支付时已扣减该部分资金\n预计总收益 = 认购时已获转让奖金%.2f元 + 各期预计回款利息%.2f元",spreadProfit,spreadProfit,profit];
        }else if (receiveProfit>0){
            descString = [NSString stringWithFormat:@"您已先行垫付该笔债权当期已产生收益%.2f元，这部分资金会在首个还款日归还给您；\n您已获得转让奖金%.2f元，实际支付时已扣减该部分金额。\n预计总收益 = 认购时已获转让奖金%.2f元 + 各期预计回款利息%.2f元",receiveProfit,spreadProfit,spreadProfit,profit];
        }else {
            descString = [NSString stringWithFormat:@"您已提前获得该笔债权收益%.2f元，实际支付时已扣减该部分金额；\n您已获得转让奖金%.2f元，实际支付时已扣减该部分金额。\n预计总收益 = 认购时已获利息%.2f元 + 已获转让奖金%.2f元 + 此后各期预计回款利息%.2f元",fabs(receiveProfit),spreadProfit,fabs(receiveProfit),spreadProfit,profit-fabs(receiveProfit)-fabs(spreadProfit)];
        }
        
    }else {
        //
        double receiveProfit = self.detailModel.feeModel.receiveProfit.doubleValue;
        
        if (receiveProfit==0) {
            descString = [NSString stringWithFormat:@"预计总收益 = 各期回款利息%.2f元",profit];
        }else if (receiveProfit>0){
            descString = [NSString stringWithFormat:@"您已先行垫付该笔债权当期已产生利息%.2f元，这部分资金会在首个还款日归还给您。\n预计总收益 = 各期预计回款利息%.2f元",receiveProfit,profit];
        }else {
            descString = [NSString stringWithFormat:@"您已提前获得该笔债权利息%.2f元，实际支付时已扣减该部分金额；\n预计总收益 = 认购时已获利息%.2f元 + 此后各期预计回款利息%.2f元",fabs(receiveProfit),fabs(receiveProfit),profit-fabs(receiveProfit)];
        }
        
    }
    
    TYAlertView * alertView = [TYAlertView alertViewWithTitle:@"" message:@""];
    alertView.buttonCornerRadius = 5.f;
    alertView.layer.cornerRadius = 5.f;
    alertView.buttonHeight = 35;

    TYAlertAction * cancel = [TYAlertAction actionWithTitle:@"我知道了" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {
        
    }];
    alertView.buttonCancelBgColor = [UIColor colorWithHexString:@"0xff611d"];
    NSMutableParagraphStyle * para = [[NSMutableParagraphStyle alloc] init];
    para.paragraphSpacing = 5.f;
    para.lineSpacing = 2.f;
    
    NSAttributedString * string = [[NSAttributedString alloc] initWithString:descString attributes:@{NSParagraphStyleAttributeName:para}];
    alertView.messageLabel.attributedText = string;
    alertView.messageLabel.textAlignment = NSTextAlignmentLeft;
    [alertView addAction:cancel];
    [alertView showInController:self preferredStyle:TYAlertControllerStyleAlert];
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.dataArray.count-1) {
        return 30;
    }else{
        return 75.f;

    }
    return 0;
}
- (void)setCell:(HCMyInvestDetailCell *)cell status:(NSInteger)status indexPath:(NSIndexPath *)indexPath {
    HCMyInvestDetailListModel * model = self.dataArray[indexPath.row];
    if (model!= self.dataArray.lastObject) {
        HCMyInvestDetailListModel * model = self.dataArray[indexPath.row+1];
        if (model.status==0) {
            cell.line.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        }else{
            cell.line.backgroundColor = [UIColor colorWithHexString:@"0xdddddd"];
        }
        cell.line.hidden = NO;

    }else{
        cell.line.hidden = YES;
    }
    
    if (status==1) {
        cell.pointImageView.image = [NSBundle myInvesetment_ImageWithName:@"xq_yd_ddd_nor"];
        cell.descLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        cell.timeLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    }else{
        cell.pointImageView.image = [NSBundle myInvesetment_ImageWithName:@"xq_yd_nor"];
        cell.descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        cell.timeLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
    }
}
-(NSString *)notRounding:(float)price afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?30:CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = self.footerView;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[HCMyInvestDetailCell class] forCellReuseIdentifier:@"Cell"];
        _tableView.estimatedRowHeight = 60.f;
        _tableView.tableHeaderView = self.headerView;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
- (HCMyInvestDetailHeaderView *)headerView {
    if (!_headerView) {
        HCMyInvestDetailHeaderView * headerView = [[HCMyInvestDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 160)];
        [headerView.projectOriginalButton addTarget:self action:@selector(projectOriginalButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _headerView = headerView;
    }
    return _headerView;
}
- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        
        self.protocolButton = [UIButton buttonWithType:UIButtonTypeSystem];
        
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:@"查看《宏财网服务协议》"];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x666666"] range:NSMakeRange(0, 2)];

        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0x1371fb"] range:NSMakeRange(2, string.string.length-2)];
        [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, string.string.length)];
        [self.protocolButton addTarget:self action:@selector(protocolClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.protocolButton setAttributedTitle:string forState:UIControlStateNormal];
 
        [_footerView addSubview:self.protocolButton];
        
        [self.protocolButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(40);
            make.centerX.mas_equalTo(_footerView);
        }];
    }
    return _footerView;
}
- (void)protocolClick:(UIButton *)button{
    if (self.detailModel.creditRightModel.type==6) {
        NSString * url = [NSString stringWithFormat:@"%@assignment-agree?creditRightNum=%@",WebBaseURL,self.detailModel.creditRightModel.number];
        UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        NSString * url = nil;
        if (self.detailModel.creditRightModel.status==1) {
            url =  [NSString stringWithFormat:@"%@service-agree/%@/0?creditNum=%@",WebBaseURL,self.detailModel.projectModel.number,self.detailModel.creditRightModel.number];
            
        }else{
            url = [NSString stringWithFormat:@"%@service-agree/%@/1?creditNum=%@",WebBaseURL,self.detailModel.projectModel.number,self.detailModel.creditRightModel.number];
        }
        UIViewController *controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
        [self.navigationController pushViewController:controller animated:YES];
    }

}
@end
