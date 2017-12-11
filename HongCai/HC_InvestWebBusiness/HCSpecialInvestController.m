//
//  HCSpecialInvestController.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/16.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSpecialInvestController.h"
#import <Masonry/Masonry.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCSpecialInvestCell.h"
#import "HCCutIncreaseRateApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import "HCSpecialInvestModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface HCSpecialInvestController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) HCSpecialInvestModel * model;
@property (nonatomic, assign) CGFloat spaceHeight;
@property (nonatomic, strong) UIButton * nextStepButton;
@end

static NSString * const cellIdentifier = @"HCSpecialInvestCell";
static NSString * const spaceIdentifier = @"HCSpecialInvestSpaceCell";
@implementation HCSpecialInvestController


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"特权投资" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    self.nextStepButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.nextStepButton.backgroundColor = [UIColor colorWithHexString:@"0xFA4918"];
    [self.nextStepButton setTintColor:[UIColor whiteColor]];
    self.nextStepButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextStepButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextStepButton];
    
    [self.nextStepButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    [self setupRightBarButtonItem];
    [self loadData];
}
- (void)nextButtonClick {
    
    if (!self.tableView.indexPathForSelectedRow) {
        [MBProgressHUD showText:@"请选择一项投资特权或暂不使用特权投资" delay:2];
        return;
    }
    if (self.tableView.indexPathForSelectedRow) {
        HCSpecialInvestRuleModel * model = self.model.rules[self.tableView.indexPathForSelectedRow.row];
        if (self.selectLevel) {
            self.selectLevel(model.level,self.model.baseRate,model.minInvestAmount,model.desc);
        }
    }
}
- (void)loadData {
    NSDictionary * user= [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    HCCutIncreaseRateApi * api = [[HCCutIncreaseRateApi alloc] initWithProjectType:self.projectType token:user[@"token"]];
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            self.model = [HCSpecialInvestModel yy_modelWithJSON:request.responseObject];
            if (self.model.imageUrl) {
                [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl] placeholderImage:[UIImage imageNamed:@"icon_zwf_nor"]];
            }
            if (self.model.desc) {
                NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                paragraphStyle.headIndent = 10.f;
                paragraphStyle.firstLineHeadIndent = 10.f;
                paragraphStyle.tailIndent = -10.f;
                CGSize size = [self.model.desc boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)-40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
                self.spaceHeight =size.height/2.0+20;
                
                [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(20.f);
                    make.right.mas_equalTo(-20.f);
                    make.bottom.mas_equalTo(size.height/2.0+10);
                    make.height.mas_equalTo(size.height +20);
                }];
                
                NSAttributedString *string = [[NSAttributedString alloc] initWithString:self.model.desc attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f],NSParagraphStyleAttributeName:paragraphStyle}];
                
                
                self.descLabel.attributedText = string;
            }
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (void)setupRightBarButtonItem {
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc] initWithTitle:@"暂不使用" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
    self.navigationItem.rightBarButtonItem = rightBar;
}
//暂不使用
- (void)rightBarClick {
   
    __weak typeof(self) weakSelf = self;
   [self.navigationController dismissViewControllerAnimated:YES completion:^{
       if (weakSelf.selectLevel) {
           weakSelf.selectLevel(0,nil,nil,nil);
       }
   }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section==0?1:self.model.rules.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section==0) {
        HCSpecialInvestSpaceCell * cell = [tableView dequeueReusableCellWithIdentifier:spaceIdentifier];
        if (self.spaceHeight) {
            [cell setupHeight:self.spaceHeight];
        }
        return cell;
    }
    HCSpecialInvestCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (self.model) {
        cell.ruleModel = self.model.rules[indexPath.row];
    }
    return cell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 40;
        _tableView.tableHeaderView = self.logoImageView;
        [_tableView registerClass:[HCSpecialInvestCell class] forCellReuseIdentifier:cellIdentifier];
        [_tableView registerClass:[HCSpecialInvestSpaceCell class] forCellReuseIdentifier:spaceIdentifier];

    }
    return _tableView;
}

- (void)setupSubViews{
    }
- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),  CGRectGetWidth([UIScreen mainScreen].bounds)*250/670.0)];
        
        [_logoImageView addSubview:self.descLabel];
        
   
    }
    return _logoImageView;
}
- (UILabel *)descLabel {
    if(!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor grayColor];
        _descLabel.backgroundColor = [UIColor whiteColor];
        _descLabel.layer.cornerRadius =12.f;
        _descLabel.layer.masksToBounds = YES;
        _descLabel.numberOfLines = 0;
        _descLabel.font = [UIFont systemFontOfSize:14.5f];
    }
    return _descLabel;
}
@end
