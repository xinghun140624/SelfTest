//
//  HCCalendarController.m
//  HongCai
//
//  Created by 郭金山 on 2017/10/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCCalendarController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <FSCalendar/FSCalendar.h>
#import "NSBundle+HCCalendarModule.h"
#import "HCCalendarCell.h"
#import "HCCalendarBottomCell.h"
#import "HCGetCalendarDataApi.h"
#import "HCCalendarRepaymentDateApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <FSCalendar/FSCalendarExtensions.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import "HCGetSystemServerTimeApi.h"
#import "HCCalendarRepaymentDetailController.h"
@interface HCCalendarController ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic,   weak) UILabel *leftMoneyLabel;
@property (nonatomic,   weak) UILabel *rightMoneyLabel;

@property (nonatomic, strong) UIButton * previousButton;
@property (nonatomic, strong) UIButton * nextButton;
@property (nonatomic, strong) NSCalendar *gregorian;
@property (nonatomic, strong) FSCalendar *calendar;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray <NSString *>* repaymentDateArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDictionary * currentDateData;
@property (nonatomic, strong) NSDate * currentSelectDate;
@property (nonatomic, strong) NSDate * todayDate;
@end

@implementation HCCalendarController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        UIScrollView *scrollView = UIScrollView.new;
        self.scrollView = scrollView;
        scrollView.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
        [self.view addSubview:scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}
- (void)loadView {
    [super loadView];
    UIView * contentView = [UIView new];
    [self.scrollView addSubview:contentView];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
    }];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectZero];
    headerView.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
    [contentView addSubview:headerView];
    
    UIView * headerBgView=  [[UIView alloc] init];
    headerBgView.backgroundColor = [UIColor whiteColor];
    headerBgView.layer.cornerRadius = 8.f;
    [headerView addSubview:headerBgView];
    [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    UILabel * leftDescLabel = [[UILabel alloc] init];
    leftDescLabel.text = @"本月预计回款";
    leftDescLabel.font = [UIFont systemFontOfSize:15.f];
    leftDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    leftDescLabel.textAlignment = NSTextAlignmentCenter;
    [headerBgView addSubview:leftDescLabel];
    
    UILabel * rightDescLabel = [[UILabel alloc] init];
    rightDescLabel.text = @"本月待收回款";
    rightDescLabel.font = [UIFont systemFontOfSize:15.f];
    rightDescLabel.textColor = [UIColor colorWithHexString:@"0x999999"];
    rightDescLabel.textAlignment = NSTextAlignmentCenter;
    [headerBgView addSubview:rightDescLabel];
    
    NSArray * descArray = @[leftDescLabel,rightDescLabel];
    [descArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.5f leadSpacing:0 tailSpacing:0];
    [descArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f);
    }];
    
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(120);
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"0xeeeeee"];
    [headerBgView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15);
        make.width.mas_equalTo(0.5);
        make.centerX.mas_equalTo(headerBgView);
    }];
    
    UILabel * leftMoneyLabel = [[UILabel alloc] init];
    leftMoneyLabel.text = @"0.00元";
    leftMoneyLabel.font = [UIFont systemFontOfSize:15.f];
    leftMoneyLabel.textColor = [UIColor colorWithHexString:@"0xff6000"];
    leftMoneyLabel.textAlignment = NSTextAlignmentCenter;
    self.leftMoneyLabel = leftMoneyLabel;
    
    [headerBgView addSubview:leftMoneyLabel];
    
    UILabel * rightMoneyLabel = [[UILabel alloc] init];
    rightMoneyLabel.text = @"0.00元";
    rightMoneyLabel.font = [UIFont systemFontOfSize:15.f];
    rightMoneyLabel.textColor = [UIColor colorWithHexString:@"0xff6000"];
    rightMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [headerBgView addSubview:rightMoneyLabel];
    self.rightMoneyLabel = rightMoneyLabel;
    
    NSArray * moneyLabelArray = @[leftMoneyLabel,rightMoneyLabel];
    [moneyLabelArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0.5f leadSpacing:0 tailSpacing:0];
    [moneyLabelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-20.f);
    }];
    
    
    FSCalendar * calendar = [[FSCalendar alloc] initWithFrame:CGRectZero];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.appearance.caseOptions = FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    calendar.appearance.weekdayTextColor = [UIColor colorWithHexString:@"0x999999"];
    calendar.appearance.titleDefaultColor = [UIColor colorWithHexString:@"0x666666"];
    calendar.appearance.headerDateFormat = @"YYYY/MM";
    calendar.appearance.headerTitleFont =[UIFont systemFontOfSize:15.f];
    calendar.appearance.headerTitleColor = [UIColor colorWithHexString:@"0xff6000"];
    calendar.appearance.todayColor = [UIColor clearColor];
    calendar.appearance.selectionColor = [UIColor colorWithRGB:0xff6116 alpha:0.1];
    calendar.appearance.titleFont = [UIFont systemFontOfSize:16];
    calendar.appearance.titleSelectionColor = [UIColor colorWithHexString:@"0xff6000"];
    calendar.backgroundColor = [UIColor whiteColor];
    [calendar registerClass:[HCCalendarCell class] forCellReuseIdentifier:@"MyCell"];
    [contentView addSubview:calendar];
    self.calendar = calendar;
    
    [self.calendar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom);
        make.left.mas_equalTo(@0);
        make.width.mas_equalTo(contentView.mas_width);
        make.height.mas_equalTo(285);
    }];
    
    UIButton *previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
    previousButton.frame = CGRectMake(0, 120, 95, 40);
    previousButton.backgroundColor = [UIColor whiteColor];
    previousButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    previousButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [previousButton setImage:[NSBundle calendar_ImageWithName:@"calendar_arrow_left"] forState:UIControlStateNormal];
    [previousButton setImage:[NSBundle calendar_ImageWithName:@"calendar_arrow_dis_left"] forState:UIControlStateDisabled];
    [previousButton addTarget:self action:@selector(previousClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:previousButton];
    self.previousButton = previousButton;
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetWidth(self.view.frame)-95, 120, 95, 40);
    nextButton.backgroundColor = [UIColor whiteColor];
    nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    
    nextButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [nextButton setImage:[NSBundle calendar_ImageWithName:@"calendar_arrow_right"] forState:UIControlStateNormal];
    [nextButton setImage:[NSBundle calendar_ImageWithName:@"calendar_arrow_dis_right"] forState:UIControlStateDisabled];
    [nextButton addTarget:self action:@selector(nextClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:nextButton];
    self.nextButton = nextButton;
    
    
    UIView * middleView = [[UIView alloc] init];
    middleView.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:middleView];
    
    [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(calendar.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(30);
        
    }];
    UIButton * hkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [hkButton setTitle:@"回款" forState:UIControlStateNormal];
    [hkButton setImage:[NSBundle calendar_ImageWithName:@"_e-icon_hkrl"] forState:UIControlStateNormal];
    hkButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    hkButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [hkButton setTitleColor:[UIColor colorWithHexString:@"0x666666"] forState:UIControlStateNormal];
    [middleView addSubview:hkButton];
    
    [hkButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(middleView);
    }];
    
    [contentView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(middleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(100+35);
    }];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_bottom);
    }];
    
    UIView * topBorder = [self.calendar valueForKey:@"topBorder"];
    topBorder.backgroundColor = [UIColor clearColor];
    UIView * bottomBorder = [self.calendar valueForKey:@"bottomBorder"];
    bottomBorder.backgroundColor = [UIColor clearColor];
    
}
- (NSMutableArray<NSString *> *)repaymentDateArray {
    if (!_repaymentDateArray) {
        _repaymentDateArray = [NSMutableArray array];
    }
    return _repaymentDateArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"回款日历" attributes:[UINavigationBar appearance].titleTextAttributes];
    [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    
    [MBProgressHUD showFullScreenLoadingView:self.view];
    [self loadSysyemDate];
    [self loadTopMonthData];
    [self loadRepaymentDatesOfMonth];
 
}
- (void)loadSysyemDate {

    HCGetSystemServerTimeApi * timeApi = [[HCGetSystemServerTimeApi alloc] init];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
    [timeApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDateComponents *components = [self.gregorian components:NSUIntegerMax fromDate:[NSDate dateWithTimeIntervalSince1970:[request.responseObject[@"time"] doubleValue]/1000.0]];
            components.hour = 0;
            components.minute = 0;
            components.second = 0;
          
            self.todayDate = [self.gregorian dateFromComponents:components];
            [self.calendar selectDate:self.todayDate];
            [self requestDateOfselectDate];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
- (void)loadTopMonthData {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        HCGetCalendarDataApi * api = [[HCGetCalendarDataApi alloc] initWithToken:user[@"token"] userId:[user[@"id"] intValue] startTime:[[self.gregorian fs_firstDayOfMonth:self.calendar.currentPage] timeIntervalSince1970] *1000 endTime:[[self.gregorian fs_lastDayOfMonth:self.calendar.currentPage] timeIntervalSince1970] *1000];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (request.responseObject) {
                self.leftMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[request.responseObject[@"anticipateAmount"] doubleValue]];
                self.rightMoneyLabel.text = [NSString stringWithFormat:@"%.2f元",[request.responseObject[@"waitingAmount"] doubleValue]];
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
}
- (void)loadRepaymentDatesOfMonth {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        HCCalendarRepaymentDateApi * api = [[HCCalendarRepaymentDateApi alloc] initWithToken:user[@"token"] userId:[user[@"id"] intValue] startTime:[[self.gregorian fs_firstDayOfMonth:self.calendar.currentPage] timeIntervalSince1970] *1000 endTime:[[self.gregorian fs_lastDayOfMonth:self.calendar.currentPage] timeIntervalSince1970] *1000];
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            if (request.responseObject) {
                [self.repaymentDateArray removeAllObjects];
                NSArray * array = request.responseObject;
                if (array.count) {
                    for (NSInteger index = 0; index < array.count; index++) {
                        NSTimeInterval timeInterval = [array[index] doubleValue];
                        
                        [self.repaymentDateArray addObject:[self.dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval/1000.0]]];
                    }
                    [self.calendar reloadData];
                }
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
}
- (void)requestDateOfselectDate {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSTimeInterval date = [self.calendar.selectedDate timeIntervalSince1970]*1000;
    self.currentSelectDate = self.calendar.selectedDate;
    HCGetCalendarDataApi * api = [[HCGetCalendarDataApi alloc] initWithToken:user[@"token"] userId:[user[@"id"] intValue] startTime:date endTime:date];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (request.responseObject) {
            self.currentDateData = request.responseObject;
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
- (void)calendarCurrentPageDidChange:(FSCalendar *)calendar {
    NSDate *currentMonth = calendar.currentPage;

    NSDateComponents *components = [self.gregorian components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:currentMonth];
    
    if (components.year==2016&&components.month==6) {
        self.previousButton.enabled = NO;
    }else{
        self.previousButton.enabled = YES;
    }
    if (components.year==2020 && components.month==12) {
        self.nextButton.enabled = NO;
    }else {
        self.nextButton.enabled = YES;
    }
    
    [MBProgressHUD showLoadingFromView:self.view];
    [self loadTopMonthData];
    [self loadRepaymentDatesOfMonth];
    if ([self isSameMonth:currentMonth]) {
        [self.calendar selectDate:self.todayDate];
        [self requestDateOfselectDate];
    }else{
        [self.calendar selectDate:currentMonth];
        [self requestDateOfselectDate];
    }
    
}
- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2016-06-01"];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [self.dateFormatter dateFromString:@"2020-12-31"];
}
- (FSCalendarCell *)calendar:(FSCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    HCCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"MyCell" forDate:date atMonthPosition:monthPosition];
    return cell;
}

- (void)calendar:(FSCalendar *)calendar willDisplayCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition: (FSCalendarMonthPosition)monthPosition {
    [self configureCell:cell forDate:date atMonthPosition:monthPosition];
}

- (void)configureCell:(FSCalendarCell *)cell forDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    HCCalendarCell *diyCell = (HCCalendarCell *)cell;
    if ([self.repaymentDateArray containsObject:[self.dateFormatter stringFromDate:date]]) {
        diyCell.selectionType = SelectionTypeHK;
        diyCell.titleLabel.textColor = [UIColor colorWithHexString:@"0xfffc00"];
        diyCell.titleLabel.font = [UIFont systemFontOfSize:8.5];
    }else {
        diyCell.selectionType = SelectionTypeNone;
    }
  
}
- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
  
    if (self.currentSelectDate !=nil) {
        if ([self.gregorian isDate:date inSameDayAsDate:self.currentSelectDate]) {
            return;
        }
    }
    
    if (self.repaymentDateArray.count) {
        if ([self.repaymentDateArray containsObject:[self.dateFormatter stringFromDate:date]]) {
            [self requestDateOfselectDate];
        }else {
            self.currentSelectDate = date;
            self.currentDateData = nil;
            [self.tableView reloadData];
        }
    }
    [self configureVisibleCells];
}

- (void)calendar:(FSCalendar *)calendar didDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    [self configureVisibleCells];
}
- (void)configureVisibleCells {
    [self.calendar.visibleCells enumerateObjectsUsingBlock:^(__kindof FSCalendarCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDate *date = [self.calendar dateForCell:obj];
        FSCalendarMonthPosition position = [self.calendar monthPositionForCell:obj];
        [self configureCell:obj forDate:date atMonthPosition:position];
    }];
}
#pragma mark - <FSCalendarDelegateAppearance>


- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance fillSelectionColorForDate:(NSDate *)date {
    return appearance.selectionColor;
}

- (UIColor *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance titleDefaultColorForDate:(NSDate *)date {
    if (self.todayDate) {
        if ([self.gregorian isDate:self.todayDate inSameDayAsDate:date]) {
            return [UIColor colorWithHexString:@"0xff6000"];
        }
    }
    return [UIColor colorWithHexString:@"0x666666"];
}
- (BOOL) isSameMonth:(NSDate *)fromDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:self.todayDate];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:fromDate];
    
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month);
}
- (void)previousClicked:(id)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    if ([self.gregorian isDate:[self.dateFormatter dateFromString:@"2016-6-1"] inSameDayAsDate:self.calendar.currentPage]) {
        return;
    }
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
    
    if ([self isSameMonth:previousMonth]) {
        [self.calendar selectDate:self.todayDate];
        [self requestDateOfselectDate];

    }else{
        [self.calendar selectDate:previousMonth];
        [self requestDateOfselectDate];

    }
}
- (void)nextClicked:(id)sender {
    NSDate *currentMonth = self.calendar.currentPage;
    if ([self.gregorian isDate:[self.dateFormatter dateFromString:@"2020-12-31"] inSameDayAsDate:self.calendar.currentPage]) {

        return;
    }
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
    if ([self isSameMonth:nextMonth]) {
        [self.calendar selectDate:self.todayDate];
        [self requestDateOfselectDate];
    }else{
        [self.calendar selectDate:nextMonth];
        [self requestDateOfselectDate];
    }
}

#pragma -mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 15.f;
    }
    return CGFLOAT_MIN;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==1) {
        return 20.f;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCCalendarBottomCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HCCalendarBottomCell"];
    switch (indexPath.section) {
        case 0:
        {
            cell.titleLabel.text = @"当日回款总额";
            if (self.currentDateData) {
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[self.currentDateData[@"anticipateAmount"] doubleValue]];
            }else {
                cell.moneyLabel.text = @"0.00元";
            }
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"当日待收回款";
            if (self.currentDateData) {
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[self.currentDateData[@"waitingAmount"] doubleValue]];
            }else {
                cell.moneyLabel.text = @"0.00元";
            }
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            HCCalendarRepaymentDetailController * controller = [[HCCalendarRepaymentDetailController alloc] init];
            controller.selectDate = self.calendar.selectedDate;
            controller.type = 1;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 1:{
            HCCalendarRepaymentDetailController * controller = [[HCCalendarRepaymentDetailController alloc] init];
            controller.selectDate = self.calendar.selectedDate;

            controller.type = 2;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
    }
}

#pragma -mark UITableViewDelegate

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[HCCalendarBottomCell class] forCellReuseIdentifier:@"HCCalendarBottomCell"];
    }
    return _tableView;
}
@end
