//
//  HCPurchasingView.m
//  HongCai
//
//  Created by Candy on 2017/6/19.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCGoToInvestView.h"
#import "HCGoToInvestHomeView.h"
#import "HCGoToInvestConfirmView.h"
#import "HCGoToInvestCouponView.h"
#import "HCGetUserBalanceApi.h"
#import "HCInvestIncreastRateCouponApi.h"
#import "HCGoToInvestCouponView.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCGoToInvestCouponModel.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCMoneyService.h"

//认购页

@interface HCGoToInvestView ()<UIScrollViewDelegate,HCGoToInvestHomeViewDelegate,HCGoToInvestConfirmViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) HCGoToInvestHomeView *goToInvestHomeView;
@property (nonatomic, strong) HCGoToInvestConfirmView *gotoInvestConfirmView;
@property (nonatomic, strong) HCGoToInvestCouponView *goToInvestCouponView;

@property (nonatomic, strong, readwrite) NSNumber *investAmount;
@property (nonatomic, copy, readwrite) NSString *couponNumber;
@property (nonatomic, strong) NSDictionary * bankLimitData;

@end

@implementation HCGoToInvestView
- (void)dealloc {
    NSLog(@"HCGoToInvestView dealloc");
}

#pragma -mark initWithFrame

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainScrollView];
        
        [self.mainScrollView addSubview:self.goToInvestHomeView];
        [self.mainScrollView addSubview:self.gotoInvestConfirmView];
        
        [self.mainScrollView addSubview:self.goToInvestCouponView];
        [HCMoneyService getRechargeData:^(NSDecimalNumber *balance, HCUserBankCardModel *model, NSDictionary *bankLimitData) {
            self.goToInvestHomeView.userBalance = balance;
            self.gotoInvestConfirmView.userBalance = balance;
            self.bankLimitData = bankLimitData;
        } errorMessage:^(NSString *errorMessage) {
            [MBProgressHUD showText:errorMessage];
        }];
        
        
    }
    return self;
}
- (void)setIsPartake:(BOOL)isPartake {
    _isPartake = isPartake;
    //是否支持降息换物
    self.gotoInvestConfirmView.isPartake = isPartake;
    [self.gotoInvestConfirmView.tableView reloadData];
}
- (void)setSpecialInvestDesc:(NSString *)specialInvestDesc {
    _specialInvestDesc = specialInvestDesc;
    self.gotoInvestConfirmView.specailInvestDesc = specialInvestDesc;
    [self.gotoInvestConfirmView.tableView reloadData];
}
- (void)setProjectNumber:(NSString *)projectNumber {
    _projectNumber = projectNumber;
    self.gotoInvestConfirmView.projectNumber = projectNumber;

}
- (void)setAmount:(NSNumber *)amount {
    _amount = amount;
    
    self.goToInvestHomeView.remainNumber = amount;
}

- (void)setAnnualEarnings:(NSDecimalNumber *)annualEarnings {
    _annualEarnings = annualEarnings;
    _gotoInvestConfirmView.annualEarnings = annualEarnings;

}
- (void)setProjectDays:(NSNumber *)projectDays {
    _projectDays = projectDays;
    _gotoInvestConfirmView.projectDays = projectDays;
}
#pragma -mark APIS


/**
 获得用户可用收益券
 */
- (void)investIncreaseRateCoupon:(void(^)(BOOL success))success {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    params[@"token"] = user[@"token"];
    params[@"investAmount"] = self.investAmount;
    params[@"number"] = self.projectNumber;
    self.goToInvestHomeView.nextButton.enabled = NO;
    UIActivityIndicatorView * activieView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activieView.tag = 100;
    activieView.frame = CGRectMake(10, 10, 20, 20);
    [activieView startAnimating];
    [self.goToInvestHomeView.nextButton addSubview:activieView];
    
    HCInvestIncreastRateCouponApi * api = [[HCInvestIncreastRateCouponApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [activieView stopAnimating];
        self.goToInvestHomeView.nextButton.enabled = YES;
        [activieView removeFromSuperview];
        if ( request.responseJSONObject) {
        
            NSArray * array =[NSArray yy_modelArrayWithClass:[HCGoToInvestCouponModel class] json:request.responseJSONObject[@"data"]];
            if (array.count) {
                
                __block NSInteger number = 0;
                [array enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 
                    if ([self.investAmount integerValue] >= [obj.minInvestAmount integerValue]) {
                        number +=1;
                    }
                }];
                if (number==1) {
                    [array enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        
                        if ([self.investAmount integerValue] >= [obj.minInvestAmount integerValue]) {
                            obj.isSelected = YES;
                        }
                    }];
                    
                }
           
                self.gotoInvestConfirmView.couponArray = array;
                self.goToInvestCouponView.investAmount = self.investAmount;
                self.goToInvestCouponView.couponArray = array;
            }
            if (success) {
                success(YES);
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [activieView removeFromSuperview];
        self.goToInvestHomeView.nextButton.enabled = YES;

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

#pragma -mark HCGoToInvestConfirmViewDelegate

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

- (void)gotoInvestConfirmViewInvestButtonClick:(UIButton *)button {

    if (self.gotoInvestButtonClickCallBack) {
        double singleRemain = [self.bankLimitData[@"singleRemain"] doubleValue];//单笔限额;
        double balance = self.goToInvestHomeView.userBalance.doubleValue;//用户余额;
        double investAmount = self.investAmount.doubleValue;
        if (investAmount - singleRemain - balance >0.000001) {
            NSString * message = [NSString stringWithFormat:@"亲~您当前银行卡单笔最大可充值金额为%.2f元，您本次可输入的最大投资金额为%d.00元，请重新输入哦~",singleRemain,(int)(singleRemain+balance)/100*100];
            [MBProgressHUD showText:message delay:3];
            return;
        }
        NSInteger type = [button.currentTitle isEqualToString:@"立即投资"]?1:2;
        if (self.isPartake) {
            //降息换物；
            self.gotoInvestButtonClickCallBack(self.level,type,self.gotoInvestConfirmView.confirmButton);
            self.gotoInvestButtonClickCallBack = nil;
            return;
        }
        __block HCGoToInvestCouponModel * model = nil;
        __block NSInteger number = 0;

        [self.goToInvestCouponView.couponArray enumerateObjectsUsingBlock:^(HCGoToInvestCouponModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.investAmount.integerValue >= obj.minInvestAmount.integerValue) {
                number+=1;
            }
            if (obj.isSelected) {
                model = obj;
            }
        }];
        self.couponNumber = model.number;
    
        if (number>0 && self.couponNumber==nil) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您有优惠券未使用，确认立即投资吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * action =  [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                self.gotoInvestConfirmView.confirmButton.enabled = NO;
                self.gotoInvestButtonClickCallBack(0,type,self.gotoInvestConfirmView.confirmButton);
            }];
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                self.gotoInvestConfirmView.confirmButton.enabled = YES;
            }];
            
            [alert addAction:action];
            [alert addAction:cancelAction];
            
            [[self getCurrentViewController] presentViewController:alert animated:YES completion:NULL];
            self.gotoInvestConfirmView.confirmButton.enabled = NO;
        }else{
            self.gotoInvestButtonClickCallBack(0,type,self.gotoInvestConfirmView.confirmButton);
            self.gotoInvestButtonClickCallBack = nil;

        }
  
        

    }
}

#pragma -mark HCGoToInvestHomeViewDelegate
- (void)goToInvestHomeView:(HCGoToInvestHomeView *)view nextButtonClick:(UIButton *)button {
   
    self.investAmount = @([view.moneyTextField.text integerValue]);

    if (self.isPartake) {
        if (self.investAmount.intValue<self.minInvestAmount.intValue) {
            [MBProgressHUD showText:@"投资金额不满足奖励条件"];
            return;
        }
        if ([view.moneyTextField canResignFirstResponder]) {
            [view.moneyTextField resignFirstResponder];
        }
        self.gotoInvestConfirmView.headerView.moneyNumber = self.investAmount;
        self.gotoInvestConfirmView.investmentAmount = self.investAmount;
        [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0) animated:YES];
        return;
    }
    [self investIncreaseRateCoupon:^(BOOL success) {
        if (success) {
            if ([view.moneyTextField canResignFirstResponder]) {
                [view.moneyTextField resignFirstResponder];
            }
            self.gotoInvestConfirmView.headerView.moneyNumber = self.investAmount;
            self.gotoInvestConfirmView.investmentAmount = self.investAmount;
            [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0) animated:YES];
        }
    }];
}



#pragma -mark lazyLoadings


-(UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)*3.0, CGRectGetHeight(self.frame));
        _mainScrollView.delegate = self;
        _mainScrollView.scrollEnabled = NO;
    }
    return _mainScrollView;
}
- (HCGoToInvestHomeView*)goToInvestHomeView {
    if (!_goToInvestHomeView){
        
        _goToInvestHomeView = [[HCGoToInvestHomeView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame))];
        _goToInvestHomeView.delegate = self;
    }
    return _goToInvestHomeView;
}
- (HCGoToInvestConfirmView *)gotoInvestConfirmView {
    if (!_gotoInvestConfirmView) {
        _gotoInvestConfirmView = [[HCGoToInvestConfirmView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        _gotoInvestConfirmView.delegate = self;
        __weak typeof(self) weakSelf = self;
        _gotoInvestConfirmView.backButtonCallBack = ^{
            if ([weakSelf.goToInvestHomeView.moneyTextField canBecomeFirstResponder]) {
                [weakSelf.goToInvestHomeView.moneyTextField becomeFirstResponder];
            }
            [weakSelf.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        };
        _gotoInvestConfirmView.couponsCellSelectCallBack = ^(UITableViewCell *cell) {
            
            [weakSelf.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds)*2.0, 0) animated:YES];
        };
        
    }
    return _gotoInvestConfirmView;
}
- (HCGoToInvestCouponView*)goToInvestCouponView {
    if (!_goToInvestCouponView){
        _goToInvestCouponView = [[HCGoToInvestCouponView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)*2.0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        __weak typeof(self) weakSelf = self;
        
        _goToInvestCouponView.backButtonCallBack = ^(HCGoToInvestCouponModel *model) {
            
            [weakSelf.gotoInvestConfirmView.tableView reloadData];

            [weakSelf.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0) animated:YES];

        };
    
    }
   
    return _goToInvestCouponView;
}

@end
