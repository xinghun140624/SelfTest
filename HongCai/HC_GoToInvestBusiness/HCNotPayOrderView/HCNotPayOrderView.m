//
//  HCNotPayOrderView.m
//  HC_GoToInvestBusiness
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//
#import "HCNotPayOrderView.h"
#import "NSBundle+GoToInvestModule.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import "HCGetSystemServerTimeApi.h"
#import "HCUserCancelOrderApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>

@interface HCNotPayOrderCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation HCNotPayOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.descLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.f);
            make.centerY.mas_equalTo(self.contentView);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_lessThanOrEqualTo(self.titleLabel.mas_right).mas_offset(15.f);
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(self.contentView);
        }];
    }
    return self;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        _descLabel.font = [UIFont systemFontOfSize:15];
    }
    return _descLabel;
}

@end

@interface HCNotPayOrderView () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, weak) UILabel *statusLabel;

@end
static NSString * const notPayOrderCellIdentifier = @"HCNotPayOderCell";
@implementation HCNotPayOrderView
{
    dispatch_source_t _timer;
}
- (void)setParams:(NSDictionary *)params {
    _params = params;
    [self getSystemServerTime];

}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.tableView];
        [self layout_Masonry];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeForUIApplicationDidBecomeActiveNotification) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeForUIApplicationProtectedDataWillBecomeUnavailable) name:UIApplicationProtectedDataWillBecomeUnavailable object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    dispatch_source_cancel(_timer);
}
//不活跃
- (void)observeForUIApplicationProtectedDataWillBecomeUnavailable {
    dispatch_source_cancel(_timer);
}

//活跃
-(void)observeForUIApplicationDidBecomeActiveNotification {
    [self getSystemServerTime];
}
/** 获取当前View的控制器对象 */
-(UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}

- (void)closeButtonClick:(UIButton *)button {
    UIViewController * controller = [self getCurrentViewController];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    [self userCancelOrder:^(BOOL success) {
        if (success) {
            [controller dismissViewControllerAnimated:YES completion:NULL];

        }
    }];
}

- (void)countinueButtonClick:(UIButton *)button {
    if (self.countinueButtonClickCallBack) {
        self.countinueButtonClickCallBack();
    }
}
- (void)layout_Masonry {
    [self addSubview:self.topBgView];
    [self.topBgView addSubview:self.titleLabel];
    

    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(45);
    }];

  
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topBgView);
        make.top.mas_equalTo(15.5);
    }];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(45, 0, 0, 0));
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCNotPayOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:notPayOrderCellIdentifier];
    if (indexPath.row%2==0) {
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    }
    if (indexPath.row==0) {
        cell.titleLabel.text = @"项目名称：";
        cell.descLabel.text = self.params[@"projectName"];

    }else if(indexPath.row==1){
        cell.titleLabel.text = @"期望年回报率：";
        if ([self.params[@"type"] integerValue]==2) {
            cell.descLabel.text = [NSString stringWithFormat:@"%.2f%%",[self.params[@"projectAnnualEarnings"] doubleValue]];
        }else{
            cell.descLabel.text = [NSString stringWithFormat:@"%.2f%%",[self.params[@"projectAnnualEarnings"] doubleValue]];

        }
        

    }else if(indexPath.row==2){

        
        NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:[self.params[@"repaymentDate"] integerValue]/1000.0];
        NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[self.params[@"valueDate"] integerValue]/1000.0];
        date1 = [self zeroOfDateWithDate:date1];
        date2 = [self zeroOfDateWithDate:date2];
        
        NSTimeInterval resultTime  = [date1 timeIntervalSinceDate:date2];
        
        NSInteger days = resultTime/(3600*24.0);
 
        cell.titleLabel.text = @"项目期限：";
        cell.descLabel.text = [NSString stringWithFormat:@"%zd天",days];


    }else if(indexPath.row==3){
        cell.titleLabel.text = @"投资金额：";
        cell.descLabel.text = [NSString stringWithFormat:@"%.2f元",[self.params[@"orderAmount"] doubleValue]];

    }
    
    
    return cell;
}
- (NSDate *)zeroOfDateWithDate:(NSDate *)date;
{
    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];
}
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

- (UILabel*)titleLabel {
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.text = @"您当前有一笔未支付订单！";
    }
    return _titleLabel;
}
- (UIView *)topBgView {
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
    }
    return _topBgView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView =self.footerView ;
        [_tableView registerClass:[HCNotPayOrderCell class] forCellReuseIdentifier:notPayOrderCellIdentifier];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}
- (UIView *)footerView {
    if (!_footerView) {
        CGFloat height =420- 45*4;
        
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
        _footerView.backgroundColor = [UIColor whiteColor];
        
        UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        cancelButton.backgroundColor = [UIColor whiteColor];
        [cancelButton setTitle:@"取消订单" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        cancelButton.layer.cornerRadius = 20.f;
        cancelButton.layer.borderColor = cancelButton.currentTitleColor.CGColor;
        cancelButton.layer.borderWidth = 1.f;
        [cancelButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:cancelButton];
        
        cancelButton.frame = CGRectMake(25, height-130, CGRectGetWidth([UIScreen mainScreen].bounds)*0.38, 40);
        
        
        
        UIButton * continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
        continueButton.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        [continueButton setTitle:@"继续支付" forState:UIControlStateNormal];
        [continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        continueButton.layer.cornerRadius = 20.f;
        [_footerView addSubview:continueButton];
        [continueButton addTarget:self action:@selector(countinueButtonClick:) forControlEvents:UIControlEventTouchUpInside];

        continueButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)*0.62-25, height-130, CGRectGetWidth([UIScreen mainScreen].bounds)*0.38, 40);
        UIImageView * watchView = [[UIImageView alloc] initWithImage:[NSBundle goToInvest_ImageWithName:@"wzfdd_icon_time-nor"]];
        [_footerView addSubview:watchView];
        
        UILabel * statusLabel = [[UILabel alloc] init];
        statusLabel.font =[UIFont systemFontOfSize:12.f];
        statusLabel.textColor = [UIColor colorWithHexString:@"0x666666"];
        self.statusLabel = statusLabel;
        [_footerView addSubview:statusLabel];
        
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_footerView).mas_offset(5);
            make.bottom.mas_equalTo(cancelButton.mas_top).mas_equalTo(-20.f);
        }];
        [watchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(15, 15));
            make.right.mas_lessThanOrEqualTo(statusLabel.mas_left).mas_offset(-3);
            make.centerY.mas_equalTo(statusLabel);
        }];
     
    }
    return _footerView;
}
- (void)userCancelOrder:(void(^)(BOOL success))success {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"number"] = self.params[@"number"];
    
    [MBProgressHUD showLoadingFromView:self];
    HCUserCancelOrderApi * api = [[HCUserCancelOrderApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (success) {
            success(YES);
        }
        [MBProgressHUD hideHUDForView:self animated:YES];

        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        if (success) {
            success(NO);
        }
    }];
}
- (void)getSystemServerTime {
    HCGetSystemServerTimeApi * api = [[HCGetSystemServerTimeApi alloc] init];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (request.responseJSONObject) {
            NSTimeInterval resultTime =  5*60*1000 - [request.responseJSONObject[@"time"] integerValue] +[self.params[@"createTime"] integerValue];
            
            
            
            
            [self configeTimeCountDown:resultTime/1000];
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
       
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
- (void)configeTimeCountDown:(int)time
{
    __block int timeout = time;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                UIViewController * controller = [self getCurrentViewController];
                [controller dismissViewControllerAnimated:YES completion:NULL];
            });
        }else{
            
            NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
        
                NSString * status = [NSString stringWithFormat:@"该订单若%@秒后未进行支付，系统将自动取消！",strTime];

                NSMutableAttributedString * statusString = [[NSMutableAttributedString alloc] initWithString:status];
                [statusString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xff611d"] range:NSMakeRange(4, status.length-4-16)];
                self.statusLabel.attributedText = statusString;
           
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
