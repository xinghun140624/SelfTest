//
//  AppDelegate+AppService.m
//  HongCai
//
//  Created by Candy on 2017/6/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "AppDelegate+AppService.h"
#import "HCTabBarControllerConfig.h"
#import <YTKNetwork/YTKNetwork.h>
#import <JS_ColorHexBusiness/UIColor+YYAdd.h>
#import "HCUrlArgumentsFilter.h"
#import "HCNetworkConfig.h"
#import <SDWebImage/SDWebImageManager.h>
#import <SDImageCache.h>
#import "HCAdApi.h"
#import <JSToastBusiness/MBProgressHUD+AdView.h>
#import <HCWebBusiness_Category/CTMediator+HCWebBusiness.h>
#import "HCAdWindow.h"
#import "HCVipBirthdayView.h"
#import "HCHomeController.h"
//@property (nonatomic, strong) HCVipBirthdayView * vipBirthdayView;
@implementation AppDelegate (AppService)
- (void)setupRequestFilters {
    HCUrlArgumentsFilter * urlFilters = [HCUrlArgumentsFilter filterWithArguments:@{@"device":@7}];
    YTKNetworkConfig * config = [YTKNetworkConfig sharedConfig];
    [config addUrlFilter:urlFilters];
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0,0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)initWindow {
    
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = baseURL;
    
    YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
    NSSet *acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"text/css", nil];
    NSString *keypath = @"jsonResponseSerializer.acceptableContentTypes";
    @try {
        [agent setValue:acceptableContentTypes forKeyPath:keypath];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
    } @finally {
        
    }
    [self setupRequestFilters];
    UINavigationBar * bar  = [UINavigationBar appearance];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -2) forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[UIImage new]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [bar setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"0xff611d"]] forBarMetrics:UIBarMetricsDefault];
    // 设置导航条前景色
    [bar setTintColor:[UIColor whiteColor]];
    // 获取导航条按钮的标识
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    // 修改返回按钮标题的位置
    [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"Registration_icon_return_White_nor"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"Registration_icon_return_White_nor"];
    if (@available(iOS 11.0,*)) {
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    self.window  = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
#if 0
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:[NSClassFromString(@"HCMemberCenterController") new]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
#else
    if ([self isFirstLauch]) {
        UIViewController * controller = [NSClassFromString(@"HCGuideIntroController") new];
        self.window.rootViewController = controller;
    }else{
        HCTabBarControllerConfig *tabBarControllerConfig = [[HCTabBarControllerConfig alloc] init];
        self.window.rootViewController = tabBarControllerConfig.tabBarController;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
#endif
}

#define HONGCAIADIMAGEURL @"hongcaiAdImageUrl"
#define HONGCAIADCLICKURL @"hongcaiAdClickUrl"
- (void)initAdWindow {
    if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
        self.adWindow = [[HCAdWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.adWindow.rootViewController = [UIViewController new];
        self.adWindow.backgroundColor = [UIColor whiteColor];
        [self configAd];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disAppear) name:@"HC_AdViewDismissNotification" object:nil];
    }
}

- (void)disAppear {
    [self.adWindow resignKeyWindow];
    self.adWindow.alpha = 0;
    self.adWindow = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HC_VIPBirthdayNotification" object:nil];
}
- (void)configAd {
    NSString *adImageUrl = [[NSUserDefaults standardUserDefaults] objectForKey:HONGCAIADIMAGEURL];
    NSString *adClickUrl = [[NSUserDefaults standardUserDefaults] objectForKey:HONGCAIADCLICKURL];
    UIImage * image = [[SDImageCache sharedImageCache] imageFromCacheForKey:adImageUrl];
    
    if (adImageUrl && [adImageUrl hasPrefix:@"http"]&& image) {
        [self.adWindow makeKeyAndVisible];
        [MBProgressHUD showAdImage:image fromView:self.adWindow imageClick:^{
            if (![adClickUrl hasPrefix:@"http"]) {
                return;
            }
            [UIView animateWithDuration:0.2 animations:^{
                self.adWindow.alpha = 0;
                [self.adWindow resignKeyWindow];
                self.adWindow = nil;
                HCTabBarController * tabVC =(HCTabBarController *) self.window.rootViewController;
                UINavigationController * nav = (UINavigationController *)tabVC.viewControllers[0];
                HCHomeController *home = (HCHomeController *)nav.viewControllers[0];
                home.isFirstLoad = YES;
                UIViewController * webVC = [[CTMediator sharedInstance] HCWebBusiness_viewController:@{HCWebBusinessUrlKey:adClickUrl}];
                webVC.hidesBottomBarWhenPushed = YES;
                NSMutableArray * controllers = [nav.viewControllers mutableCopy];
                [controllers addObject:webVC];
                [nav setViewControllers:controllers animated:NO];
                
            }];
        }];
    }else{
        self.adWindow.alpha = 0;
        [self.adWindow resignKeyWindow];
        self.adWindow = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HC_VIPBirthdayNotification" object:nil];
    }
    HCAdApi * ad = [[HCAdApi alloc] init];
    [ad startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            NSString * imageUrl = request.responseObject[@"picUrl"];
            NSString * clickUrl = request.responseObject[@"clickUrl"];
            if ([clickUrl isKindOfClass:[NSNull class]]) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:HONGCAIADCLICKURL];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:clickUrl forKey:HONGCAIADCLICKURL];
            }
            if ( ![imageUrl isKindOfClass:[NSNull class]]) {
                [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    if (finished) {
                        [[NSUserDefaults standardUserDefaults] setObject:imageUrl forKey:HONGCAIADIMAGEURL];
                    }
                }];
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:HONGCAIADIMAGEURL];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
#define hongcaiAppVersion @"hongcaiAppVersion"
#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:hongcaiAppVersion];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:hongcaiAppVersion];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}

@end
