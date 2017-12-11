//
//  CTMediator+HCGoToInvestBusiness.m
//  HCInvesetmentBusiness_Category
//
//  Created by Candy on 2017/7/6.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import "CTMediator+HCGoToInvestBusiness.h"

@implementation CTMediator (HCGoToInvestBusiness)
- (UIViewController *)HCGoToInvestBusiness_viewControllerWithgotoInvestButtonClickCallBack:(blockCallBack)gotoInvestButtonClickCallBack
                                                                              detailParams:(NSDictionary *)detailParams
{
    
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (gotoInvestButtonClickCallBack) {
        params[@"gotoInvestButtonClickCallBack"] = gotoInvestButtonClickCallBack;
    }
    if (detailParams) {
        params[@"detailParams"] = detailParams;
    }
    
    return [self performTarget:@"HCGoToInvestBusiness" action:@"gotoInvest" params:params shouldCacheTarget:NO];
}

//债权转让投资
- (UIViewController *)HCGoToTransferBusiness_viewControllerWithgotoInvestButtonClickCallBack:(blockCallBack)gotoInvestButtonClickCallBack
                                                                           detailParams:(NSDictionary *)detailParams
{

    NSMutableDictionary * params = [NSMutableDictionary dictionary];
   
    if (gotoInvestButtonClickCallBack) {
        params[@"gotoInvestButtonClickCallBack"] = gotoInvestButtonClickCallBack;
    }
    if (detailParams) {
        params[@"detailParams"] = detailParams;
    }
    
    return [self performTarget:@"HCGoToTransferBusiness" action:@"gotoTransferInvest" params:params shouldCacheTarget:NO];
    
}
- (UIViewController *)HCShowNotPayViewBusiness_viewControllerWithCountinueButtonClickCallBack:(blockCallBack)countinueButtonClickCallBack
                                                                                 detailParams:(NSDictionary *)detailParams {


    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (countinueButtonClickCallBack) {
        params[@"countinueButtonClickCallBack"] = countinueButtonClickCallBack;
    }
   
    if (detailParams) {
        params[@"detailParams"] = detailParams;
    }
    return [self performTarget:@"HCShowNotPayViewBusiness" action:@"showNotPayOrderView" params:params shouldCacheTarget:NO];
}
@end
