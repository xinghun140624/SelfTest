//
//  HCHomeService.m
//  HongCai
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCHomeService.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>

#import "HCBannerModel.h"
#import "HCProjectModel.h"
#import "HCActivityModel.h"
#import "HCNoticeModel.h"

#import "HCHome_BannerApi.h"
#import "HCProjectApi.h"
#import "HCBannerActivityApi.h"
#import "HCShowNewUserFloatApi.h"
#import "HCNoticesApi.h"
#import "HCSystemVersionApi.h"
@implementation HCHomeService

+ (void)getUserShowNewUserFloat:(void(^)(BOOL isAppear))isAppear {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        HCShowNewUserFloatApi * showFloatApi = [[HCShowNewUserFloatApi alloc] initWithToken:user[@"token"]];
        [showFloatApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseObject) {
                if (isAppear) {
                    isAppear([request.responseObject[@"show"] boolValue]);
                }
            }else{
                if (isAppear) {
                    isAppear(NO);
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (isAppear) {
                isAppear(NO);
            }
            if (request.responseObject) {
                [MBProgressHUD showText:request.responseObject[@"msg"]];
            }else{
                [MBProgressHUD showText:request.error.localizedDescription];
            }
        }];
    }else{
        if (isAppear) {
            isAppear(NO);
        }
    }
}

+ (void)getHomeProjectData:(void(^)(NSArray * projectModels))projectModels errorMessage:(void(^)(NSString *errorMessage))errorMessage
{
    //精选
    HCProjectApi * projectApi1 = [[HCProjectApi alloc] initWithPage:1 pageSize:1 type:5];
    //尊贵
    HCProjectApi * projectApi2 = [[HCProjectApi alloc] initWithPage:1 pageSize:1 type:6];
    YTKBatchRequest * batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[projectApi1,projectApi2]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSArray *requests = batchRequest.requestArray;
        HCProjectApi *projectApi1 = (HCProjectApi *)requests[0];
        HCProjectModel * project1 = [HCProjectModel yy_modelWithJSON:projectApi1.responseObject];
        HCProjectApi *projectApi2 = (HCProjectApi *)requests[1];
        HCProjectModel * project2 = [HCProjectModel yy_modelWithJSON:projectApi2.responseObject];
        if (projectModels) {
            projectModels(@[project1,project2]);
        }
    } failure:^(YTKBatchRequest *batchRequest) {
        if (errorMessage) {
            if (batchRequest.failedRequest.responseJSONObject) {
                errorMessage(batchRequest.failedRequest.responseJSONObject[@"msg"]);
            }else{
                errorMessage(batchRequest.failedRequest.error.localizedDescription);
            }
        }
    }];
}

+ (void)getHomeData:(void(^)(NSArray *bannerModels,NSArray *noticeModels,NSArray *activiyModels,NSArray *projectModels,HCActivityModel * activityRemindingModel))homeData errorMessage:(void(^)(NSString *errorMessage))errorMessage
{
    NSDictionary * user  = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    HCHome_BannerApi * bannerApi = [[HCHome_BannerApi alloc] initWithToken:user[@"token"] type:3];
    HCBannerActivityApi * activityApi = [[HCBannerActivityApi alloc] initWithToken:user?user[@"token"]:nil type:3 locale:3 count:4];
    HCNoticesApi * noticeApi = [[HCNoticesApi alloc] initWithPage:1 pageSize:3];
    
    //精选
    HCProjectApi * projectApi1 = [[HCProjectApi alloc] initWithPage:1 pageSize:1 type:5];
    //尊贵
    HCProjectApi * projectApi2 = [[HCProjectApi alloc] initWithPage:1 pageSize:1 type:6];
    
    HCBannerActivityApi * activityRemindingApi = [[HCBannerActivityApi alloc] initWithToken:user?user[@"token"]:nil type:3 locale:5 count:1];
    
    YTKBatchRequest * batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[bannerApi,activityApi,noticeApi,projectApi1,projectApi2,activityRemindingApi]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSArray *requests = batchRequest.requestArray;
        HCHome_BannerApi *bannerApi = (HCHome_BannerApi *)requests[0];
        NSArray * bannerModels=  nil;
        if ([bannerApi.responseObject isKindOfClass:[NSArray class]]) {
            bannerModels = [NSArray yy_modelArrayWithClass:[HCBannerModel class] json:bannerApi.responseObject];
        }else{
            bannerModels = [NSArray yy_modelArrayWithClass:[HCBannerModel class] json:bannerApi.responseObject[@"data"]];
        }
        HCBannerActivityApi * activityApi=  (HCBannerActivityApi*)requests[1];
        NSArray * activityModels = [NSArray yy_modelArrayWithClass:[HCActivityModel class] json:activityApi.responseObject[@"data"]];
        HCNoticesApi *noticeApi =(HCNoticesApi*)requests[2];
        NSArray * notictModels =  [NSArray yy_modelArrayWithClass:[HCNoticeModel class] json:noticeApi.responseObject[@"data"]];
        HCProjectApi *projectApi1 = (HCProjectApi *)requests[3];
        HCProjectModel * project1 = [HCProjectModel yy_modelWithJSON:projectApi1.responseObject];
        
        HCProjectApi *projectApi2 = (HCProjectApi *)requests[4];
        HCProjectModel * project2 = [HCProjectModel yy_modelWithJSON:projectApi2.responseObject];
        HCBannerActivityApi * activityRemindingApi = (HCBannerActivityApi *)requests[5];
        NSArray * activityRemaindingModels = [NSArray yy_modelArrayWithClass:[HCActivityModel class] json:activityRemindingApi.responseObject[@"data"]];

        if (homeData) {
            homeData(bannerModels,notictModels,activityModels,@[project1,project2],activityRemaindingModels.firstObject);
        }
    } failure:^(YTKBatchRequest *batchRequest) {
        if (errorMessage) {
            if (batchRequest.failedRequest.responseJSONObject) {
                errorMessage(batchRequest.failedRequest.responseJSONObject[@"msg"]);
            }else{
                errorMessage(batchRequest.failedRequest.error.localizedDescription);
            }
        }
    }];
}
+ (void)getUpdateSystemVersion:(UIViewController *)controller {
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    HCSystemVersionApi * api = [[HCSystemVersionApi alloc] initWithOs:@"IOS" appVersion:currentAppVersion];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            NSInteger forceLevel = [request.responseObject[@"forceLevel"] integerValue];
            switch (forceLevel) {
                case 0:
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"forceLevel"];
                }
                    break;
                case 1://强制更新
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"forceLevel"];
                    [self hanlderUpdateVersion:request.responseObject forceLevel:forceLevel controller:controller];
                }
                    break;
                case 2://提示更新
                {
                    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"forceLevel"];
                    [self hanlderUpdateVersion:request.responseObject forceLevel:forceLevel controller:controller];
                }
                    break;
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseStatusCode==204) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"forceLevel"];
        };
    }];
}
+ (void)hanlderUpdateVersion:(id)responseObject  forceLevel:(NSInteger)forceLevel controller:(UIViewController *)controller{
    if (!responseObject) {
        return;
    }
    NSArray * messageArray = responseObject[@"infos"];
    if (!messageArray||[messageArray isEqual:[NSNull null]]) {
        return;
    }
    NSMutableString * string = [[NSMutableString alloc] init];
    if (messageArray.count>1) {
        [messageArray enumerateObjectsUsingBlock:^(NSDictionary * info, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx==messageArray.count-1) {
                //最后一条;
                [string appendFormat:@"%zd、%@",idx+1,info[@"info"]];
            }else{
                [string appendFormat:@"%zd、%@\n",idx+1,info[@"info"]];
            }
        }];
    }else{
        [string appendString:messageArray.firstObject[@"info"]];
    }
    
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"发现新版本" message:string preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSURL * URL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/%E5%AE%8F%E8%B4%A2%E7%BD%91/id1153576958?mt=8"];
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            if ([[UIDevice currentDevice].systemVersion floatValue]>=10.0) {
                [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:NULL];
            }else{
                [[UIApplication sharedApplication] openURL:URL];
            }
        }
    }]];
    if (forceLevel==2) {
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"forceLevel"];
        }]];
    }
    id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if([rootViewController isKindOfClass:[UINavigationController class]])
    {
        rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
    }
    if([rootViewController isKindOfClass:[UITabBarController class]])
    {
        rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
    }
    if ([[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController isKindOfClass:NSClassFromString(@"HCSettingLockController")]) {
        rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    [rootViewController presentViewController:alertVC animated:YES completion:nil];
}
@end
