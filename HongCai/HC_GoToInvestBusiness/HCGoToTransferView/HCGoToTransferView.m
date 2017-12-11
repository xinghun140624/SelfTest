//
//  HCGoToTransferView.m
//  Pods
//
//  Created by Candy on 2017/7/7.
//
//

#import "HCGoToTransferView.h"
#import "HCGoToInvestHomeView.h"
#import "HCGoToTransferConfirmView.h"
#import "HCGetUserBalanceApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCAssignmentPayApi.h"
#import "HCRechargeController.h"

@interface HCGoToTransferView ()<UIScrollViewDelegate,HCGoToInvestHomeViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) HCGoToInvestHomeView *goToInvestHomeView;
@property (nonatomic, strong) HCGoToTransferConfirmView *gotoTransferConfirmView;
@property (nonatomic, strong) NSNumber *investAmount;

@end

@implementation HCGoToTransferView

- (void)setRemainAmount:(NSNumber *)remainAmount {
    _remainAmount = remainAmount;
    self.goToInvestHomeView.remainNumber = remainAmount;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mainScrollView];
        
        [self.mainScrollView addSubview:self.goToInvestHomeView];
        [self.mainScrollView addSubview:self.gotoTransferConfirmView];
        
        [self getUserBalance];
        
    }
    return self;
}
/**
 获得用户余额
 */
- (void)getUserBalance {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    HCGetUserBalanceApi * api = [[HCGetUserBalanceApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            NSNumber *userBalance = [NSNumber numberWithDouble:[request.responseJSONObject[@"balance"] doubleValue]];
            self.goToInvestHomeView.userBalance = userBalance;
            self.gotoTransferConfirmView.userBalance = userBalance;
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            [MBProgressHUD showText:request.responseObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
}
- (void)getPayMoney:(void(^)(BOOL success))suceess{

    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"token"] = user[@"token"];
    params[@"remainDays"] = self.projectDays;
    params[@"number"] = self.number;
    
    HCAssignmentPayApi * api = [[HCAssignmentPayApi alloc] initWithParams:params];
    self.goToInvestHomeView.nextButton.enabled = NO;
    UIActivityIndicatorView * activieView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activieView.tag = 100;
    activieView.frame = CGRectMake(10, 10, 20, 20);
    [activieView startAnimating];
    [self.goToInvestHomeView.nextButton addSubview:activieView];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [activieView stopAnimating];
        self.goToInvestHomeView.nextButton.enabled = YES;
        [activieView removeFromSuperview];
        if (request.responseJSONObject) {
            
            NSDecimalNumber * payAmount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",request.responseObject[@"payAmount"]]];
            NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];

            NSDecimalNumber *payResult = [[payAmount decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:self.investAmount.stringValue]] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:self.amount.stringValue] withBehavior:roundingBehavior];
            
            

            self.gotoTransferConfirmView.payMoney = [NSString stringWithFormat:@"%.2f",payResult.doubleValue];
            self.gotoTransferConfirmView.investAmount = @([self.goToInvestHomeView.moneyTextField.text integerValue]);
            NSDecimalNumber * investAmount = [NSDecimalNumber decimalNumberWithString:self.goToInvestHomeView.moneyTextField.text];
            NSDecimalNumber * annualEarnings =[NSDecimalNumber decimalNumberWithString:self.annualEarnings.stringValue];
            NSDecimalNumber * projectDays = [NSDecimalNumber decimalNumberWithString:self.projectDays.stringValue];
            NSDecimalNumber * daysOfOneYear = [NSDecimalNumber decimalNumberWithString:@"36500"];
            
            
            NSDecimalNumber * shouyiAmount = [[[investAmount decimalNumberByMultiplyingBy:annualEarnings] decimalNumberByMultiplyingBy:projectDays] decimalNumberByDividingBy:daysOfOneYear withBehavior:roundingBehavior];
            
            
            
            self.gotoTransferConfirmView.shouyiAmount =@(shouyiAmount.doubleValue);
            if (suceess) {
                suceess(YES);
            }
           
        }
    
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [activieView stopAnimating];
        self.goToInvestHomeView.nextButton.enabled = YES;
        [activieView removeFromSuperview];
        [MBProgressHUD showText:request.error.localizedDescription];
    }];


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

- (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

- (void)goToInvestHomeView:(HCGoToInvestHomeView *)view nextButtonClick:(UIButton *)button {
    if ([view.moneyTextField canResignFirstResponder]) {
        [view.moneyTextField resignFirstResponder];
    }
    self.gotoTransferConfirmView.originalAnnualEarnings = self.originalAnnualEarnings;
    self.gotoTransferConfirmView.annualEarnings = self.annualEarnings;
    self.gotoTransferConfirmView.projectDays = self.projectDays;
    self.investAmount = @([view.moneyTextField.text integerValue]);
     
    self.gotoTransferConfirmView.investAmount = self.investAmount;
    
    
    if ([self.goToInvestHomeView.userBalance doubleValue]< [view.moneyTextField.text doubleValue]) {

        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                        message:@"您的余额不足，请先充值"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [[self getCurrentViewController] dismissViewControllerAnimated:YES completion:^{
                [[self currentViewController].navigationController pushViewController:[HCRechargeController new] animated:YES];

            }];
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[self getCurrentViewController] presentViewController:alert animated:YES completion:NULL];
        return;
    }
    
    
    [self getPayMoney:^(BOOL success) {
        
        if (success) {
            self.investAmount = @([view.moneyTextField.text doubleValue]);
            
            [self.mainScrollView setContentOffset:CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0) animated:YES];

        }
    }];
    
}
-(UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _mainScrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)*2.0, CGRectGetHeight(self.frame));
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
- (HCGoToTransferConfirmView *)gotoTransferConfirmView {
    if (!_gotoTransferConfirmView) {
        _gotoTransferConfirmView = [[HCGoToTransferConfirmView alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.frame))];
        __weak typeof(self) weakSelf = self;
       
        _gotoTransferConfirmView.backButtonCallBack = ^{
            [weakSelf.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        };
        _gotoTransferConfirmView.confirmButtonCallBack = ^{
            if (weakSelf.gotoInvestButtonClickCallBack) {
                weakSelf.gotoInvestButtonClickCallBack();
            }
        };
    }
    return _gotoTransferConfirmView;
}
@end
