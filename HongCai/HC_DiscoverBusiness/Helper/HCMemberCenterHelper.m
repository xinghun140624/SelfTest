//
//  HCMemberCenterHelper.m
//  HongCai
//
//  Created by Candy on 2017/11/24.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCMemberCenterHelper.h"
#import "HCMemberWelfaresTypeApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <HCUserBusiness_Category/CTMediator+HCUserBusiness.h>
@implementation HCMemberCenterHelper
+ (void)requestMemberCenterWelfareTypesData:(NSInteger)level completion:(void(^)(NSArray* models))models {
    NSDictionary * user = [[CTMediator sharedInstance] HCUserBusiness_getUser];
    HCMemberWelfaresTypeApi * api = [[HCMemberWelfaresTypeApi alloc] initWithToken:user[@"token"] level:level];
    
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            NSArray * array = [NSArray yy_modelArrayWithClass:HCMemberWelfareModel.class json:request.responseObject[@"data"]];
            models(array);
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];
}
@end
