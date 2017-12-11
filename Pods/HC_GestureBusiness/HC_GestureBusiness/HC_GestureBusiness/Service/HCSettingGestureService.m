//
//  HCSettingGestureService.m
//  HongCai
//
//  Created by 郭金山 on 2017/8/14.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCSettingGestureService.h"
#import "HCGetUserGesturePasswordApi.h"
#import "HCDeleteUserGesturePasswordApi.h"
#import "HCUpdateUserGesturePasswordApi.h"
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import "HCSettingLockController.h"
@implementation HCSettingGestureService
+ (void)getUserGesture:(void(^)(BOOL success,NSString *gesture))success {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        HCGetUserGesturePasswordApi * api = [[HCGetUserGesturePasswordApi alloc] initWithToken:user[@"token"]];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (request.responseJSONObject) {
                NSString * gesture = [NSString stringWithFormat:@"%@",request.responseJSONObject[@"gesture"]];
                if (gesture.length>=4) {
                    if (success) {
                        success(YES,gesture);
                    }
                }else{
                    if (success) {
                        success(YES,nil);
                    }
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
            NSString *savedUserGesturekey = [NSString stringWithFormat:@"%@_%zd",@"HC_UserGesturePassword",[user[@"id"] integerValue]];
            NSString * savedGesture = [[NSUserDefaults standardUserDefaults] valueForKey:savedUserGesturekey];
            if (savedGesture.length>=4) {
                success(YES,savedGesture);
            }else{
                success(NO,nil);
            }
        }];
    }
    
}
+ (void)deleteUserGesture:(void(^)(BOOL success))success {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        HCDeleteUserGesturePasswordApi * api = [[HCDeleteUserGesturePasswordApi alloc] initWithToken:user[@"token"]];
        [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
            if (request.responseJSONObject) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (success) {
                success(NO);
            }
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
        }];
    }
}
+ (void)updateUserGesture:(NSString *)gesture success:(void (^)(BOOL success))success {
    
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    if (user) {
        HCUpdateUserGesturePasswordApi * api = [[HCUpdateUserGesturePasswordApi alloc] initWithGesture: gesture token:user[@"token"]];
        [MBProgressHUD showLoadingFromView:[UIApplication sharedApplication].keyWindow];
        
        [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
            if (request.responseJSONObject) {
                if (success) {
                    success(YES);
                }
            }else{
                if (success) {
                    success(NO);
                }
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            if (success) {
                success(NO);
            }
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
        }];
    }
}
+ (void)checkUserIsAppearReconmandSettingGesturePassword    {
    
    [HCSettingGestureService getUserGesture:^(BOOL success, NSString *gesture) {
        
        NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
        NSString *userGestureKey = [NSString stringWithFormat:@"%@_%zd",@"HC_JumpGesturePassword",[user[@"id"] integerValue]];
        NSNumber * key = [[NSUserDefaults standardUserDefaults] objectForKey:userGestureKey];
        if (success&&(gesture.length <4 && key.integerValue==0)) {
            HCSettingLockController * lock = [[HCSettingLockController alloc] init];
            lock.type = GestureViewControllerTypeRecommand;
            if (![UIApplication sharedApplication].keyWindow.rootViewController.presentingViewController) {
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:lock animated:NO completion:NULL];
            }
        }
        if (success && gesture.length>=4) {
            NSString *savedUserGesturekey = [NSString stringWithFormat:@"%@_%zd",@"HC_UserGesturePassword",[user[@"id"] integerValue]];
            [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:savedUserGesturekey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
}

@end
