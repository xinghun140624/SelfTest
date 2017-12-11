//
//  HCAutoTenderController.m
//  Pods
//
//  Created by Candy on 2017/7/14.
//
//

#import "HCAutoTenderController.h"
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import <Masonry/Masonry.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <TYAlertController/TYAlertController.h>
#import "HCSettingCell.h"
#import "HCAutoTenderInputCell.h"
#import "HCAutoTenderNormalCell.h"
#import "HCAutoTenderTimeCell.h"
#import "HCGetUserBalanceApi.h"
#import "NSBundle+HCSettingModule.h"
#import "HCUserOpenAutoTenderApi.h"
#import "HCUserDisabledAutoTenderApi.h"
#import "HCTimeTool.h"
@interface HCAutoTenderController ()
@property (nonatomic, strong) UIView * modifyFooterView;
@property (nonatomic, strong) UIView * openFooterView;
@property (nonatomic, strong) UIButton * openButton;
@end


static NSString *const topCellIdentifier = @"HCSettingCell";
static NSString *const inputCellIdentifier = @"HCAutoTenderInputCell";

@implementation HCAutoTenderController

/**
 获得用户余额
 */
- (void)getUserBalance {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    
    
    HCGetUserBalanceApi * api = [[HCGetUserBalanceApi alloc] initWithParams:params];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            
            
            XLFormSectionDescriptor * section = self.form.formSections[0];
        
            XLFormRowDescriptor * rowDescriptor = section.formRows[0];
            rowDescriptor.value = [NSString stringWithFormat:@"%.2f元",[request.responseJSONObject[@"balance"] doubleValue]];
            [self updateFormRow:rowDescriptor];
            
            
            
            
            
            
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    UILabel * titleLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.attributedText = [[NSAttributedString alloc]initWithString:@"自动投标" attributes:[UINavigationBar appearance].titleTextAttributes];
   [titleLabel sizeToFit];
    self.navigationItem.titleView =titleLabel;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xefeef4"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self initializeForm];
    [self getUserBalance];
    
    if (self.model) {
        [self updateModel:self.model];
        if (self.model.status==3||self.model.status==2) {//已过期、已禁用
            self.tableView.tableFooterView = self.openFooterView;
            self.form.disabled = NO;
        }else {
            self.tableView.tableFooterView = self.modifyFooterView;
            self.form.disabled = YES;
        }
    }else{
        self.tableView.tableFooterView = self.openFooterView;
        self.form.disabled = NO;
    }
}
- (void)updateModel:(HCUserAutoTenderModel *)model {
  
    
    XLFormSectionDescriptor * section = self.form.formSections[1];
    
    XLFormRowDescriptor * minInvestAmountRow = section.formRows[0];
    minInvestAmountRow.value = model.minInvestAmount;
    
    XLFormRowDescriptor * projectDay = section.formRows[1];
    projectDay.value = [NSString stringWithFormat:@"%zd天",model.maxRemainDay];
    
    XLFormRowDescriptor * minInvestAnnualEarningRow = section.formRows[2];
    minInvestAnnualEarningRow.value = [NSString stringWithFormat:@"%zd%%",[model.annualEarnings integerValue]];
    
    XLFormRowDescriptor * investTypeRow = section.formRows[3];
    
    NSString * investValue = nil;
    switch (model.investType) {
        case 5:
        {
            investValue = @"宏财精选";
        }
            break;
        case 6:
        {
            investValue = @"宏财尊贵";
        }
            break;
        case 2:
        {
            investValue = @"债权转让";
        }
            break;
        case 0:
        {
            investValue = @"全部";
            
        }
        default:
            break;
    }
    investTypeRow.value= investValue;
    
    XLFormRowDescriptor * remainAmountRow = section.formRows[4];
    remainAmountRow.value = model.remainAmount;
    
    
    
    XLFormRowDescriptor * timeRow = section.formRows[5];
    NSMutableDictionary * timeValue = [NSMutableDictionary dictionary];
    timeValue[@"startTime"] = [HCTimeTool getDateWithTimeInterval:model.startTime andTimeFormatter:@"yyyy-MM-dd"];
    timeValue[@"endTime"] = [HCTimeTool getDateWithTimeInterval:model.endTime andTimeFormatter:@"yyyy-MM-dd"];
    timeRow.value = timeValue;
    
    [self.tableView reloadData];



}
- (void)initializeForm {
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    
    form = [XLFormDescriptor formDescriptorWithTitle:@"自动投标"];
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"可用余额" rowType:HCAutoTenderNormalCellFormNormalCell];
    [section addFormRow:row];
    
    
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"最小投资金额" rowType:HCAutoTenderNormalCellFormInputCell];
    
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:HCAutoTenderNormalCellFormNormalCellTagProjectDay rowType:HCAutoTenderNormalCellFormNormalCell];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:HCAutoTenderNormalCellFormNormalCellTagEarning rowType:HCAutoTenderNormalCellFormNormalCell];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:HCAutoTenderNormalCellFormNormalCellTagProjectType rowType:HCAutoTenderNormalCellFormNormalCell];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"账户保留金额" rowType:HCAutoTenderNormalCellFormInputCell];
    [section addFormRow:row];
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"有效期" rowType:HCAutoTenderNormalCellFormTimeCell];

    [section addFormRow:row];
    
    self.form = form;
//    self.form.disabled = YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section==0?CGFLOAT_MIN:15.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (void)modfiyButtonClick:(UIButton *)button {
    self.form.disabled = NO;
    self.tableView.tableFooterView = self.openFooterView;
    [self.tableView reloadData];
}
- (void)forbiddenButtonClick:(UIButton *)button {
    
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"status"] = @(3);
    
    [MBProgressHUD showLoadingFromView:self.view];
    HCUserDisabledAutoTenderApi * api = [[HCUserDisabledAutoTenderApi alloc] initWithParams:params];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.tableView.tableFooterView = self.openFooterView;
        self.form.disabled = NO;
        [MBProgressHUD showText:@"自动投标已禁用"];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];

        }
    }];
    
}
- (void)openButtonClick:(UIButton *)button {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"minRemainDay"] = @(0);
    
    
    XLFormSectionDescriptor * section = self.form.formSections[1];
    XLFormRowDescriptor * minInvestAmountRow = section.formRows[0];
   
    
    if ([minInvestAmountRow.value integerValue]==0){
        [MBProgressHUD showText:@"请输入最小投资金额~"];
        return;
    }
    if ([minInvestAmountRow.value integerValue] >1000000){
        [MBProgressHUD showText:@"最小投资金额不能超过1000000"];
        return;
    }
    
    if (minInvestAmountRow.value && ([minInvestAmountRow.value integerValue]%100!=0)) {
        [MBProgressHUD showText:@"请重新输入最小投标金额"];
        return;
    }
    params[@"minInvestAmount"] =minInvestAmountRow.value;

    XLFormRowDescriptor * projectDay = section.formRows[1];
    NSString * projectDayString = projectDay.value;
    if (!projectDayString) {
        [MBProgressHUD showText:@"请选择最高标的期限~"];
        return;
    }
    params[@"maxRemainDay"] =@([[projectDayString substringToIndex:projectDayString.length-1] integerValue]);
    
    XLFormRowDescriptor * minInvestAnnualEarningRow = section.formRows[2];
    
    NSString * annualEarningValue = minInvestAnnualEarningRow.value;
    if (!annualEarningValue) {
        [MBProgressHUD showText:@"请选择最低期望收益~"];
        return;
    }
    params[@"annualEarnings"] =@([[annualEarningValue substringToIndex:annualEarningValue.length-1] integerValue]);

    
    
    XLFormRowDescriptor * investTypeRow = section.formRows[3];
    
    NSString * investTypeValue = investTypeRow.value;
    
    
    if (!investTypeValue) {
        [MBProgressHUD showText:@"请选择标的类型~"];
        return;
    }
    
    if ([investTypeValue isEqualToString:@"全部"]) {
        params[@"investType"] = @(0);
    }else if ([investTypeValue isEqualToString:@"宏财精选"]) {
        params[@"investType"] = @(5);
    }else if ([investTypeValue isEqualToString:@"宏财尊贵"]) {
        params[@"investType"] = @(6);
    }else if ([investTypeValue isEqualToString:@"债权转让"]) {
        params[@"investType"] = @(2);
    }
    
    
    
    XLFormRowDescriptor * remainAmountRow = section.formRows[4];
    NSString * remainAmountValue = remainAmountRow.value;
    
    if (!remainAmountValue) {
        [MBProgressHUD showText:@"请输入账户保留金额~"];
        return;
    }
    
    if ([remainAmountValue doubleValue] >1000000){
        [MBProgressHUD showText:@"账户保留金额不能超过1000000"];
        return;
    }
    
    params[@"remainAmount"] = remainAmountValue;
    

    XLFormRowDescriptor * timeRow = section.formRows[5];
    NSDictionary * timeValue = timeRow.value;

    if (![timeValue.allKeys containsObject:@"startDate"]) {
        [MBProgressHUD showText:@"选择开始时间~"];
        return;
    }
    if (![timeValue.allKeys containsObject:@"endDate"]) {
        [MBProgressHUD showText:@"选择结束时间~"];
        return;
    }
    NSDate * startDate =  timeValue[@"startDate"];
    NSDate * endDate =  timeValue[@"endDate"];

    
    params[@"startTime"] = [NSString stringWithFormat:@"%.0f",[[self zeroOfDateWithDate:startDate] timeIntervalSince1970]*1000.0];
    params[@"endTime"] = [NSString stringWithFormat:@"%.0f",([[self myDateWithDate:endDate] timeIntervalSince1970]*1000.0)];
    
    NSDate * myEndTime = [self myDateWithDate:endDate];
    
    if ([[NSDate date] timeIntervalSinceDate:myEndTime] >0.000001) {
        
        [MBProgressHUD showText:@"结束时间要大于当前时间"];
        
        
        return;
    }
    
    HCUserOpenAutoTenderApi * api = [[HCUserOpenAutoTenderApi alloc] initWithParams:params];
    
    [MBProgressHUD showLoadingFromView:self.view];

    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        HCUserAutoTenderModel * model = [HCUserAutoTenderModel yy_modelWithJSON:request.responseJSONObject];
        self.model = model;
        self.form.disabled = YES;
        self.tableView.tableFooterView = self.modifyFooterView;
        [self updateModel:self.model];
        [MBProgressHUD showText:@"自动投标已开启~"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
            
        }
        
        
    }];
    
    
    
}
- (NSDate *)myDateWithDate:(NSDate *)date {

    NSCalendar *calendar = [self currentCalendar];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:date];
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    
    // components.nanosecond = 0 not available in iOS
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    return [NSDate dateWithTimeIntervalSince1970:ts];

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

#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}

- (UIView *)openFooterView {
    if (!_openFooterView) {
        _openFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
        _modifyFooterView.backgroundColor = self.view.backgroundColor;
        UIButton * openButton = [UIButton buttonWithType:UIButtonTypeSystem];
        openButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [openButton setTitle:@"开启" forState:UIControlStateNormal];
        [openButton addTarget:self action:@selector(openButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage * backgroundImage = [NSBundle setting_ImageWithName:@"Registration_btn_nor"];
        openButton.titleEdgeInsets = UIEdgeInsetsMake(-8, 0, 0, 0);
        [openButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.openButton = openButton;
        [_openFooterView addSubview:openButton];
        [openButton setFrame:CGRectMake(20, 40, CGRectGetWidth([UIScreen mainScreen].bounds)-40, (CGRectGetWidth([UIScreen mainScreen].bounds)-40) *274.0/1442.0)];
        

    }
    return _openFooterView;
}



- (UIView *)modifyFooterView {
    if (!_modifyFooterView) {
 
        _modifyFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 100)];
        _modifyFooterView.backgroundColor = self.view.backgroundColor;
        
        
        UIButton * modfiyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        modfiyButton.backgroundColor = [UIColor colorWithHexString:@"0xff611d"];
        [modfiyButton setTitle:@"修改" forState:UIControlStateNormal];
        [modfiyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        modfiyButton.layer.cornerRadius = 20.f;
        [_modifyFooterView addSubview:modfiyButton];
        [modfiyButton addTarget:self action:@selector(modfiyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
         modfiyButton.frame = CGRectMake(25, 40, CGRectGetWidth([UIScreen mainScreen].bounds)*0.38, 40);
        UIButton * forbiddenButton = [UIButton buttonWithType:UIButtonTypeSystem];
        forbiddenButton.backgroundColor = [UIColor clearColor];
        [forbiddenButton setTitle:@"禁用" forState:UIControlStateNormal];
        [forbiddenButton setTitleColor:[UIColor colorWithHexString:@"0xff611d"] forState:UIControlStateNormal];
        forbiddenButton.layer.cornerRadius = 20.f;
        forbiddenButton.layer.borderColor = forbiddenButton.currentTitleColor.CGColor;
        forbiddenButton.layer.borderWidth = 1.f;
        [forbiddenButton addTarget:self action:@selector(forbiddenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_modifyFooterView addSubview:forbiddenButton];
      
        forbiddenButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)*0.62-25, 40, CGRectGetWidth([UIScreen mainScreen].bounds)*0.38, 40);
        
    }
    return _modifyFooterView;
}

@end
