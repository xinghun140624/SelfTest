//
//  HCDiscoverService.m
//  HongCai
//
//  Created by Candy on 2017/7/22.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCDiscoverService.h"
#import "HCBannerActivityApi.h"
#import "HCUserMemberApi.h"
@implementation HCDiscoverService

+ (void)getDiscoverData:(void(^)(NSArray * acvitityModels,NSArray *bottomActivityModels))models errorMessage:(void(^)(NSString *errorMessage))errorMessage {

    //上方活动
    HCBannerActivityApi * activityApi = [[HCBannerActivityApi alloc] initWithToken:nil type:3 locale:2 count:4];
    
    //下方活动
    HCBannerActivityApi * bottomActivityApi = [[HCBannerActivityApi alloc] initWithToken:nil type:3 locale:1 count:4];
    
    
    YTKBatchRequest * batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[activityApi,bottomActivityApi]];
    
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest * _Nonnull batchRequest) {
        
        NSArray *requests = batchRequest.requestArray;
        HCBannerActivityApi * activityApi=  (HCBannerActivityApi*)requests[0];
        NSArray * activityModels = [NSArray yy_modelArrayWithClass:[HCActivityModel class] json:activityApi.responseObject[@"data"]];
        
        HCBannerActivityApi * bottomActivityApi=  (HCBannerActivityApi*)requests[1];
        NSArray * bottomActivityModels = [NSArray yy_modelArrayWithClass:[HCActivityModel class] json:bottomActivityApi.responseObject[@"data"]];
        if (models) {
            models(activityModels,bottomActivityModels);
        }
        
        
    } failure:^(YTKBatchRequest * _Nonnull batchRequest) {
        if (errorMessage) {
            if (batchRequest.failedRequest.responseJSONObject) {
                errorMessage(batchRequest.failedRequest.responseJSONObject[@"msg"]);
            }else{
                errorMessage(batchRequest.failedRequest.error.localizedDescription);
            }
        }
        
    }];
}
+ (void)getUserMemberWithToken:(NSString *)token completeHanlder:(void(^)(HCUserMemberModel *model))completeHanlder {
    
    HCUserMemberApi * api = [[HCUserMemberApi alloc] initWithToken:token];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseObject) {
            HCUserMemberModel * model = [HCUserMemberModel yy_modelWithJSON:request.responseObject];
            if (completeHanlder) {
                completeHanlder(model);
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}
@end
