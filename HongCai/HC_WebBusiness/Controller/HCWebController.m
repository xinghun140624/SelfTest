//
//  HCWebController.m
//  HC_WebBusiness
//
//  Created by Candy on 2017/6/27.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCWebController.h"
#import <HCLoginBusiness_Category/CTMediator+HCLoginBusiness.h>
#import <UMSocialCore/UMSocialCore.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <HCShareBusiness_Category/CTMediator+HCShareBusiness.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <HCGateWayBusiness_Category/CTMediator+HCGateWayBusiness.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "NSBundle+HCWebBusinessModule.h"
#import "HCCheckUserService.h"
#import "HCGetUserBankAndAuthApi.h"
#import <JSToastBusiness/MBProgressHUD+HCNetwork.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import "HCNetworkConfig.h"
#import <HCMessageBusiness_Category/CTMediator+HCMessageBusiness.h>
#import "HCMySpecialMoneyController.h"
#import <IDMPhotoBrowser/IDMPhotoBrowser.h>
#import "AppDelegate.h"



@interface HCWebController ()<AXWebViewControllerDelegate,IDMPhotoBrowserDelegate>
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation HCWebController



- (void)setNavigationItem:(BOOL)appear {
    if (appear) {
        
        UIButton * shareButton =  [UIButton buttonWithType:UIButtonTypeSystem];
        [shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        shareButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [shareButton sizeToFit];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}
- (void)setRightBarButton:(NSString *)title {
        UIButton * limitMoneyButton =  [UIButton buttonWithType:UIButtonTypeSystem];
        [limitMoneyButton setTitle:title forState:UIControlStateNormal];
        [limitMoneyButton addTarget:self action:@selector(limitMoneyButtonClick) forControlEvents:UIControlEventTouchUpInside];
        limitMoneyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [limitMoneyButton sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:limitMoneyButton];
    
}

- (void)limitMoneyButtonClick {
    NSString * url = [NSString stringWithFormat:@"%@user-center/bankcard-limit",WebBaseURL];
    UIViewController * controller = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:url}];
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HC_LoginSuccessNotification object:nil];
}
- (void)webViewControllerDidStartLoad:(AXWebViewController *)webViewController {
    

}
- (void)webViewControllerDidFinishLoad:(AXWebViewController *)webViewController {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.enabledWebViewUIDelegate = YES;
    [MBProgressHUD showFullScreenLoadingView:self.view];
    if (self.rightBarButtonTitle.length>0) {
        [self setRightBarButton:self.rightBarButtonTitle];
    }
    self.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:HC_LoginSuccessNotification object:nil];
    
#if DEBUG
    [WKWebViewJavascriptBridge enableLogging];
#endif
    [self hanlderHCNative_GetToken];
    [self handlerHCNative_Share];
    [self handlerHCNative_NeedShare];
    [self hanlderHCNative_Login];
    [self handlerHCNative_CheckUserAuth];
    [self hanlderHCNative_CopyToWechat];
    [self handlerHCNative_SuccessCallback];
    [self handlerHCNative_ShareToWechat];
    [self handlerHCNative_ShareToQQ];
    [self handlerHCNative_CopyLink];
    [self handlerHCNative_NeedInviteList];
    [self hanlderHCNative_BackToPrePage];
    [self handlerHCNative_GoInvestList];
    [self handlerHCNative_GoMessage];
    [self handlerHCNative_GoPrivilegedCapital];
    [self hanlderHCNative_ImgSrc];
    [self handlerHCNative_SetBackButtonStatus];
}
- (void)shareClick {
    [self shareClick:2];
}
- (void)shareClick:(NSInteger)type {
    
    NSDictionary * param = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    
    if ([param[@"token"] length] ==0) {
        UIViewController * controller = [[CTMediator sharedInstance] HCLoginBusiness_viewController];

        [self presentViewController:controller animated:YES completion:NULL];
        return;
    }
    __weak typeof(self) weakSelf = self;
    
    UIViewController * controller = [[CTMediator sharedInstance] HCShareBusiness_shareControllerWithType:type ShareButtonClickCallBack:^(NSDictionary *info) {
        UMSocialPlatformType type = 0;
        NSInteger index = [info[@"type"] integerValue];
        switch (index) {
            case 0:
                type = UMSocialPlatformType_WechatSession;
                break;
            case 1:
                type = UMSocialPlatformType_QQ;
                break;
            case 2:
            {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = weakSelf.params[@"url"];
                [MBProgressHUD showText:@"复制成功"];
                return;
                
            }
                break;
        }
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        //创建网页内容对象
        NSString* thumbURL =  weakSelf.params[@"imageUrl"];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:weakSelf.params[@"title"] descr:weakSelf.params[@"subTitle"] thumImage:thumbURL];
        //设置网页地址
        shareObject.webpageUrl = weakSelf.params[@"url"];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        
        [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:weakSelf completion:^(id data, NSError *error) {
            if (error) {
                [self.webViewJavascriptBridge callHandler:@"HCWeb_ShareSuccess" data:@{@"isShareSuccess":@(0)}];
                if (error.code==UMSocialPlatformErrorType_Cancel) {
                    [MBProgressHUD showText:@"分享已取消"];
                    
                }else if (error.code ==UMSocialPlatformErrorType_NotInstall){
                    [MBProgressHUD showText:@"应用未安装"];
                }else if (error.code ==UMSocialPlatformErrorType_NotNetWork){
                    [MBProgressHUD showText:@"网络异常"];
                }else if (error.code==UMSocialPlatformErrorType_ShareFailed) {
                    [MBProgressHUD showText:@"分享失败"];
                }
                
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    [MBProgressHUD showText:@"分享成功"];
                    [weakSelf.webViewJavascriptBridge callHandler:@"HCWeb_ShareSuccess" data:@{@"isShareSuccess":@(1)}];
                }else{
                }
            }
        }];
    }];
    [self presentViewController:controller animated:YES completion:NULL];
    
}

- (void)hanlderHCNative_GetToken {
    [self.webViewJavascriptBridge registerHandler:@"HCNative_GetToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        if (user[@"token"]) {
            responseCallback(@{@"token":user[@"token"]});
        }else{
            responseCallback(@{@"token":@""});
        }
    }];

}
- (void)hanlderHCNative_CopyToWechat {
    [self.webViewJavascriptBridge registerHandler:@"HCNative_CopyToWechat" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = data[@"copyText"];
        [MBProgressHUD showText:@"复制成功！"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
            }else{
                [MBProgressHUD showText:@"抱歉，您未安装微信客户端"];
            }
            
        });

    }];
}
/**
 激活存管通
 */
- (void)handlerHCNative_CheckUserAuth {
    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_CheckUserAuth" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        NSMutableDictionary * param = [NSMutableDictionary dictionary];
        param[@"token"] = user[@"token"];
        HCGetUserBankAndAuthApi * api = [[HCGetUserBankAndAuthApi alloc] initWithParams:param];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSNumber * auth = request.responseJSONObject[@"auth"];//0未认证，1 认证通过，2 未激活
            switch (auth.integerValue) {
                case 0:
                {
                    [HCCheckUserService openCGT:weakSelf];
                }
                    break;
                case 1:
                    break;
                case 2:
                {
                    [HCCheckUserService activeCGT:weakSelf];
                }
                    break;
            }
            
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
            }else{
                [MBProgressHUD showText:request.error.localizedDescription];
            }
        }];
    }];
}
/**
 成功回调
 */
- (void)handlerHCNative_SuccessCallback {
    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_SuccessCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        NSDictionary *params = data;
       if ([params[@"business"] isEqualToString:@"UNBIND_BANKCARD"]){
            
            [MBProgressHUD showText:@"解绑银行卡成功~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }else if ([params[@"business"] isEqualToString:@"BIND_BANK_CARD"]) {
            
            [MBProgressHUD showText:@"绑定银行卡成功~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }else if ([params[@"business"] isEqualToString:@"AUTHORIZATION_AUTO_TRANSFER"]) {
            [MBProgressHUD showText:@"自动投标授权激活成功~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];

        }else if ([params[@"business"] isEqualToString:@"RESET_MOBILE"]) {
            [MBProgressHUD showText:@"修改手机号成功~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if ([params[@"business"] isEqualToString:@"RESET_PASSWORD"]) {
            [MBProgressHUD showText:@"支付密码修改成功~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if ([params[@"business"] isEqualToString:@"USER_AUTHORIZATION"]) {
            [MBProgressHUD showText:@"自动投标授权~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else if ([params[@"business"] isEqualToString:@"USER_ACTIVE"]) {
            [MBProgressHUD showText:@"激活成功~"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            UIViewController * controller = [[CTMediator sharedInstance] HCGateWayBusiness_successViewControllerWithParams:data];
            [weakSelf.navigationController pushViewController:controller animated:YES];

        }
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

/**
 需要显示分享按钮
 */
- (void)handlerHCNative_NeedShare {
    __weak typeof(self) weakSelf = self;

    [self.webViewJavascriptBridge registerHandler:@"HCNative_NeedShare" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.params = data;
        
        [weakSelf setNavigationItem:YES];
    }];
}

/**
 分享
 */
- (void)handlerHCNative_Share {
    __weak typeof(self) weakSelf = self;

    [self.webViewJavascriptBridge registerHandler:@"HCNative_Share" handler:^(id data, WVJBResponseCallback responseCallback) {
        weakSelf.params = data;
        [weakSelf shareClick:[data[@"HC_shareType"] integerValue]];
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




#pragma -mark  分享模块

- (void)handlerHCNative_ShareToWechat {
    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_ShareToWechat" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf shareWithType:UMSocialPlatformType_WechatSession data:data];
    }];
    
}
- (void)handlerHCNative_ShareToQQ {
    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_ShareToQQ" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf shareWithType:UMSocialPlatformType_QQ data:data];
    }];
    
}
- (void)handlerHCNative_CopyLink {
    [self.webViewJavascriptBridge registerHandler:@"HCNative_CopyLink" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = data[@"url"];
        [MBProgressHUD showText:@"复制成功"];
        
        
    }];
}
- (void)shareWithType:(UMSocialPlatformType)type data:(id)data {
    
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  data[@"imageUrl"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:data[@"title"] descr:data[@"subTitle"] thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = data[@"url"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            if (error.code==UMSocialPlatformErrorType_Cancel) {
                [MBProgressHUD showText:@"分享已取消"];
                
            }else if (error.code ==UMSocialPlatformErrorType_NotInstall){
                [MBProgressHUD showText:@"应用未安装"];
            }else if (error.code ==UMSocialPlatformErrorType_NotNetWork){
                [MBProgressHUD showText:@"网络异常"];
            }else if (error.code==UMSocialPlatformErrorType_ShareFailed) {
                [MBProgressHUD showText:@"分享失败"];
            }
            
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                [MBProgressHUD showText:@"分享成功"];
            }else{
                
            }
        }
    }];
}
- (void)handlerHCNative_NeedInviteList {

    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_NeedInviteList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if ([data[@"isShow"] boolValue]) {
            
            
            UIButton * inviteButton =  [UIButton buttonWithType:UIButtonTypeSystem];
            [inviteButton setTitle:@"邀请列表" forState:UIControlStateNormal];
            [inviteButton addTarget:weakSelf action:@selector(inviteList) forControlEvents:UIControlEventTouchUpInside];
            inviteButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [inviteButton sizeToFit];
            
            
            weakSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:inviteButton];
        }else{
            weakSelf.navigationItem.rightBarButtonItem = nil;
        }
    }];
}
- (void)hanlderHCNative_BackToPrePage {
    __weak typeof(self) weakSelf = self;
    
    [self.webViewJavascriptBridge registerHandler:@"HCNative_BackToPrePage" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data) {
            NSString * message = data[@"successMsg"];
            if (message.length >0) {
                [MBProgressHUD showText:message];
            }
        }
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)handlerHCNative_GoMessage{
    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_GoMessage" handler:^(id data, WVJBResponseCallback responseCallback) {
        UITabBarController * tabBarVC = (UITabBarController * )[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 3;
        UINavigationController * navigationController = tabBarVC.selectedViewController;
        UIViewController * messageVC = [[CTMediator sharedInstance] HCMessageBusiness_viewControllerWithIndex:1];
        [navigationController pushViewController:messageVC animated:NO];
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];

    }];
}
- (void)handlerHCNative_GoPrivilegedCapital {
    __weak typeof(self) weakSelf = self;
    [self.webViewJavascriptBridge registerHandler:@"HCNative_GoPrivilegedCapital" handler:^(id data, WVJBResponseCallback responseCallback) {
        UITabBarController * tabBarVC = (UITabBarController * )[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 3;
        UINavigationController * navigationController = tabBarVC.selectedViewController;
        UIViewController * controller = [HCMySpecialMoneyController new];
        [navigationController pushViewController:controller animated:NO];
        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
        
    }];

}
/**
 点击显示大图
 */
- (void)hanlderHCNative_ImgSrc{
    
    __weak typeof(self) weakSelf = self;
    
    [self.webViewJavascriptBridge registerHandler:@"HCNative_ImgSrc" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        
        IDMPhoto * photo = [IDMPhoto photoWithURL:[NSURL URLWithString:data[@"imgSrc"]]];
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:@[photo]];
        browser.delegate = weakSelf;
        [weakSelf presentViewController:browser animated:YES completion:^{
      
        }];
        
    }];
}
- (void)willAppearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser {
    AppDelegate * appdelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.allowRotate = 1;
}
- (void)willDisappearPhotoBrowser:(IDMPhotoBrowser *)photoBrowser {
    AppDelegate * appdelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.allowRotate = 0;
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

//邀请列表
- (void)inviteList {
    [self.webViewJavascriptBridge callHandler:@"HCWeb_ToInviteList"];
}
- (void)handlerHCNative_GoInvestList {
    
    __weak typeof(self) weakSlef = self;
    
    [self.webViewJavascriptBridge registerHandler:@"HCNative_GoInvestList" handler:^(id data, WVJBResponseCallback responseCallback) {
    
        UITabBarController * tabBarVC = (UITabBarController * )[UIApplication sharedApplication].keyWindow.rootViewController;
        tabBarVC.selectedIndex = 1;
        [weakSlef.navigationController popToRootViewControllerAnimated:YES];
    }];
}
- (void)handlerHCNative_SetBackButtonStatus {
    __weak typeof(self) weakSlef = self;
    
    [self.webViewJavascriptBridge registerHandler:@"HCNative_SetBackButtonStatus" handler:^(id data, WVJBResponseCallback responseCallback) {
        if (data) {
            NSInteger status = [data[@"status"] integerValue];
            [weakSlef updateNavigationItemsStatus:status];
        }
    }];
  
}
- (void)updateNavigationItemsStatus:(NSInteger)status {
    
    switch (status) {
        case 0:
        {
            UIButton * button = self.navigationBackItem.customView.subviews.firstObject;
            [button setImage:[UIImage new] forState:UIControlStateNormal];
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.navigationBackItem.enabled = NO;
        }
            break;
        case 1:
        {
            self.navigationBackItem.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            UIButton * button = self.navigationBackItem.customView.subviews.firstObject;
            [button setImage:[NSBundle webBusiness_ImageWithName:@"Registration_icon_return_White_nor"] forState:UIControlStateNormal];
        }
            break;

    }
 
}
#pragma -mark Private Method


#pragma -mark lazyLoading

- (WKWebViewJavascriptBridge *)webViewJavascriptBridge {
    if (!_webViewJavascriptBridge) {
        _webViewJavascriptBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
        [_webViewJavascriptBridge setWebViewDelegate:self];
    }
    return _webViewJavascriptBridge;
}
@end
