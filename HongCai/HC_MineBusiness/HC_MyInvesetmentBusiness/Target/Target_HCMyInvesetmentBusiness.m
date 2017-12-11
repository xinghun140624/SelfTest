//
//  Target_HCMyInvesetmentBusiness.m
//  Pods
//
//  Created by Candy on 2017/6/27.
//
//

#import "Target_HCMyInvesetmentBusiness.h"
#import "HCMyInvestmentController.h"

@implementation Target_HCMyInvesetmentBusiness
- (UIViewController *)Action_viewController:(NSDictionary *)params {
    HCMyInvestmentController * viewController = [[HCMyInvestmentController alloc] init];
    return viewController;
}
@end
