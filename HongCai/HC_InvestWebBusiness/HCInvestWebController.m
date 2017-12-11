//
//  HCInvestWebController.m
//  HongCai
//
//  Created by Candy on 2017/7/8.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInvestWebController.h"
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCGoToInvestBusiness_Category/CTMediator+HCGoToInvestBusiness.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCUserIdentityView.h"
#import <TYAlertController/TYAlertController.h>
#import "HCUserInvestmentApi.h"
#import "HCUserNotPayOrderApi.h"
#import "HCCheckUserService.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import <Masonry/Masonry.h>
#import "HCPartakeCutInterestRateApi.h"
#import <JSToastBusiness/MBProgressHUD+Reminding.h>
#import "HCSpecialInvestController.h"
typedef void(^successCallBack)(id notPayOrderdata);

@interface HCInvestWebController ()<UIWebViewDelegate>
@property (nonatomic, strong, readwrite) UIWebView *webView;
@property (nonatomic, copy) NSURL * URL;
@property (nonatomic, strong) UILabel * titleView;
@property (nonatomic, weak) UINavigationController * specialInvestNavController;

@end

@implementation HCInvestWebController
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HC_LoginSuccessNotification object:nil];
}


- (instancetype)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL*)pageURL {
    if(self = [self init]) {
        _URL = pageURL;
    }
    return self;
}

- (void)loadURL:(NSURL *)pageURL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:pageURL];
    request.timeoutInterval = 60.f;
    [self.webView loadRequest:request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuideBottom);
        make.left.right.mas_equalTo(self.view);
        if (@available(iOS 11.0,*)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }
    }];
    if (_URL) {
        [self loadURL:_URL];
    }
    if (self.webTitle.length>0) {
        self.titleView.attributedText = [[NSAttributedString alloc]initWithString:self.webTitle attributes:[UINavigationBar appearance].titleTextAttributes];
        [self.titleView sizeToFit];
        self.navigationItem.titleView = self.titleView;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:HC_LoginSuccessNotification object:nil];
    
#if DEBUG
    [WebViewJavascriptBridge enableLogging];
#endif
    [self hanlderHCNative_ImmediateInvestment];
    [self hanlderHCNative_Login];
    [self hanlderHCNative_ImgSrc];
    [self hanlderHCNative_GetToken];
    [MBProgressHUD showFullScreenLoadingView:self.view];
    
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;

        [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    }
    return _webView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    NSDictionary * param = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    if ([param[@"token"] length] >0) {
        [self checkUserNotPayOrder:@{@"token":param[@"token"]} success:^(id notPayOrderdata) {
            if (notPayOrderdata) {
                [self showNotPayOrderViewWithData:notPayOrderdata];
            }
        }];
    }

    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString * remindingKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"projectDetail_Reminding"];
    if ((remindingKey==nil || [remindingKey integerValue]!=1 ) && self.presentedViewController==nil) {
        [MBProgressHUD showProjectDetailRemindingViewFromView:[UIApplication sharedApplication].keyWindow];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)hanlderHCNative_GetToken {
    [self.webViewJavascriptBridge registerHandler:@"HCNative_GetToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        if ([user[@"token"] length]>0) {
            responseCallback(@{@"token":user[@"token"]});
        }else{
            responseCallback(@{@"token":@""});
        }
    }];
    
}
- (void)loginSuccess:(NSNotification *)notification {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        if ([user.allKeys containsObject:@"token"]) {
            [self.webViewJavascriptBridge callHandler:@"HCWeb_LoginSuccess" data:@{@"token":user[@"token"]}];
        }
    }
}

- (void)showNotPayOrderViewWithData:(id)data {

    UIViewController * controller = [[CTMediator sharedInstance] HCShowNotPayViewBusiness_viewControllerWithCountinueButtonClickCallBack:^(NSDictionary *info) {
    
        UIViewController * vc = info[@"controller"];
        [vc dismissViewControllerAnimated:YES completion:NULL];
        
        
        NSMutableDictionary *payParams = [NSMutableDictionary dictionary];
        NSDictionary *user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        
        payParams[@"token"] = user[@"token"];
        payParams[@"orderNumber"] = data[@"number"];
        payParams[@"controller"] = self;
        [[CTMediator sharedInstance] HCGateWayBusiness_paymentWithRequestParams:payParams];
        

    } detailParams:data];
    
    [self presentViewController:controller animated:YES completion:NULL];
    
    
}

- (void)checkUserNotPayOrder:(NSDictionary *)params success:(successCallBack)success {
    
    
    HCUserNotPayOrderApi * api = [[HCUserNotPayOrderApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        success(request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
    
}


- (void)gotoInvestWithInvestParams:(NSDictionary *)params success:(successCallBack)success {
    
    HCUserInvestmentApi * api = [[HCUserInvestmentApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject && success) {
            success(request.responseJSONObject);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
        
    }];
}

/**
 立即投资
 */
- (void)hanlderHCNative_ImmediateInvestment {
    __weak typeof(self) weakSelf = self;
    
    [self.webViewJavascriptBridge registerHandler:@"HCNative_ImmediateInvestment" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        if ([user[@"token"] length] >0) {
            [weakSelf checkUserNotPayOrder:@{@"token":user[@"token"]} success:^(id notPayOrderdata) {
                if (notPayOrderdata) {
                    [weakSelf showNotPayOrderViewWithData:notPayOrderdata];
                }else{
                    NSDictionary * params = [NSDictionary dictionaryWithDictionary:data];
                    
                    if ([params.allKeys containsObject:@"amount"]) {
                        NSDecimalNumber * amount = params[@"amount"];
                        if (amount.integerValue==0) {
                            [MBProgressHUD showText:@"当前剩余可投金额已被其他用户投资但尚未完成支付，请稍后再试" delay:3];
                            return ;
                        }
                    }
                    [weakSelf prepareToInvestWithData:data];
                }
            }];
        }else{
            UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
            [weakSelf.navigationController presentViewController:controller animated:YES completion:NULL];
        }

    }];
}

- (void)prepareToInvestWithData:(id)data {
    NSMutableDictionary * investParams = [data mutableCopy];
    investParams[@"projectNumber"] = self.projectNumber;
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    [HCCheckUserService checkUserAuthStatusAndBankcard:self success:^(BOOL success) {
        if (success) {
            HCPartakeCutInterestRateApi * api  = [[HCPartakeCutInterestRateApi alloc] initWithProjectType:[data[@"type"] intValue] token:user[@"token"]];
            [MBProgressHUD showLoadingFromView:self.view];
            [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (request.responseObject) {
                    BOOL isPartake = [request.responseObject[@"isPartake"] boolValue];
                    if (isPartake) {
                        //支持降息换物；
                        HCSpecialInvestController * specialInvestVc = [[HCSpecialInvestController alloc] init];
                        specialInvestVc.projectType = [data[@"type"] intValue];
                        __weak typeof(self) weakSelf = self;
                        specialInvestVc.selectLevel = ^(int level, NSDecimalNumber *baseRate, NSDecimalNumber*minInvestAmount,NSString * desc) {
                            if (level==0) {
                                //暂不使用
                                weakSelf.specialInvestNavController = nil;
                                investParams[@"isPartake"] = @(NO);
                                investParams[@"level"] = @(level);
                                investParams[@"level"] = @(level);
                                investParams[@"specialInvestDesc"]= @"";

                                investParams[@"annualEarnings"] = data[@"annualEarnings"];
                                investParams[@"minInvestAmount"] = [NSDecimalNumber decimalNumberWithString:@"100"];
                                [weakSelf joinInvestWithUser:user investParams:investParams controller:weakSelf.navigationController];
                            }else {
                                investParams[@"annualEarnings"] = baseRate;
                                investParams[@"isPartake"] = @(YES);
                                investParams[@"specialInvestDesc"]=  desc;
                                investParams[@"level"] = @(level);
                                investParams[@"minInvestAmount"] = minInvestAmount;
                                [weakSelf joinInvestWithUser:user investParams:investParams controller:weakSelf.specialInvestNavController];
                            }
                        };
                   
                        UINavigationController * specialInvestNavController = [[UINavigationController alloc] initWithRootViewController:specialInvestVc];
                        self.specialInvestNavController = specialInvestNavController;
                        [self.navigationController presentViewController:self.specialInvestNavController animated:YES completion:NULL];
                    }else{
                        [self joinInvestWithUser:user investParams:investParams controller:self.navigationController];
                    };
                }
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
            }];
            
        }
    }];

}
- (void)joinInvestWithUser:(NSDictionary *)user investParams:(NSDictionary *)investParams controller:(UIViewController *)currentController{
    __weak typeof(self) weakSelf = self;
    UIViewController * controller = [[CTMediator sharedInstance] HCGoToInvestBusiness_viewControllerWithgotoInvestButtonClickCallBack:^(NSDictionary *information) {
        if ([information[@"type"] integerValue]==1) {
            
            NSMutableDictionary *investmentParam = [NSMutableDictionary dictionary];
            investmentParam[@"projectNumber"] = self.projectNumber;
            investmentParam[@"token"] = user[@"token"];
            investmentParam[@"investAmount"] = information[@"investAmount"];
            investmentParam[@"level"] = information[@"level"];

            if ([information[@"couponNumber"] length] >0) {
                investmentParam[@"couponNumber"] = information[@"couponNumber"];
                
            }
            [self gotoInvestWithInvestParams:investmentParam success:^(id data) {
                NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
                NSMutableDictionary * payParams = [NSMutableDictionary dictionary];
                payParams[@"token"] =user[@"token"];
                payParams[@"orderNumber"] = data [@"number"];
                payParams[@"controller"] = self;
                
                UIViewController * controller = information[@"controller"];
                
                if (!weakSelf.specialInvestNavController) {
                    [controller dismissViewControllerAnimated:NO completion:NULL];
                    [[CTMediator sharedInstance] HCGateWayBusiness_paymentWithRequestParams:payParams];
                }else{
                    [controller dismissViewControllerAnimated:NO completion:^{
                        [weakSelf.specialInvestNavController dismissViewControllerAnimated:NO completion:^{
                            weakSelf.specialInvestNavController = nil;
                            [[CTMediator sharedInstance] HCGateWayBusiness_paymentWithRequestParams:payParams];
                        }];
                    }];
                }
                
            }];
            
        }else{
            NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
            NSMutableDictionary * payParams = [NSMutableDictionary dictionary];
            payParams[@"token"] =user[@"token"];
            payParams[@"level"] = information[@"level"];

            
            payParams[@"projectNumber"] = self.projectNumber;
            payParams[@"investAmount"] = information[@"investAmount"];
            if ([information[@"couponNumber"] length] >0) {
                payParams[@"couponNumber"] = information[@"couponNumber"];
            }
            payParams[@"controller"] = self;
            UIViewController * controller = information[@"controller"];
            if (!weakSelf.specialInvestNavController) {
                [controller dismissViewControllerAnimated:NO completion:NULL];
                [[CTMediator sharedInstance] HCGateWayBusiness_rechargeAndPaymentWithRequestParams:payParams];
            }else{
                [controller dismissViewControllerAnimated:NO completion:^{
                    [weakSelf.specialInvestNavController dismissViewControllerAnimated:NO completion:^{
                        [[CTMediator sharedInstance] HCGateWayBusiness_rechargeAndPaymentWithRequestParams:payParams];
                    }];
                }];
            }
          
        }
        
    } detailParams:investParams];
    [currentController presentViewController:controller animated:YES completion:NULL];

}
/**
 点击显示大图
 */
- (void)hanlderHCNative_ImgSrc{
    
    __weak typeof(self) weakSelf = self;
    
    [self.webViewJavascriptBridge registerHandler:@"HCNative_ImgSrc" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        IDMPhoto * photo = [IDMPhoto photoWithURL:[NSURL URLWithString:data[@"imgSrc"]]];
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
        
        [weakSelf presentViewController:browser animated:YES completion:NULL];
        

        
    }];
}

/**
 调用登录
 */
- (void)hanlderHCNative_Login {
    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_Login" handler:^(id data, WVJBResponseCallback responseCallback) {
        UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];
        [weakSelf presentViewController:controller animated:YES completion:NULL];
    }];
}

#pragma -mark lazyLoading
- (UILabel *)titleView {
    if (!_titleView) {
        _titleView =  [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_MAX, 44)];
        _titleView.textAlignment = NSTextAlignmentCenter;
    }
    return _titleView;
}
- (WebViewJavascriptBridge *)webViewJavascriptBridge {
    if (!_webViewJavascriptBridge) {
        _webViewJavascriptBridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
        [_webViewJavascriptBridge setWebViewDelegate:self];
    }
    return _webViewJavascriptBridge;
}
@end
