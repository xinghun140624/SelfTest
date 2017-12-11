//
//  HCInvestmentService.m
//  HongCai
//
//  Created by Candy on 2017/7/1.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "HCInvestmentService.h"
#import "HCProjectApi.h"
#import "HCAssignmentsApi.h"
#import <JSToastBusiness/MBProgressHUD+JSToast.h>
#import <JSToastBusiness/MBProgressHUD+HCLoading.h>
#import "HCProjectModel.h"
#import "HCAssignmentModel.h"

@implementation HCInvestmentService
+ (void)getInvestmentDataWithPage:(NSInteger)page type:(NSInteger)type successCallBack:(void(^)(NSArray*models,BOOL finished))successCallBack {
    HCProjectApi * api = [[HCProjectApi alloc] initWithPage:page pageSize:5 type:type];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
    
        if ( request.responseJSONObject) {
            HCProjectModel * project = [HCProjectModel yy_modelWithJSON:request.responseJSONObject];
            [project.projectList enumerateObjectsUsingBlock:^(HCProjectSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString * name = project.projectStatusMap[[obj.status stringValue]];
                obj.typeName =name;
            }];
            if (project.projectList.count) {
                if (successCallBack) {
                    if (page== [request.responseJSONObject[@"totalPage"] integerValue]) {
                        successCallBack(project.projectList,YES);
                    }else{
                        successCallBack(project.projectList,NO);
                    }
                }
            }else{
                successCallBack(nil,YES);
            }
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {
            [MBProgressHUD showText:request.responseJSONObject[@"msg"]];
        }else{
            [MBProgressHUD showText:request.error.localizedDescription];
        }
    }];

}
+ (void)getAssignmentsDataWithPage:(NSInteger)page successCallBack:(void(^)(NSArray*models,BOOL finished))successCallBack {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"page"] = @(page);
    params[@"pageSize"] = @(5);
    HCAssignmentsApi * api = [[HCAssignmentsApi alloc] initWithParams:params];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        if (request.responseJSONObject) {

            NSArray * array =  [NSArray yy_modelArrayWithClass:[HCAssignmentModel class] json:request.responseObject[@"data"]];
            
            if (array.count) {
                if (successCallBack) {
                    if (page== [request.responseJSONObject[@"totalPage"] integerValue]) {
                        successCallBack(array,YES);
                    }else{
                        successCallBack(array,NO);
                    }
                }
            }else{
                successCallBack(nil,YES);
            }
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
