//
//  CTMediator+HCGoToInvestBusiness.h
//  HCInvesetmentBusiness_Category
//
//  Created by Candy on 2017/7/6.
//  Copyright © 2017年 hoolai. All rights reserved.
//

#import <CTMediator/CTMediator.h>

typedef void(^blockCallBack)(NSDictionary * info);


@interface CTMediator (HCGoToInvestBusiness)
//投资
- (UIViewController *)HCGoToInvestBusiness_viewControllerWithgotoInvestButtonClickCallBack:(blockCallBack)gotoInvestButtonClickCallBack
                                                                              detailParams:(NSDictionary *)detailParams;
//债权转让投资
- (UIViewController *)HCGoToTransferBusiness_viewControllerWithgotoInvestButtonClickCallBack:(blockCallBack)gotoInvestButtonClickCallBack
                                                                                detailParams:(NSDictionary *)detailParams;


//显示未支付订单
- (UIViewController *)HCShowNotPayViewBusiness_viewControllerWithCountinueButtonClickCallBack:(blockCallBack)countinueButtonClickCallBack
                                                                                 detailParams:(NSDictionary *)detailParams;
@end
